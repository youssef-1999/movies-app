import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/extensions/padding_extension.dart';
import 'package:movies/gen/assets.gen.dart';
import 'package:movies/core/widgets/custom_elevated_button.dart';
import 'package:movies/core/widgets/custom_text_field.dart';
import 'package:movies/core/widgets/language_switch.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _languageCode = 'en';



// Method to handle login
void _loginWithGoogle() {
  context.read<AuthCubit>().googleSignin();

}

  void _login() {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
    // 👂 listener: do ONE-TIME things (SnackBar, navigation)
    listener: (context, state) {
      if (state is AuthSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!'), backgroundColor: AppColors.green),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
        );
      }
    },
    // 🎨 builder: DRAW the screen (rebuilds on every state)
    builder: (context, state) {
      final isLoading = state is AuthLoading;
      return Form(
        key: _formKey,

      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Assets.splash.splashLogo.image(
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 69),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  prefixIcon: Assets.icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ).paddingSymmetric(horizontal: 16),
                SizedBox(height: 23),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  prefixIcon: Assets.icons.password,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ).paddingSymmetric(horizontal: 16),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget-password');
                        // Handle forgot password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.yellow,
                        ),
                      ),
                    ).paddingOnly(top: 5),
                  ],
                ),
                CustomElevatedButton(
                  text: isLoading ? 'Loading...' : 'Login',
                  onPressed: isLoading ? null : _login,
                ).paddingOnly(left: 19, right: 19),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.yellow,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign up logic
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ).paddingOnly(top: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: AppColors.yellow,
                        thickness: 1,
                        indent: 50,
                        endIndent: 12,
                      ),
                    ),
                    Text(
                      'OR',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.yellow),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.yellow,
                        thickness: 1,
                        indent: 12,
                        endIndent: 50,
                      ),
                    ),
                  ],
                ).paddingOnly(top: 20),
                CustomElevatedButton(
                  text: 'Login With Google',
                  icon: SvgPicture.asset(
                    Assets.icons.google,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: isLoading ? null : _loginWithGoogle,
                ).paddingOnly(left: 19, right: 19, top: 20),

                LanguageSwitch(
                  languageCode: _languageCode,
                  onChanged: (code) {
                    setState(() => _languageCode = code);
                    // TODO: apply the locale app-wide once localization is set up
                  },
                ).paddingOnly(top: 24, bottom: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  );
    
  }
}
