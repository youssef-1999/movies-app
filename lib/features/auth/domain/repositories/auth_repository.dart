import 'package:dartz/dartz.dart';
import 'package:movies/core/errors/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({required String email, required String password});
  Future<Either<Failure, UserEntity>> signUpWithEmail({required String name, required String email, required String password, required String phone});
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> signOut();
}
