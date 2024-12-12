import 'package:flutter/material.dart';

import '../config/colors.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validater;
  final bool readonly;
  final int? minLines;
  final int? maxLines;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLength;
  final InputDecoration? decoration;

  const MyTextFormField({
    super.key,
    this.controller,
    this.minLines,
    this.maxLines,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.decoration,
    this.readonly = false,
    this.validater,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: tTextblackColor,
            ),
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: tsecondaryColor,
                  )
                : null,
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: tContainerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Color(0xff67abdb)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: tsecondaryColor,
              ),
            ),
          ),
    );
  }
}
