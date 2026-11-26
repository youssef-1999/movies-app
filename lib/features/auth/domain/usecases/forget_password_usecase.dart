import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';
@injectable
class ForgetPasswordUsecase {
  final AuthRepository _authRepository;

  ForgetPasswordUsecase(this._authRepository);

  Future<Either<Failure, void>> call(String email)async{
    if (email.isEmpty) {
      return Left(AuthFailure('Email cannot be empty'));
    }
    return _authRepository.resetPassword(email);
  }
}