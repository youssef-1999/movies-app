import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:movies/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryLocalDataSource {
  List<Movie> getAll();
  Future<void> saveAll(List<Movie> movies);
}

@LazySingleton(as: HistoryLocalDataSource)
class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final SharedPreferences _prefs;
  final AuthLocalDataSource _auth;
  HistoryLocalDataSourceImpl(this._prefs, this._auth);

  // One history per logged-in user (the token is the uid).
  String get _key => 'history_${_auth.getToken() ?? 'guest'}';

  @override
  List<Movie> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Movie(
              id: e['id'],
              title: e['title'],
              rating: (e['rating'] as num).toDouble(),
              posterUrl: e['posterUrl'],
            ))
        .toList();
  }

  @override
  Future<void> saveAll(List<Movie> movies) => _prefs.setString(
        _key,
        jsonEncode([
          for (final m in movies)
            {
              'id': m.id,
              'title': m.title,
              'rating': m.rating,
              'posterUrl': m.posterUrl,
            }
        ]),
      );
}
