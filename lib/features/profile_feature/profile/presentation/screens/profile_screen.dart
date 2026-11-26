import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies/features/auth/presentation/screens/login_screen.dart';
import 'package:movies/features/profile_feature/profile/pfps.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_tabs.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSignedOut) {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (state is ProfileError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              final loaded = state as ProfileLoaded;
              final p = loaded.profile;
              return Column(
                children: [
                  Container(
                    color: AppColors.black,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(
                                ProfileAssets.avatar(p.avatarIndex),
                              ),
                            ),
                            const Spacer(),
                            _Stat(
                              value: loaded.watchlist.length,
                              label: 'Wish List',
                            ),
                            const SizedBox(width: 32),
                            _Stat(
                              value: loaded.history.length,
                              label: 'History',
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.yellow,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  final profileCubit = context
                                      .read<ProfileCubit>();
                                  final authCubit = context.read<AuthCubit>();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: profileCubit,
                                          ),
                                          BlocProvider.value(value: authCubit),
                                        ],
                                        child: const UpdateProfileScreen(),
                                      ),
                                    ),
                                  );
                                  profileCubit.loadProfile();
                                },
                                child: const Text('Edit Profile'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  context.read<AuthCubit>().logout();
                                },
                                icon: const Icon(Icons.logout, size: 18),
                                label: const Text('Exit'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                 Expanded(
  child: ProfileTabs(
    watchlist: loaded.watchlist,
    history: loaded.history,
  ),
),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
    ],
  );
}
