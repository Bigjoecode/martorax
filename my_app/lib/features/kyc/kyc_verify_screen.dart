import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/data_providers.dart';
import '../../core/supabase/kyc_service.dart';

/// Real identity-verification capture: pick an ID type, upload the ID document
/// and a selfie. Submitting flips the profile to `pending` for admin review.
class KycVerifyScreen extends ConsumerStatefulWidget {
  const KycVerifyScreen({super.key});

  @override
  ConsumerState<KycVerifyScreen> createState() => _KycVerifyScreenState();
}

class _KycVerifyScreenState extends ConsumerState<KycVerifyScreen> {
  static const _idTypes = [
    'NIN Slip',
    "Driver's License",
    "Voter's Card",
    'International Passport',
  ];
  String _idType = _idTypes.first;
  Uint8List? _idImage;
  Uint8List? _selfie;
  bool _submitting = false;

  final _picker = ImagePicker();

  Future<void> _pick(bool isSelfie) async {
    try {
      final x = await _picker.pickImage(
        source: isSelfie ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1600,
      );
      if (x == null) return;
      final bytes = await x.readAsBytes();
      setState(() {
        if (isSelfie) {
          _selfie = bytes;
        } else {
          _idImage = bytes;
        }
      });
    } catch (e) {
      _snack('Could not pick image: $e', isError: true);
    }
  }

  Future<void> _submit() async {
    if (_idImage == null || _selfie == null) {
      _snack('Please add both your ID and a selfie', isError: true);
      return;
    }
    setState(() => _submitting = true);
    final ok = await KycService().submit(
      idType: _idType,
      idImage: _idImage!,
      selfieImage: _selfie!,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      ref.invalidate(currentProfileProvider);
      _snack('Submitted! Your documents are under review.');
      _routeOnward();
    } else {
      _snack('Upload failed. Please try again.', isError: true);
    }
  }

  void _routeOnward() {
    final role = ref.read(currentRoleProvider);
    switch (role) {
      case 'vendor':
        context.go('/vendor/dashboard');
        break;
      case 'provider':
        context.go('/provider/dashboard');
        break;
      case 'rider':
        context.go('/rider/dashboard');
        break;
      default:
        context.go('/home');
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : AppColors.emerald600,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(kycStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.canPop() ? context.pop() : _routeOnward(),
        ),
        title: Text('Identity Verification',
            style: GoogleFonts.manrope(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status != 'unverified') _StatusBanner(status: status),
              if (status != 'unverified') const SizedBox(height: 20),
              Text('Verify your identity',
                  style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                  'Required to receive payouts and build trust. Your documents are private and reviewed by our team.',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.slate400)),
              const SizedBox(height: 24),
              Text('ID TYPE',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate700),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _idType,
                    isExpanded: true,
                    dropdownColor: AppColors.cardBg,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                    items: _idTypes
                        .map((t) =>
                            DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _idType = v ?? _idType),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _UploadTile(
                label: 'ID Document',
                hint: 'Upload a clear photo of your $_idType',
                icon: Icons.badge_rounded,
                image: _idImage,
                onTap: () => _pick(false),
              ),
              const SizedBox(height: 14),
              _UploadTile(
                label: 'Selfie',
                hint: 'Take a selfie holding your ID',
                icon: Icons.camera_front_rounded,
                image: _selfie,
                onTap: () => _pick(true),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white))
                      : Text('Submit for verification',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _routeOnward,
                  child: Text('Skip for now',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.slate400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color c;
    late IconData icon;
    late String msg;
    switch (status) {
      case 'verified':
        c = AppColors.emerald600;
        icon = Icons.verified_rounded;
        msg = 'Your identity is verified.';
        break;
      case 'rejected':
        c = Colors.red;
        icon = Icons.error_rounded;
        msg = 'Your last submission was rejected. Please re-submit.';
        break;
      default:
        c = AppColors.amber500;
        icon = Icons.hourglass_top_rounded;
        msg = 'Your documents are under review.';
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: c, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(msg,
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600, color: c)),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Uint8List? image;
  final VoidCallback onTap;
  const _UploadTile({
    required this.label,
    required this.hint,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: image != null
                  ? AppColors.emerald600
                  : AppColors.slate700),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceBg,
                borderRadius: BorderRadius.circular(10),
                image: image != null
                    ? DecorationImage(image: MemoryImage(image!), fit: BoxFit.cover)
                    : null,
              ),
              child: image == null
                  ? Icon(icon, color: AppColors.emerald600, size: 26)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(image != null ? 'Tap to change' : hint,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.slate400)),
                ],
              ),
            ),
            Icon(
              image != null
                  ? Icons.check_circle_rounded
                  : Icons.add_a_photo_rounded,
              color: image != null ? AppColors.emerald600 : AppColors.slate400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
