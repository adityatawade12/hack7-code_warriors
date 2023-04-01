import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class NoVpa extends StatelessWidget {
  const NoVpa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://cdn-icons-png.flaticon.com/512/5161/5161379.png",
          height: 110,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Select a Primary account to Generate QR",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.nearlyDarkBlue, fontSize: 18),
        )
      ],
    );
  }
}
