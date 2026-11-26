import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';
@injectable
class RegisterUsecase {
  final AuthRepository _authRepository;
  RegisterUsecase(this._authRepository);
  Future<Either<Failure, UserEntity>> call({required String name, required String email, required String password,required String phone}) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      return Left(AuthFailure('All fields cannot be empty'));
    }
    return await _authRepository.signUpWithEmail(name: name, email: email, password: password, phone: phone);
  }
}