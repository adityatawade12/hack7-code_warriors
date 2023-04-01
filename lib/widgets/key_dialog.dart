import 'package:flutter/material.dart';

class KeyDialog extends StatefulWidget {
  final String address;
  bool showpin = false;
  bool showError = false;
  bool showKeyBox = false;
  String privKey = "";
  // final List<Widget> actions;

  KeyDialog(
    this.address, {super.key}
  );

  @override
  State<KeyDialog> createState() => _KeyDialogState();
}

class _KeyDialogState extends State<KeyDialog> {
  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var web3 = Provider.of<Web3Api>(context, listen: false);

    return !(widget.showKeyBox)
        ? !(widget.showpin)
            ? AlertDialog(
                title: const Text(
                  "Reveal account private key?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          widget.showpin = true;
                        });
                      },
                      child: const Text("Yes")),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  )
                ],
              )
            : AlertDialog(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Icon(Icons.close),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                title: const Text(
                  "Enter PIN",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                content: Form(
                    child: SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      // Pinput(
                     /*  Pinput(
                        focusNode: focusNode,
                        onCompleted: (pin) async {
                          print("First");
                          var x = await web3.decryptPrivatekey(
                              widget.address, pinController.text);
                          if (x['status'] == "fail") {
                            setState(() {
                              widget.showError = true;
                              pinController.clear();
                            });
                          } else {
                            setState(() {
                              widget.showKeyBox = true;
                              widget.privKey = x['key'];
                            });
                            print(x['key']);
                          }
                          print("===");
                        },
                        obscureText: true,
                        controller: pinController,
                        obscuringWidget: const Icon(Icons.circle),
                        showCursor: true,
                        errorText: "Wrong pin",
                      ),
                      // PinInput(widget.address), */
                      const Spacer(
                        flex: 2,
                      ),
                      widget.showError
                          ? const Text(
                              "Invalid PIN",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox()
                    ],
                  ),
                )),
              )
        : AlertDialog(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: const Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            title: const Text(
              "Private Key:",
              style: TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            content: Text(widget.privKey),
          );
  }
}
