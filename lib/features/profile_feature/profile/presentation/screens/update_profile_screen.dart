import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies/features/auth/presentation/screens/login_screen.dart';
import 'package:movies/features/profile_feature/profile/pfps.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/avatar_picker_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const String routeName = 'update_profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late int _avatar;

  @override
  void initState() {
    super.initState();
    final p = (context.read<ProfileCubit>().state as ProfileLoaded).profile;
    _name = TextEditingController(text: p.name);
    _phone = TextEditingController(text: p.phone);
    _avatar = p.avatarIndex;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await showAvatarPicker(context, _avatar);
    if (picked != null) setState(() => _avatar = picked);
  }

  Future<void> _save() async {
    await context.read<ProfileCubit>().updateProfile(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      avatarIndex: _avatar,
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text('This will remove your saved profile data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      context.read<AuthCubit>().deleteAccount();
    }
  }

  void _resetPassword() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    final usesPassword =
        user?.providerData.any((p) => p.providerId == 'password') ?? false;

    if (email == null || email.isEmpty || !usesPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset is only available for email accounts.'),
        ),
      );
      return;
    }
    context.read<AuthCubit>().forgetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AccountDeleted) {
          await context.read<ProfileCubit>().deleteLocalProfile();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        } else if (state is PasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent. Check your inbox.'),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.yellow),
          title: const Text(
            'Pick Avatar',
            style: TextStyle(color: AppColors.yellow, fontSize: 16),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(ProfileAssets.avatar(_avatar)),
                  ),
                ),
                const SizedBox(height: 24),
                _Field(
                  controller: _name,
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _phone,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _resetPassword,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _delete,
                    child: const Text('Delete Account'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _save,
                    child: const Text('Update Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  const _Field({
    required this.controller,
    required this.icon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.black,
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
