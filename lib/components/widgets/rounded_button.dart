import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.text, required this.ontap(), super.key});
  final String text;
  final Function ontap;

  final ButtonStyle style = ElevatedButton.styleFrom(
    minimumSize: const Size(188, 48),
    backgroundColor: const Color(0xFF051B8B),
    elevation: 6,
    textStyle: const TextStyle(fontSize: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () {
        ontap();
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
