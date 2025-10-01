import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomIconTextField extends StatelessWidget {
  final ColorScheme color;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final IconData icon;
  final String hintText;
  final bool isEmail;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final bool? showSuffixIcon;

  const CustomIconTextField({
    super.key,
    required this.color,
    required this.controller,
    this.focusNode,
    required this.icon,
    required this.hintText,
    this.isEmail = false,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.showSuffixIcon = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color.onPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              style: TextStyle(color: color.primary),
              keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
              obscureText: isPassword ? obscureText : false,
              cursorColor: color.primary,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                suffixIcon: isPassword && showSuffixIcon == true
                    ? IconButton(
                  icon: Icon(
                    obscureText
                        ? IconsaxPlusLinear.eye
                        : IconsaxPlusLinear.eye_slash,
                  ),
                  onPressed: onToggleObscure,
                )
                    : null,
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: color.primary, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              textInputAction: isEmail || !isPassword
                  ? TextInputAction.next
                  : TextInputAction.done,
            ),
          ),
        ),
      ],
    );
  }
}
