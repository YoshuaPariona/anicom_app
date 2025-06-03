import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomLinkText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const CustomLinkText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: text),
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: Colors.pink,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
