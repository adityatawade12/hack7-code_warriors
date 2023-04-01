import 'dart:typed_data';

import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

class VPAQr extends StatefulWidget {
  final address;

  const VPAQr(this.address);

  @override
  State<VPAQr> createState() => _VPAQrState();
}

class _VPAQrState extends State<VPAQr> {
  Uint8List bytes = Uint8List(0);
  bool z = false;

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    setState(() {
      z = true;
      bytes = result;
    });
  }

  @override
  void initState() {
    _generateBarCode('{"mode":"vpa","value":"' + widget.address + '"}');
    // _generateBarCode(widget.address); //innical value of scan result is "none"
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var auth = Provider.of<AuthService>(context);
    return Center(
      child: z ? Image.memory(bytes) : const CircularProgressIndicator(),
    );
  }
}
