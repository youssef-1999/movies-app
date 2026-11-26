import 'package:movies/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}
class AccountDeleted extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}
class PasswordResetSent extends AuthState {}

class AuthSignedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}