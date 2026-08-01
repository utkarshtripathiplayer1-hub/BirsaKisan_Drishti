import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthResult {
  final String idToken;
  final String accessToken;
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  GoogleAuthResult({
    required this.idToken,
    required this.accessToken,
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}

class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    serverClientId:
        '114250331234-1tqu3l5j4jgdetd41ug18mj9aaktgeu1.apps.googleusercontent.com',
  );

  static Future<GoogleAuthResult> signIn() async {
    try {
      // Sign out first so the account picker always appears.
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        throw Exception("User cancelled Google Sign-In");
      }

      final GoogleSignInAuthentication auth =
          await account.authentication;

      if (auth.idToken == null) {
        throw Exception("Google didn't return an ID Token.");
      }

      return GoogleAuthResult(
        idToken: auth.idToken!,
        accessToken: auth.accessToken ?? "",
        id: account.id,
        name: account.displayName ?? "",
        email: account.email,
        photoUrl: account.photoUrl,
      );
    } catch (e) {
      throw Exception("Google Sign-In Failed: $e");
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  static GoogleSignInAccount? get currentUser {
    return _googleSignIn.currentUser;
  }
}