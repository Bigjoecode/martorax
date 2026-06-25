-- ==========================================
-- MARTORAX: DATABASE SCHEMA & ESCROW SECURITY BLUEPRINT
-- Location: lib/core/supabase/supabase_schema.sql
-- ==========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Custom user role enum
CREATE TYPE app_role AS ENUM ('shopper', 'vendor', 'provider', 'rider');

-- Custom escrow status state-machine enum
CREATE TYPE escrow_status AS ENUM ('held', 'released', 'disputed', 'resolved');

-- ==========================================
-- 1. PROFILES TABLE
-- ==========================================
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    active_role app_role DEFAULT 'shopper'::app_role,
    phone_number TEXT,
    landmark_address TEXT DEFAULT 'Opp. Nnebisi Junction, Asaba',
    rating NUMERIC(3,2) DEFAULT 5.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
CREATE POLICY "Public profiles are viewable by everyone" 
    ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile details" 
    ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- ==========================================
-- 2. PRODUCTS TABLE
-- ==========================================
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    wholesale_price NUMERIC(12,2),
    wholesale_min_qty INTEGER DEFAULT 5,
    image_url TEXT,
    location TEXT DEFAULT 'Asaba',
    stock INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on products
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Products Policies
CREATE POLICY "Anyone can browse active products" 
    ON public.products FOR SELECT USING (true);

CREATE POLICY "Vendors can manage their own product listings" 
    ON public.products FOR ALL USING (
        auth.uid() = vendor_id AND 
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND active_role = 'vendor'::app_role
        )
    );

-- ==========================================
-- 3. ORDERS TABLE
-- ==========================================
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buyer_id UUID REFERENCES public.profiles(id) NOT NULL,
    seller_id UUID REFERENCES public.profiles(id) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    delivery_status TEXT DEFAULT 'pending' NOT NULL,
    landmark_destination TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on orders
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Orders Policies
CREATE POLICY "Shoppers can view their purchased orders" 
    ON public.orders FOR SELECT USING (auth.uid() = buyer_id);

CREATE POLICY "Sellers can view orders assigned to their store" 
    ON public.orders FOR SELECT USING (auth.uid() = seller_id);

CREATE POLICY "Shoppers can create new order drafts" 
    ON public.orders FOR INSERT WITH CHECK (auth.uid() = buyer_id);

-- ==========================================
-- 4. SAFEPAY ESCROW LEDGER TABLE
-- ==========================================
CREATE TABLE public.escrow_ledger (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
    hold_code TEXT UNIQUE NOT NULL,
    buyer_id UUID REFERENCES public.profiles(id) NOT NULL,
    provider_id UUID REFERENCES public.profiles(id) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    status escrow_status DEFAULT 'held'::escrow_status NOT NULL,
    released_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on escrow_ledger
ALTER TABLE public.escrow_ledger ENABLE ROW LEVEL SECURITY;

-- Escrow Policies
CREATE POLICY "Involved parties can read escrow statements" 
    ON public.escrow_ledger FOR SELECT USING (
        auth.uid() = buyer_id OR auth.uid() = provider_id
    );

-- ==========================================
-- 5. ESCROW DISPUTES TABLE
-- ==========================================
CREATE TABLE public.escrow_disputes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escrow_id UUID REFERENCES public.escrow_ledger(id) ON DELETE CASCADE NOT NULL,
    dispute_code TEXT UNIQUE NOT NULL,
    reason TEXT NOT NULL,
    details TEXT,
    evidence_urls TEXT[],
    is_resolved BOOLEAN DEFAULT false NOT NULL,
    mediator_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on escrow_disputes
ALTER TABLE public.escrow_disputes ENABLE ROW LEVEL SECURITY;

-- Disputes Policies
CREATE POLICY "Involved parties can read dispute files" 
    ON public.escrow_disputes FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.escrow_ledger 
            WHERE id = escrow_id AND (buyer_id = auth.uid() OR provider_id = auth.uid())
        )
    );

-- ==========================================
-- 5B. REAL-TIME CHAT MESSAGES TABLE (Phase 1)
-- ==========================================
CREATE TABLE public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_room_id TEXT NOT NULL,
    sender_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    receiver_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    message_content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Messages Policies
