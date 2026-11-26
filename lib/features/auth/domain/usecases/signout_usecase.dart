import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignoutUsecase {
  final AuthRepository _authRepository;

  SignoutUsecase(this._authRepository);
  Future<Either<Failure, void>> call()  {
   
  return    _authRepository.signOut();
  }
}