import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);
  Future<Either<Failure, UserEntity>> call({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
return Left(AuthFailure('Email and password cannot be empty'));
    }
  return   await _authRepository.signInWithEmail(email: email, password: password);
  }
}