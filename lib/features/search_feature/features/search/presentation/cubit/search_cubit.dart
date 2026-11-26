import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/apis/constants.dart';
import 'package:movies/app_exception.dart';

import 'package:movies/features/search_feature/features/search/domain/usecases/search_movies_usecase.dart';
import 'package:movies/features/search_feature/features/search/presentation/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchMoviesUseCase _searchMovies;

  Timer? _debounce;
  String _latestQuery = '';

  SearchCubit(this._searchMovies) : super(const SearchInitial());

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _latestQuery = query.trim();

    if (_latestQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    _debounce = Timer(ApiConstants.searchDebounce, () => _search(_latestQuery));
  }

  Future<void> _search(String query) async {
    emit(const SearchLoading());

    try {
      final movies = await _searchMovies(query);
      if (isClosed || query != _latestQuery) return;
      emit(SearchSuccess(movies));
    } catch (e) {
      if (isClosed || query != _latestQuery) return;
      emit(SearchError(
        e is AppException ? e.message : 'Something went wrong. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}