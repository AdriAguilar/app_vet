import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool filled;
  final Color fillColor;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Validación opcional
  final void Function(String)? onChanged; // Integración con Provider
  final void Function(String?)? onSaved;

  CustomTextInput({
    super.key,
    required this.label,
    required this.hint,
    this.filled = false,
    this.fillColor = Colors.white,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.validator,
    this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: filled,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}