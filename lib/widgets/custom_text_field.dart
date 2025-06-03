import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final String? errorText;
  final TextEditingController controller;
  final Color borderColor;
  final Color focusedColor;
  final Color errorColor;
  final Color textColor;
  final IconData? prefixIcon;  // nuevo parámetro opcional

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.errorText,
    this.borderColor = Colors.grey,
    this.focusedColor = const Color(0xFFA96B5A),
    this.errorColor = const Color(0xFFF28B82),
    this.textColor = Colors.black,
    this.prefixIcon,  // se agrega aquí
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      style: TextStyle(color: widget.textColor),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: _isFocused ? widget.focusedColor : widget.borderColor,
        ),
        errorText: widget.errorText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.focusedColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: TextStyle(
          color: widget.errorColor,
          fontSize: 13,
          height: 1.2,
          fontWeight: FontWeight.bold,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.errorColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.errorColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: _isFocused ? widget.focusedColor : widget.borderColor,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    key: ValueKey<bool>(_obscureText),
                    color: _isFocused
                      ? widget.focusedColor
                      : (widget.errorText != null
                          ? widget.borderColor.withValues(alpha: 0.6)
                          : widget.borderColor),

                  ),
                ),
                onPressed: _toggleVisibility,
              )
            : null,
      ),
    );
  }
}
