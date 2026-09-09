import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../recipe/views/recipe_feed_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

/// Routes by Firebase auth state (+ first-time onboarding flag).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.watch<AuthService>();

    return StreamBuilder<User?>(
      stream: auth.authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Auth error:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          );
        }

        // Do not block on ConnectionState.waiting — authStateChanges may keep
        // waiting on some platforms; treat null as logged out and show login.
        final User? user = snapshot.data ?? auth.currentUser;
        if (user == null) {
          return const LoginScreen();
        }

        if (auth.needsOnboarding) {
          return const OnboardingScreen();
        }

        return const RecipeFeedScreen();
      },
    );
  }
}