CREATE POLICY "Users can view chats they participate in" 
    ON public.messages FOR SELECT USING (
        auth.uid() = sender_id OR auth.uid() = receiver_id
    );

CREATE POLICY "Users can send messages to chat rooms" 
    ON public.messages FOR INSERT WITH CHECK (
        auth.uid() = sender_id
    );

-- ==========================================
-- 6. SECURE PL/pgSQL ESCROW TRANSACTION FUNCTIONS
-- ==========================================

-- SECURE PAYMENT RELEASE RPC
CREATE OR REPLACE FUNCTION public.release_escrow_payment(p_hold_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    v_escrow_id UUID;
    v_buyer_id UUID;
    v_amount NUMERIC(12,2);
    v_status escrow_status;
BEGIN
    -- Select with row-level transaction locking to prevent race conditions
    SELECT id, buyer_id, amount, status 
    INTO v_escrow_id, v_buyer_id, v_amount, v_status
    FROM public.escrow_ledger
    WHERE hold_code = p_hold_code
    FOR UPDATE;

    -- Guard clause: Escrow must exist
    IF v_escrow_id IS NULL THEN
        RAISE EXCEPTION 'Escrow matching hold code % not found.', p_hold_code;
    END IF;

    -- Guard clause: Only the shopper/buyer who paid the funds can trigger release
    IF v_buyer_id != auth.uid() THEN
        RAISE EXCEPTION 'Access Denied: Only the buying shopper can release held escrow funds.';
    END IF;

    -- Guard clause: Escrow must be in 'held' status to release
    IF v_status != 'held'::escrow_status THEN
        RAISE EXCEPTION 'Conflict: This escrow is currently %, payments cannot be re-released.', v_status;
    END IF;

    -- Secure state transition
    UPDATE public.escrow_ledger
    SET status = 'released'::escrow_status,
        released_at = now()
    WHERE id = v_escrow_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- SECURE DISPUTE INITIATION RPC
CREATE OR REPLACE FUNCTION public.initiate_escrow_dispute(
    p_hold_code TEXT,
    p_reason TEXT,
    p_details TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    v_escrow_id UUID;
    v_buyer_id UUID;
    v_provider_id UUID;
    v_status escrow_status;
BEGIN
    -- Select and lock record
    SELECT id, buyer_id, provider_id, status 
    INTO v_escrow_id, v_buyer_id, v_provider_id, v_status
    FROM public.escrow_ledger
    WHERE hold_code = p_hold_code
    FOR UPDATE;

    -- Guard checks
    IF v_escrow_id IS NULL THEN
        RAISE EXCEPTION 'Escrow contract matching hold code % not found.', p_hold_code;
    END IF;

    -- Access check: Only the buyer or provider can raise a dispute
    IF auth.uid() != v_buyer_id AND auth.uid() != v_provider_id THEN
        RAISE EXCEPTION 'Access Denied: Only contract participants can raise disputes.';
    END IF;

    -- Check state
    IF v_status != 'held'::escrow_status THEN
        RAISE EXCEPTION 'Conflict: Cannot dispute escrow in % status.', v_status;
    END IF;

    -- Update escrow state
    UPDATE public.escrow_ledger
    SET status = 'disputed'::escrow_status
    WHERE id = v_escrow_id;

    -- File dispute log
    INSERT INTO public.escrow_disputes (
        escrow_id,
        dispute_code,
        reason,
        details
    ) VALUES (
        v_escrow_id,
        'DISP-' || UPPER(SUBSTRING(p_hold_code FROM 5 FOR 8)),
        p_reason,
        p_details
    );

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- 7. RIDER GPS TRACKING SCHEMA (Phase 3)
-- ==========================================
CREATE TABLE public.rider_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rider_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
    latitude NUMERIC(10, 8) NOT NULL,
    longitude NUMERIC(11, 8) NOT NULL,
    bearing NUMERIC(5, 2) DEFAULT 0.0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.rider_tracking ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can read rider coordinates for active orders" 
    ON public.rider_tracking FOR SELECT USING (true);

CREATE POLICY "Riders can update their own coordinates" 
    ON public.rider_tracking FOR ALL USING (auth.uid() = rider_id);

