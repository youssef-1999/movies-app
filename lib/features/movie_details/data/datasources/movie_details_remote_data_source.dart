import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/apis/constants.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/movie_details/data/models/movie_details_model.dart';
import 'package:movies/features/search_feature/features/search/data/models/movie_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getSuggestions(int movieId);
}

@LazySingleton(as: MovieDetailsRemoteDataSource)
class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final response = await _dio.get(
      ApiConstants.movieDetails,
      queryParameters: {
        ApiConstants.movieIdKey: movieId,
        ApiConstants.withImagesKey: true,
        ApiConstants.withCastKey: true,
      },
    );
    final data = _checkOk(response);
    return MovieDetailsModel.fromJson(data['movie'] as Map<String, dynamic>);
  }

  @override
  Future<List<MovieModel>> getSuggestions(int movieId) async {
    final response = await _dio.get(
      ApiConstants.movieSuggestions,
      queryParameters: {ApiConstants.movieIdKey: movieId},
    );
    final data = _checkOk(response);
    final movies = data['movies'] as List? ?? [];
    return movies
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> _checkOk(Response response) {
    if (response.data['status'] != 'ok') {
      throw AppException(
        (response.data['status_message'] as String?) ??
            'Something went wrong. Please try again.',
      );
    }
    return response.data['data'] as Map<String, dynamic>;
  }
}
