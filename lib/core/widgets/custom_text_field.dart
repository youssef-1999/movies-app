import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/gen/assets.gen.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.fillColor = AppColors.darkGrey,
    this.textColor = AppColors.white,
    this.hintColor = AppColors.white,
    this.iconColor = AppColors.white,
    this.focusedBorderColor = AppColors.yellow,
    this.errorColor = AppColors.red,
  });

  final String hintText;

  /// SVG asset path shown before the hint text (e.g. 'assets/icons/email.svg').
  final String? prefixIcon;

  /// Optional trailing widget. Ignored when [isPassword] is true,
  /// since the field then shows its own show/hide password toggle.
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// When true, the text is obscured and a show/hide toggle is displayed.
  final bool isPassword;

  final Color fillColor;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;
  final Color focusedBorderColor;
  final Color errorColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: color),
  );

  Widget _passwordToggle() {
    return IconButton(
      onPressed: () => setState(() => _obscureText = !_obscureText),
      icon: _obscureText
          ? SvgPicture.asset(
              Assets.icons.eyesOff,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
            )
          : Icon(Icons.visibility_outlined, color: widget.iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && _obscureText,
      cursorColor: widget.focusedBorderColor,
      style: textStyle?.copyWith(color: widget.textColor),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: textStyle?.copyWith(color: widget.hintColor),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(14),
                child: SvgPicture.asset(
                  widget.prefixIcon!,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    widget.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        suffixIcon: widget.isPassword ? _passwordToggle() : widget.suffixIcon,
        suffixIconColor: widget.iconColor,
        filled: true,
        fillColor: widget.fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: _border(widget.fillColor),
        enabledBorder: _border(widget.fillColor),
        focusedBorder: _border(widget.focusedBorderColor),
        errorBorder: _border(widget.errorColor),
        focusedErrorBorder: _border(widget.errorColor),
        errorStyle: TextStyle(color: widget.errorColor),
      ),
    );
  }
}
