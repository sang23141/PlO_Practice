import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String Imagepath;
  const SquareTile({super.key, required this.Imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(Imagepath),
    );
  }
}