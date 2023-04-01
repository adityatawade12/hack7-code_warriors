import 'package:flutter/material.dart';

class AccountDialog extends StatelessWidget {
  final String title;
  final String address;
  final String privateKey;

  // final List<Widget> actions;

  const AccountDialog(
    this.title,
    this.address,
    this.privateKey, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Account Created!",
        style: TextStyle(),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.popUntil(
                  context, (route) => route.settings.name == "/home");
            },
            child: const Text("Ok"))
      ],
      content: SizedBox(
        height: 210,
        child: Column(
          children: [
            const Text(
              "Name:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(title),
            const Spacer(),
            const Text(
              "Address:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(address),
            const Spacer(),
            const Text(
              "Private Key:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(privateKey),
            // Spacer(),
            // Text("Do not share your private key with anyone!")
          ],
        ),
      ),
    );
  }
}
