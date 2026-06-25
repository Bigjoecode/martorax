import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Handles KYC document upload + verification state transitions.
///
/// Documents go to the private `kyc-docs` storage bucket under the user's id;
/// only the storage path is kept on the profile. The admin dashboard reads them
/// with the service-role key (signed URLs) to approve or reject.
class KycService {
  static const String bucket = 'kyc-docs';

  SupabaseClient get _client => SupabaseConfig.client;

  /// Uploads the ID document + selfie and flips the profile to `pending`.
  /// Returns true on success.
  Future<bool> submit({
    required String idType,
    required Uint8List idImage,
    required Uint8List selfieImage,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return false;
    try {
      final idPath = '${user.id}/id.jpg';
      final selfiePath = '${user.id}/selfie.jpg';

      await _client.storage.from(bucket).uploadBinary(
            idPath,
            idImage,
            fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
          );
      await _client.storage.from(bucket).uploadBinary(
            selfiePath,
            selfieImage,
            fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
          );

      await _client.from('profiles').update({
        'kyc_status': 'pending',
        'kyc_id_type': idType,
        'kyc_id_url': idPath,
        'kyc_selfie_url': selfiePath,
        'kyc_submitted_at': DateTime.now().toUtc().toIso8601String(),
        'kyc_reject_reason': null,
      }).eq('id', user.id);

      return true;
    } catch (_) {
      return false;
    }
  }
}
