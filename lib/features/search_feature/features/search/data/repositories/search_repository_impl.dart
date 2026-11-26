import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/app_exception.dart';

import 'package:movies/features/search_feature/features/search/data/datasources/search_remote_data_source.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';
import 'package:movies/features/search_feature/features/search/domain/repositories/search_repository.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _remoteDataSource.searchMovies(query);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}