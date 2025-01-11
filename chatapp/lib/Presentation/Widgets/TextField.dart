import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final VoidCallback? onTap; // New callback for handling tap events

  const CustomTextFormField({
    Key? key,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap, // Pass the tap event
      readOnly: onTap != null, // Make read-only if onTap is provided
      focusNode: focusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
