import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const TextForm({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      autocorrect: false,
      autofocus: false,
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorErrorColor: Theme.of(context).colorScheme.error,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Theme.of(context).colorScheme.primary)
            : null,

        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                onPressed: widget.onSuffixTap,
                icon: Icon(
                  widget.suffixIcon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,

        labelText: widget.label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),

        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),

        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}
