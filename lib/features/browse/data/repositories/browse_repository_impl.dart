import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/browse/data/datasources/browse_remote_data_source.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/entities/movies_page.dart';
import 'package:movies/features/browse/domain/repositories/browse_repository.dart';

@LazySingleton(as: BrowseRepository)
class BrowseRepositoryImpl implements BrowseRepository {
  final BrowseRemoteDataSource _remoteDataSource;

  BrowseRepositoryImpl(this._remoteDataSource);

  @override
  Future<MoviesPage> browseMovies({
    required String? genre,
    required BrowseSort sort,
    required int page,
  }) async {
    try {
      return await _remoteDataSource.browseMovies(
        genre: genre,
        sort: sort,
        page: page,
      );
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
