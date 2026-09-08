import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Auth wrapper (Google + anonymous guest).
class AuthService extends ChangeNotifier {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const <String>['email', 'profile'],
              // Web client ID from google-services.json (needed for idToken on Android).
              serverClientId:
                  '190539958945-3mlsuhrdgkh1qof78nrllo0ti74pcajj.apps.googleusercontent.com',
            );

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Set after Google sign-in when Firebase reports a brand-new account.
  /// Cleared when onboarding finishes (see [completeOnboarding]).
  bool _needsOnboarding = false;

  bool get needsOnboarding => _needsOnboarding;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  void completeOnboarding() {
    if (!_needsOnboarding) {
      return;
    }
    _needsOnboarding = false;
    notifyListeners();
  }

  /// Returns null when the user cancels the Google account picker.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _needsOnboarding =
          userCredential.additionalUserInfo?.isNewUser ?? false;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();
    _needsOnboarding = false;
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    _needsOnboarding = false;
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore Google sign-out failures (e.g. guest-only session).
    }
    await _auth.signOut();
    notifyListeners();
  }
}
