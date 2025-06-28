import 'package:flutter/cupertino.dart';

class TitleWrapper extends StatelessWidget {
  final String title;
  final TextAlign? alignment;
  final double? fontSize;

  const TitleWrapper({super.key, required this.title, this.alignment, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(
      fontSize: fontSize ?? 40,
      fontWeight: FontWeight.bold,
    ),
    textAlign: alignment);
  }
}
