import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  final double width;

  const LogoImage({
    super.key,
    this.width = 350, // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: width,
    );
  }
}
