import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  final SharedPreferences _prefs;
  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveToken(String token) => _prefs.setString(_tokenKey, token);
  @override
  String? getToken() => _prefs.getString(_tokenKey);
  @override
  Future<void> clearToken() => _prefs.remove(_tokenKey);
}
