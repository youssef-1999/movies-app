import 'package:injectable/injectable.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);
  Future<ProfileEntity> call() => repository.getProfile();
}

@injectable
class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);
  Future<void> call(ProfileEntity profile) => repository.updateProfile(profile);
}


@injectable
class DeleteProfileUseCase {
  final ProfileRepository repository;
  DeleteProfileUseCase(this.repository);
  Future<void> call() => repository.deleteProfile();
}