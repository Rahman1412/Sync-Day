import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sync_day/utils/app_colors.dart';

class TextFieldWrapper extends StatelessWidget {
  final Color? fillColor;
  final Color? textColor;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final int? maxLines;

  const TextFieldWrapper({
    super.key,
    this.fillColor,
    this.textColor,
    this.controller,
    this.validator,
    this.enabled, this.hint, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        filled: true,
        fillColor: fillColor,
        hintText: hint
      ),
      style: TextStyle(color: textColor),
      validator: validator,
      enabled: enabled,
      maxLines: maxLines ?? 1,
    );
  }
}
