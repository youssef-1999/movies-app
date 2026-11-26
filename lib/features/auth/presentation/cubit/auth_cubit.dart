import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:movies/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:movies/features/auth/domain/usecases/login_usecase.dart';
import 'package:movies/features/auth/domain/usecases/register_usecase.dart';
import 'package:movies/features/auth/domain/usecases/signout_usecase.dart';
import 'package:movies/features/auth/presentation/cubit/auth_state.dart';
@injectable 
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this._loginusecase, required this._googleSigninUsecase, required this._registerUsecase, required this._forgetPasswordUsecase, required this._signOutUsecase}) : super(AuthInitial());

  final LoginUsecase _loginusecase;
  final GoogleSigninUsecase _googleSigninUsecase;
  final RegisterUsecase _registerUsecase;
  final ForgetPasswordUsecase _forgetPasswordUsecase;
  final SignoutUsecase _signOutUsecase;
Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _loginusecase(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
  // Same as signOut(); goes through the repository so Google is signed out
  // too and the saved token is cleared.
  Future<void> logout() => signOut();

Future<void> deleteAccount() async {
  try {
    await FirebaseAuth.instance.currentUser?.delete();
    // Also signs out of Google and clears the saved token.
    await _signOutUsecase();
    emit(AccountDeleted());
  } on FirebaseAuthException catch (e) {
    emit(AuthError(e.code == 'requires-recent-login'
        ? 'Please log in again, then try deleting.'
        : e.message ?? 'Could not delete account'));
  }
}
  Future<void> googleSignin() async {
    emit(AuthLoading());
    final result = await _googleSigninUsecase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(String name, String email, String password, String phone) async {
    emit(AuthLoading());
    final result = await _registerUsecase(name: name, email: email, password: password, phone: phone);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());
    final result = await _forgetPasswordUsecase(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(PasswordResetSent()),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await _signOutUsecase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthSignedOut()),
    );
  }
  

}