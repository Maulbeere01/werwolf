import 'package:flutter/material.dart';

class CodeTextfield extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const CodeTextfield({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 40,
      ),
      controller: controller,
      validator: validator,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 40),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorStyle: const TextStyle(height: 0),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}