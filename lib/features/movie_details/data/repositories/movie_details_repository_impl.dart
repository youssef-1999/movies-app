import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/movie_details/data/datasources/movie_details_remote_data_source.dart';
import 'package:movies/features/movie_details/domain/entities/movie_details.dart';
import 'package:movies/features/movie_details/domain/repositories/movie_details_repository.dart';
import 'package:movies/features/search_feature/features/search/domain/entities/movie.dart';

@LazySingleton(as: MovieDetailsRepository)
class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDataSource _remoteDataSource;

  MovieDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      return await _remoteDataSource.getMovieDetails(movieId);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  @override
  Future<List<Movie>> getSuggestions(int movieId) async {
    try {
      return await _remoteDataSource.getSuggestions(movieId);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
