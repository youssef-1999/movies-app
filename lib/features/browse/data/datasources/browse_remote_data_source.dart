import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/apis/constants.dart';
import 'package:movies/app_exception.dart';
import 'package:movies/features/browse/domain/entities/browse_sort.dart';
import 'package:movies/features/browse/domain/entities/movies_page.dart';
import 'package:movies/features/search_feature/features/search/data/models/movie_model.dart';

abstract class BrowseRemoteDataSource {
  Future<MoviesPage> browseMovies({
    required String? genre,
    required BrowseSort sort,
    required int page,
  });
}

@LazySingleton(as: BrowseRemoteDataSource)
class BrowseRemoteDataSourceImpl implements BrowseRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );

  @override
  Future<MoviesPage> browseMovies({
    required String? genre,
    required BrowseSort sort,
    required int page,
  }) async {
    final response = await _dio.get(
      ApiConstants.listMovies,
      queryParameters: {
        ApiConstants.limitKey: ApiConstants.defaultLimit,
        ApiConstants.pageKey: page,
        ApiConstants.sortByKey: sort.sortBy,
        ApiConstants.orderByKey: sort.orderBy,
        ApiConstants.genreKey: ?genre,
      },
    );

    if (response.data['status'] != 'ok') {
      throw AppException(
        (response.data['status_message'] as String?) ??
            'Something went wrong. Please try again.',
      );
    }

    final data = response.data['data'] as Map<String, dynamic>;
    final movies = data['movies'] as List? ?? [];
    return MoviesPage(
      movies: movies
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      page: (data['page_number'] as num?)?.toInt() ?? page,
      totalCount: (data['movie_count'] as num?)?.toInt() ?? 0,
      limit: (data['limit'] as num?)?.toInt() ?? ApiConstants.defaultLimit,
    );
  }
}
