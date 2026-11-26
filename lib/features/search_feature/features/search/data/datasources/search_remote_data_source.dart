import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/apis/constants.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/search_feature/features/search/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> searchMovies(String query);
}

@LazySingleton(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );



  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _dio.get(
      ApiConstants.listMovies,
      queryParameters: {
        ApiConstants.queryTermKey: query,
        ApiConstants.limitKey: ApiConstants.maxLimit,
      },
    );

    if (response.data['status'] != 'ok') {
      throw AppException(
        (response.data['status_message'] as String?) ??
            'Something went wrong. Please try again.',
      );
    }

    final movies = response.data['data']['movies'] as List? ?? [];
    return movies
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}