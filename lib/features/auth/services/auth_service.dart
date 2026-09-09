import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Auth wrapper (Google + anonymous guest).
class AuthService extends ChangeNotifier {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignInOverride = googleSignIn;

  /// OAuth Web client ID (Firebase / Google Cloud).
  /// Used as [GoogleSignIn.serverClientId] on Android.
  static const String webClientId =
      '190539958945-3mlsuhrdgkh1qof78nrllo0ti74pcajj.apps.googleusercontent.com';

  /// Fixed dev port — register this origin in Google Cloud Console (see PROJECT_MANUAL).
  static const int webDevPort = 7357;

  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignInOverride;
  GoogleSignIn? _googleSignInLazy;

  /// Lazy so constructing [AuthService] does not crash on web before meta/clientId.
  GoogleSignIn get _googleSignIn {
    final GoogleSignIn? override = _googleSignInOverride;
    if (override != null) {
      return override;
    }
    return _googleSignInLazy ??= GoogleSignIn(
      scopes: const <String>['email', 'profile'],
      serverClientId: webClientId,
    );
  }

  /// Set after Google sign-in when Firebase reports a brand-new account.
  /// Cleared when onboarding finishes (see [completeOnboarding]).
  bool _needsOnboarding = false;

  bool get needsOnboarding => _needsOnboarding;

  User? get currentUser => _auth.currentUser;

  /// Cached so [StreamBuilder] does not resubscribe every rebuild.
  late final Stream<User?> authStateChanges = _auth.authStateChanges();

  void completeOnboarding() {
    if (!_needsOnboarding) {
      return;
    }
    _needsOnboarding = false;
    notifyListeners();
  }

  /// Returns null when the user cancels the Google account picker.
  ///
  /// [forceOnboarding] — true for Sign up (always show preference setup).
  /// false for Sign in (skip onboarding and go to the feed).
  Future<UserCredential?> signInWithGoogle({
    bool forceOnboarding = false,
  }) async {
    try {
      final UserCredential? userCredential = kIsWeb
          ? await _signInWithGoogleWeb()
          : await _signInWithGoogleMobile();
      if (userCredential == null) {
        return null;
      }
      _needsOnboarding = forceOnboarding;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> _signInWithGoogleWeb() async {
    final GoogleAuthProvider provider = GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');
    return _auth.signInWithPopup(provider);
  }

  Future<UserCredential?> _signInWithGoogleMobile() async {
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

    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();
    _needsOnboarding = false;
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    _needsOnboarding = false;
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore Google sign-out failures (e.g. guest-only session).
      }
    }
    await _auth.signOut();
    notifyListeners();
  }
}
