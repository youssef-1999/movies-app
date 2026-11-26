import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
  Future<void> clear();
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  // One set of keys per logged-in user.
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  String get _kName => 'profile_name_$_uid';
  String get _kPhone => 'profile_phone_$_uid';
  String get _kAvatar => 'profile_avatar_$_uid';
  String get _kWish => 'profile_wish_count_$_uid';
  String get _kHistory => 'profile_history_count_$_uid';

  @override
  Future<ProfileModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    return ProfileModel(
      name: prefs.getString(_kName) ?? user?.displayName ?? '',
      phone: prefs.getString(_kPhone) ?? user?.phoneNumber ?? '',
      avatarIndex: prefs.getInt(_kAvatar) ?? 1,
      wishListCount: prefs.getInt(_kWish) ?? 0,
      historyCount: prefs.getInt(_kHistory) ?? 0,
    );
  }

  @override
  Future<void> saveProfile(ProfileModel p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, p.name);
    await prefs.setString(_kPhone, p.phone);
    await prefs.setInt(_kAvatar, p.avatarIndex);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kName);
    await prefs.remove(_kPhone);
    await prefs.remove(_kAvatar);
    await prefs.remove(_kWish);
    await prefs.remove(_kHistory);
  }
}