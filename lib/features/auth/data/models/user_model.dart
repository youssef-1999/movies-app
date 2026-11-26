import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String phone;

  UserModel({required this.name, required this.email, required this.uid, required this.phone});
factory UserModel.fromFirebaseUser(User user, {String? name, String? phone}) => UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: name ?? user.displayName ?? '',
      phone: phone ?? user.phoneNumber ?? '',
    );
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      uid: uid,
      phone: phone,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );

Map<String, dynamic> toJson() => {'uid': uid, 'email': email, 'name': name, 'phone': phone};
}