import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onFieldSubmitted;
  final bool enabled;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final bool readOnly;
  final Iterable<String>? autofillHints;
  final double? fontSize;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.enabled = true,
    this.textInputAction,
    this.maxLines = 1,
    this.readOnly = false,
    this.autofillHints,
    this.fontSize,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSize ?? 14;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted != null ? (_) => widget.onFieldSubmitted!() : null,
        autocorrect: false,
        autofillHints: widget.autofillHints,
        style: WonkruText.body(fontSize, color: Colors.white, weight: FontWeight.w500).copyWith(height: 1.2),
        cursorColor: WonkruColors.accent,
        cursorWidth: 1.5,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: WonkruText.body((fontSize - 1).clamp(10.0, 20.0), color: Colors.white38).copyWith(height: 1.2),
          filled: true,
          fillColor: WonkruColors.surface.withValues(alpha: 0.85),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, size: 18, color: _focused ? WonkruColors.accent : Colors.white38)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: WonkruColors.accent, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: WonkruColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: WonkruColors.red, width: 1.5),
          ),
          errorStyle: WonkruText.mono(10, color: WonkruColors.red),
        ),
      ),
    );
  }
}