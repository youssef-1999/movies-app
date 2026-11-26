import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GoogleSigninUsecase {
  final AuthRepository _authRepository;

  GoogleSigninUsecase(this._authRepository);
  Future<Either<Failure, UserEntity>> call() async {
   
  return   await _authRepository.signInWithGoogle();
  }
}