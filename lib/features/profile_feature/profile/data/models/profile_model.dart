import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.phone,
    required super.avatarIndex,
    super.wishListCount,
    super.historyCount,
  });

  factory ProfileModel.fromEntity(ProfileEntity e) => ProfileModel(
        name: e.name,
        phone: e.phone,
        avatarIndex: e.avatarIndex,
        wishListCount: e.wishListCount,
        historyCount: e.historyCount,
      );
}
