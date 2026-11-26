import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/extensions/padding_extension.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies/gen/assets.gen.dart';
import 'package:movies/core/widgets/custom_elevated_button.dart';
import 'package:movies/core/widgets/custom_text_field.dart';

class ForgetPassword extends StatefulWidget {
  static const String routeName = '/forget-password';
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();


  void _resetPassword() {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  context.read<AuthCubit>().forgetPassword(
        _emailController.text.trim(),
      );
}
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
    // 👂 listener: do ONE-TIME things (SnackBar, navigation)
    listener: (context, state) {
      if (state is PasswordResetSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset link sent! Check your email.'), backgroundColor: AppColors.green),
        );
        Navigator.pop(context); // back to login
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Forget Password',
            style: TextStyle(color: AppColors.yellow),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Assets.images.forgotPasswordBro1.image(
                    width: 380,
                    height: 380,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 69),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  prefixIcon: Assets.icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                ).paddingSymmetric(horizontal: 16),
                const SizedBox(height: 23),
                CustomElevatedButton(
                  text: isLoading ? 'Loading...' : 'Reset Password',
                  onPressed: isLoading ? null : _resetPassword,
                ).paddingOnly(left: 19, right: 19),
              ],
            ),
          ),
        ),
      ),
    );
    },);
  }
}
