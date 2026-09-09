import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../services/auth_service.dart';

/// First entry: Sign in, Sign up, or proceed as guest.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _busy = false;
  String? _error;

  String _friendlyAuthError(Object error) {
    final String message = error.toString();
    if (message.contains('origin_mismatch') ||
        message.contains('redirect_uri_mismatch')) {
      return 'Google sign-in blocked (origin not registered).\n'
          'Use a fixed web port: flutter run -d chrome --web-port=${AuthService.webDevPort}\n'
          'Then add http://localhost:${AuthService.webDevPort} to your OAuth '
          'Web client in Google Cloud Console (see PROJECT_MANUAL).';
    }
    if (error is FirebaseAuthException) {
      return error.message ?? error.code;
    }
    return message;
  }

  Future<void> _runAuth(Future<void> Function() action) async {
    if (_busy) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) {
        setState(() => _error = _friendlyAuthError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _onSignIn() async {
    await _runAuth(() async {
      await context.read<AuthService>().signInWithGoogle(
            forceOnboarding: false,
          );
    });
  }

  Future<void> _onSignUp() async {
    await _runAuth(() async {
      await context.read<AuthService>().signInWithGoogle(
            forceOnboarding: true,
          );
    });
  }

  Future<void> _onProceedWithout() async {
    await _runAuth(() async {
      await context.read<AuthService>().signInAnonymously();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              Text(
                'JUBU',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your cook diary & recipe companion\nwherever you live.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 3),
              if (_error != null) ...<Widget>[
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_busy)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ElevatedButton(
                onPressed: _busy ? null : _onSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  disabledBackgroundColor: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _busy ? null : _onSignUp,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _busy ? null : _onProceedWithout,
                child: Text(
                  'Proceed without it',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
