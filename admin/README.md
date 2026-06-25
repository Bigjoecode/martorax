# MartoraX Admin

A Next.js (App Router) control panel for the MartoraX marketplace. It talks
directly to the **same Supabase Postgres** the mobile app uses — no separate
database, no sync.

## What it controls

- **Dashboard** — live users, products, orders, GMV, escrow held, open disputes
- **Users** — view profiles, change roles (shopper/vendor/provider/rider), delete accounts
- **Products** — adjust stock, remove listings
- **Orders** — override delivery status
- **Escrow (SafePay)** — release funds to provider or refund the buyer
- **Disputes** — resolve with a release-to-provider or refund-buyer decision
- **Riders** — registered riders + their latest GPS ping (links to Google Maps)

## Security model

- Admins sign in with **Supabase Auth** (email + password).
- Only emails in the `ADMIN_EMAILS` allowlist can enter (enforced in
  `middleware.ts` + `requireAdmin()` on every page and server action).
- All data reads/writes run **server-side** with the Supabase `service_role`
  key, which never reaches the browser. Mutations are Server Actions.

## Environment variables

Copy `.env.example` to `.env.local` (local) and set the same in Vercel:

| Var | Where to find it |
|-----|------------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase > Project Settings > API > Project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase > Project Settings > API > anon public |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase > Project Settings > API > **service_role** (secret) |
| `ADMIN_EMAILS` | Comma-separated emails allowed to sign in |

## Local development

```bash
cd admin
npm install
cp .env.example .env.local   # then fill in the values
npm run dev                  # http://localhost:3000
```

## Prerequisites in Supabase

1. The database schema must exist. If it isn't applied yet, paste
   `../my_app/lib/core/supabase/supabase_schema.sql` (and the files in
   `../my_app/supabase/migrations/`) into the Supabase SQL Editor and run them.
2. Create your admin account: Supabase > Authentication > Users > Add user
   (email + password). Make sure that email is in `ADMIN_EMAILS`.

## Deploy to Vercel

```bash
cd admin
vercel            # link/create the project
vercel env add SUPABASE_SERVICE_ROLE_KEY   # + the other three vars
vercel --prod
```

Set the same four env vars under Vercel Project Settings > Environment Variables.
