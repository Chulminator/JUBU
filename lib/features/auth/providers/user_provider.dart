import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// In-memory user preferences (pre-Firebase Auth).
class UserProvider extends ChangeNotifier {
  UserModel _currentUser = UserModel(
    uid: 'current_user_me',
    displayName: 'Chef',
    email: 'me@jubu.app',
    photoUrl: '',
    preferImperial: false,
    preferredCuisines: const <String>['Korean'],
  );

  UserModel get currentUser => _currentUser;

  void updatePreferences({
    bool? preferImperial,
    List<String>? preferredCuisines,
    String? displayName,
  }) {
    _currentUser = _currentUser.copyWith(
      preferImperial: preferImperial,
      preferredCuisines: preferredCuisines,
      displayName: displayName,
    );
    notifyListeners();
  }
}
