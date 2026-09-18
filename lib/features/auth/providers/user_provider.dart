import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// In-memory user preferences (pre-Firebase Auth).
class UserProvider extends ChangeNotifier {
  UserModel _currentUser = UserModel(
    uid: 'current_user_me',
    username: 'Chef',
    email: 'me@jubu.app',
    photoUrl: '',
    preferImperial: false,
    preferredCuisines: const <String>['Korean'],
    equippedTitle: 'K-Banchan Craftsman',
    titleBadges: const <String>[
      'K-Banchan Craftsman',
      'Fusion Alchemist',
      'Weeknight Warrior',
      'Trader Joe Explorer',
    ],
  );

  UserModel get currentUser => _currentUser;

  void updatePreferences({
    bool? preferImperial,
    List<String>? preferredCuisines,
    String? username,
    String? photoUrl,
    String? equippedTitle,
    bool clearEquippedTitle = false,
    List<String>? titleBadges,
  }) {
    _currentUser = _currentUser.copyWith(
      preferImperial: preferImperial,
      preferredCuisines: preferredCuisines,
      username: username,
      photoUrl: photoUrl,
      equippedTitle: equippedTitle,
      clearEquippedTitle: clearEquippedTitle,
      titleBadges: titleBadges,
    );
    notifyListeners();
  }

  /// Equips a title badge from [UserModel.titleBadges], or clears if null.
  void setEquippedTitle(String? title) {
    if (title == null) {
      updatePreferences(clearEquippedTitle: true);
      return;
    }
    if (!_currentUser.titleBadges.contains(title)) {
      return;
    }
    updatePreferences(equippedTitle: title);
  }

  /// Unlocks a new title badge (no-op if already unlocked). Returns true if new.
  bool unlockTitleBadge(String badge) {
    final String clean = badge.trim();
    if (clean.isEmpty || _currentUser.titleBadges.contains(clean)) {
      return false;
    }
    updatePreferences(
      titleBadges: <String>[..._currentUser.titleBadges, clean],
      equippedTitle: clean,
    );
    return true;
  }
}
