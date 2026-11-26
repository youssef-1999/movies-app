import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/theme/app_theme.dart';
import 'package:movies/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/home/presentation/screens/home_screen.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/screens/onboarding_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await configureDependencies();

  final token = getIt<AuthLocalDataSource>().getToken();
  final initialRoute = token != null
      ? HomeScreen.routeName
      : OnboardingScreens.routeName;

  runApp(MainApp(initialRoute: initialRoute));
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          initialRoute: initialRoute,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}