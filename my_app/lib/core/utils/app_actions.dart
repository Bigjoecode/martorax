import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

void _snack(BuildContext c, String m, {bool error = false}) {
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(
    content: Text(m),
    backgroundColor: error ? Colors.red.shade700 : AppColors.emerald600,
  ));
}

/// Opens the phone dialer for [phone]. Shows a hint if none is available.
Future<void> dialPhone(BuildContext context, String? phone) async {
  final p = (phone ?? '').trim();
  if (p.isEmpty) {
    _snack(context, 'No phone number available yet', error: true);
    return;
  }
  final uri = Uri(scheme: 'tel', path: p);
  try {
    if (!await launchUrl(uri)) {
      if (context.mounted) _snack(context, 'Could not open dialer', error: true);
    }
  } catch (_) {
    if (context.mounted) _snack(context, 'Could not open dialer', error: true);
  }
}

/// Shares free text via the system share sheet.
Future<void> shareText(String text) async {
  await Share.share(text);
}

/// SOS: confirm, then dial the Nigerian emergency line (112).
Future<void> triggerSos(BuildContext context) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.cardBg,
      title: const Text('Emergency SOS', style: TextStyle(color: Colors.white)),
      content: const Text(
        'This will call the emergency line (112). Use only in a real emergency.',
        style: TextStyle(color: AppColors.slate400),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(color: AppColors.slate400)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Call 112'),
        ),
      ],
    ),
  );
  if (confirm == true && context.mounted) {
    await dialPhone(context, '112');
  }
}
