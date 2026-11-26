class ProfileEntity {
  final String name;
  final String phone;
  final int avatarIndex; // 1..9
  final int wishListCount;
  final int historyCount;

  const ProfileEntity({
    required this.name,
    required this.phone,
    required this.avatarIndex,
    this.wishListCount = 0,
    this.historyCount = 0,
  });

  ProfileEntity copyWith({String? name, String? phone, int? avatarIndex}) =>
      ProfileEntity(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        avatarIndex: avatarIndex ?? this.avatarIndex,
        wishListCount: wishListCount,
        historyCount: historyCount,
      );
}
