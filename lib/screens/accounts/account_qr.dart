import 'dart:typed_data';
import 'package:hack7/themes/apptheme.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

class AccountQr extends StatefulWidget {
  static const routename = "/qr";
  final String address;
  final String name;
  const AccountQr(this.name, this.address);

  @override
  State<AccountQr> createState() => _AccountQrState();
}

class _AccountQrState extends State<AccountQr> {
  Uint8List bytes = Uint8List(0);
  bool z = false;

  // const AccountQr({Key? key}) : super(key: key);
  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    setState(() {
      z = true;
      bytes = result;
    });
  }

  @override
  void initState() {
    _generateBarCode('{"mode":"address","value":"' + widget.address + '"}');
    // _generateBarCode(widget.address); //innical value of scan result is "none"
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account QR"),
        backgroundColor: AppTheme.mainBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Text(
              widget.name + ":",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child:
                    z ? Image.memory(bytes) : const CircularProgressIndicator(),
              ),
            ),
            const Text(
              "Address:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.address,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
