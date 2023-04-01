import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? suffix;

  final String? Function(String?)? validator;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            iconColor: AppTheme.mainBlue,
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
            suffixText: suffix),
      ),
    );
  }
}
