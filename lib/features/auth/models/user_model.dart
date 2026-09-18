/// App user profile and preferences (PROJECT_SPEC §5-A).
class UserModel {
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    this.preferImperial = false,
    this.preferredCuisines = const <String>['Korean'],
    this.equippedTitle,
    this.titleBadges = const <String>[],
    this.followingUids = const <String>[],
  });

  final String uid;

  /// Public handle shown on posts.
  final String username;
  final String email;
  final String photoUrl;

  /// When true, recipe amounts render as oz / cup.
  final bool preferImperial;

  final List<String> preferredCuisines;

  /// Currently equipped title badge shown on posts.
  final String? equippedTitle;

  /// Unlocked title badges the user can equip.
  final List<String> titleBadges;

  final List<String> followingUids;

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? photoUrl,
    bool? preferImperial,
    List<String>? preferredCuisines,
    String? equippedTitle,
    bool clearEquippedTitle = false,
    List<String>? titleBadges,
    List<String>? followingUids,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      preferImperial: preferImperial ?? this.preferImperial,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      equippedTitle: clearEquippedTitle
          ? null
          : (equippedTitle ?? this.equippedTitle),
      titleBadges: titleBadges ?? this.titleBadges,
      followingUids: followingUids ?? this.followingUids,
    );
  }
}
