import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';

/// Streams every auth state change from Supabase.
/// UI can `ref.watch(authStateProvider)` and react to login/logout instantly.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange;
});

/// The currently signed-in user (or null if signed out).
final currentUserProvider = Provider<User?>((ref) {
  final state = ref.watch(authStateProvider).valueOrNull;
  return state?.session?.user ?? SupabaseConfig.client.auth.currentUser;
});

/// The `profiles` row for the current user. Refreshed when auth state changes.
final currentProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  try {
    final row = await SupabaseConfig.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    return row;
  } catch (_) {
    return null;
  }
});

/// The active role of the signed-in user, derived from the profile row.
/// Defaults to 'shopper' while the profile is loading or if unavailable.
final currentRoleProvider = Provider<String>((ref) {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  return (profile?['active_role'] as String?) ?? 'shopper';
});

/// Concrete auth actions exposed as a service so UI just calls methods.
class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'shopper' | 'vendor' | 'provider' | 'rider'
    String? phoneNumber,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'active_role': role,
      },
    );

    // Create the matching profiles row (RLS lets the user write their own).
    final user = response.user;
    if (user != null) {
      try {
        await _client.from('profiles').upsert({
          'id': user.id,
          'full_name': fullName,
          'phone_number': phoneNumber,
          'active_role': role,
        });
      } catch (_) {
        // If profile insert fails (offline / RLS hiccup), auth still succeeded.
      }
    }
    return response;
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Sends a password-reset email. The user resets via the link.
  Future<void> sendPasswordReset(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// OAuth sign-in (Google / Apple). Requires the provider to be enabled in the
  /// Supabase dashboard and the redirect scheme registered on the device.
  /// Returns true if the OAuth flow was launched.
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    return _client.auth.signInWithOAuth(
      provider,
      redirectTo: 'com.martorax.app://login-callback/',
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Sync state holder for the role the user is signing up for.
/// Set by role_selection_screen, read by the role-specific register screens.
final pendingSignupRoleProvider = StateProvider<String>((ref) => 'shopper');
