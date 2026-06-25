import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../supabase/supabase_config.dart';

/// Bottom sheet to request a payout. Inserts a row into `payout_requests`
/// which the admin processes. [available] is shown as the max balance.
Future<void> showWithdrawSheet(
    BuildContext context, WidgetRef ref, double available) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardBg,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _WithdrawForm(available: available, parentRef: ref),
  );
}

class _WithdrawForm extends StatefulWidget {
  final double available;
  final WidgetRef parentRef;
  const _WithdrawForm({required this.available, required this.parentRef});

  @override
  State<_WithdrawForm> createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<_WithdrawForm> {
  final _amount = TextEditingController();
  final _bank = TextEditingController();
  final _acct = TextEditingController();
  final _name = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _bank.dispose();
    _acct.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount', error: true);
      return;
    }
    if (amount > widget.available) {
      _snack('Amount exceeds your balance', error: true);
      return;
    }
    final user = widget.parentRef.read(currentUserProvider);
    if (user == null) return;
    setState(() => _busy = true);
    try {
      await SupabaseConfig.client.from('payout_requests').insert({
        'user_id': user.id,
        'amount': amount,
        'bank_name': _bank.text.trim(),
        'account_number': _acct.text.trim(),
        'account_name': _name.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context);
      _snack('Withdrawal requested. You will be paid out shortly.');
    } catch (e) {
      _snack('Could not request: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String m, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: error ? Colors.red.shade700 : AppColors.emerald600,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.slate700,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Withdraw funds',
              style: GoogleFonts.manrope(
                  fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          Text('Available: ₦${widget.available.toStringAsFixed(0)}',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate400)),
          const SizedBox(height: 16),
          _field(_amount, 'Amount (₦)', keyboard: TextInputType.number),
          const SizedBox(height: 10),
          _field(_bank, 'Bank name'),
          const SizedBox(height: 10),
          _field(_acct, 'Account number', keyboard: TextInputType.number),
          const SizedBox(height: 10),
          _field(_name, 'Account name'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _busy ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.2, color: Colors.white))
                  : Text('Request withdrawal',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {TextInputType? keyboard}) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
        filled: true,
        fillColor: AppColors.darkBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.slate700)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.slate700)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.emerald600)),
      ),
    );
  }
}
