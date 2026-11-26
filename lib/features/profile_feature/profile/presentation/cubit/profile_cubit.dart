import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/history/domain/usecases/history_usecases.dart';
import 'package:movies/features/watchlist/domain/usecases/watchlist_usecases.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final GetWatchlistUseCase getWatchlistUseCase;
  final GetHistoryUseCase getHistoryUseCase;
  late final StreamSubscription _watchSub;
  late final StreamSubscription _historySub;

  ProfileCubit(
    this.getProfileUseCase,
    this.updateProfileUseCase,
    this.deleteProfileUseCase,
    this.getWatchlistUseCase,
    this.getHistoryUseCase,
    WatchWatchlistUseCase watchWatchlist,
    WatchHistoryUseCase watchHistory,
  ) : super(ProfileInitial()) {
    _watchSub = watchWatchlist().listen((list) {
      final s = state;
      if (s is ProfileLoaded) emit(ProfileLoaded(s.profile, list, s.history));
    });
    _historySub = watchHistory().listen((list) {
      final s = state;
      if (s is ProfileLoaded) emit(ProfileLoaded(s.profile, s.watchlist, list));
    });
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      emit(ProfileLoaded(
        await getProfileUseCase(),
        getWatchlistUseCase(),
        getHistoryUseCase(),
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    try {
      final updated = current.profile
          .copyWith(name: name, phone: phone, avatarIndex: avatarIndex);
      await updateProfileUseCase(updated);
      emit(ProfileLoaded(updated, current.watchlist, current.history));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> deleteLocalProfile() => deleteProfileUseCase();

  @override
  Future<void> close() async {
    await _watchSub.cancel();
    await _historySub.cancel();
    return super.close();
  }
}