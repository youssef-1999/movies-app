import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail({required String email, required String password});
  Future<UserModel> signUpWithEmail({required String name, required String email, required String password, required String phone});
  Future<void> resetPassword(String email);
  Future<void> signOut();
}
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  bool _googleInitialized = false;

  // GoogleSignIn v7 must be initialized once before any other call
  // (including signOut).
  Future<GoogleSignIn> _google() async {
    final google = GoogleSignIn.instance;
    if (!_googleInitialized) {
      await google.initialize(
        serverClientId: '168533500993-iipise1g6cr7pf8cffdbd03eki91mguk.apps.googleusercontent.com',
      );
      _googleInitialized = true;
    }
    return google;
  }

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromFirebaseUser(cred.user!);
  }

  @override
  Future<UserModel> signUpWithEmail({required String name, required String email, required String password, required String phone}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(name);
    final user = UserModel.fromFirebaseUser(cred.user!, name: name, phone: phone);
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final google = await _google();
    final account = await google.authenticate(); // throws GoogleSignInException on cancel
    final idToken = account.authentication.idToken;
    if (idToken == null) throw Exception('Google returned no idToken');

    final cred = await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
    final user = UserModel.fromFirebaseUser(cred.user!);
    await _firestore.collection('users').doc(user.uid).set(user.toJson(), SetOptions(merge: true));
    return user;
  }

  @override
  Future<void> resetPassword(String email) => _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    // A Google sign-out failure must not block the Firebase sign-out.
    try {
      await (await _google()).signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}