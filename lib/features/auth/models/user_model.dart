/// App user profile and preferences (PROJECT_SPEC §5-A).
class UserModel {
  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.preferImperial = false,
    this.preferredCuisines = const <String>['Korean'],
    this.equippedTitle,
    this.unlockedTitles = const <String>[],
    this.followingUids = const <String>[],
  });

  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;

  /// When true, recipe amounts render as oz / cup.
  final bool preferImperial;

  final List<String> preferredCuisines;
  final String? equippedTitle;
  final List<String> unlockedTitles;
  final List<String> followingUids;

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? preferImperial,
    List<String>? preferredCuisines,
    String? equippedTitle,
    List<String>? unlockedTitles,
    List<String>? followingUids,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      preferImperial: preferImperial ?? this.preferImperial,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      equippedTitle: equippedTitle ?? this.equippedTitle,
      unlockedTitles: unlockedTitles ?? this.unlockedTitles,
      followingUids: followingUids ?? this.followingUids,
    );
  }
}
