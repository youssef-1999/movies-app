import 'package:injectable/injectable.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<ProfileEntity> getProfile() => localDataSource.getProfile();

  @override
  Future<void> updateProfile(ProfileEntity profile) =>
      localDataSource.saveProfile(ProfileModel.fromEntity(profile));

  @override
  Future<void> deleteProfile() => localDataSource.clear();
}