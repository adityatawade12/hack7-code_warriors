import 'dart:typed_data';
import 'package:hack7/themes/apptheme.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:flutter/material.dart';

class AddressQrBox extends StatefulWidget {
  const AddressQrBox(
      {Key? key,
      required this.address,
      this.animationController,
      this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String address;

  @override
  State<AddressQrBox> createState() => _AddressQrBoxState();
}

class _AddressQrBoxState extends State<AddressQrBox> {
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
    _generateBarCode('{"mode":"address","value":"${widget.address}"}');
    // _generateBarCode(widget.address); //innical value of scan result is "none"
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.animation!.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    Container(
                      // width: 10,
                      height: 300,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: z
                          ?
                          // Column(children: [
                          SizedBox(height: 200, child: Image.memory(bytes))
                          : const CircularProgressIndicator(),
                      // Text(
                      //   "Address:",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     widget.address,
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //     ),
                      //   ),
                      // )
                      // ])
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Address:",
                      style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.nearlyWhite,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.address,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: AppTheme.white),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
