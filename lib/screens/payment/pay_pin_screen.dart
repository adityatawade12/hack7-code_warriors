import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';


class PayPinScreen extends StatefulWidget {
  final String senderAddress;
  final String recvAddress;
  final int payingAmountRupee;
  final int extra;

  const PayPinScreen(
      this.senderAddress, this.recvAddress, this.payingAmountRupee, this.extra, {super.key});

  @override
  State<PayPinScreen> createState() => _PayPinScreenState();
}

class _PayPinScreenState extends State<PayPinScreen> {
  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    var web3 = Provider.of<Web3EthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 35,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Enter PIN:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              child: SizedBox(
            height: 150,
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Pinput(
                  focusNode: focusNode,
                  onCompleted: (pin) async {
                    // print("First");
                    var x = await web3.decryptPrivatekey(
                        widget.senderAddress, pinController.text);
                    if (x['status'] == "fail") {
                      setState(() {
                        showError = true;
                        pinController.clear();
                      });
                    } else {
                      var r = await web3.makePayment(
                          widget.senderAddress,
                          widget.recvAddress,
                          x['key'],
                          widget.payingAmountRupee);
                      if (r == 1) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return const AlertDialog(
                                title: Text("Payment Successful!"),
                              );
                            });
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == "/home");
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return const AlertDialog(
                                title: Text("Payment Unsuccessful!"),
                              );
                            });
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == "/scanner");
                        });
                      }
                      // print("correct pin");
                    }
                    // print("===");
                  },
                  obscureText: true,
                  controller: pinController,
                  obscuringWidget: const Icon(Icons.circle),
                  showCursor: true,
                  errorText: "Wrong pin",
                  autofocus: true,
                  closeKeyboardWhenCompleted: false,
                ),
                // PinInput(widget.address),
                //  Text(
                //     "*",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                //   ),
                const Spacer(
                  flex: 2,
                ),

                showError
                    ? const Text(
                        "Invalid PIN!",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    : const SizedBox(),
              ],
            ),
          )),
          // Card(
          // margin: EdgeInsets.only(top: 10),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(68, 72, 214, 1),
                      AppTheme.nearlyBlue
                    ]),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(5))),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 240,
            width: 350,
            child: Column(
              children: [
                const Text(
                  "Transaction Summary:",
                  style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("   Transaction Amount:",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text("\u{20B9}${widget.payingAmountRupee}",
                              textAlign: TextAlign.left,
                              style:
                                  const TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("+ Max Transaction Fee:",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text("\u{20B9}${widget.extra}",
                              textAlign: TextAlign.left,
                              style:
                                  const TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("   Max Transaction:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text(
                              "\u{20B9}${widget.payingAmountRupee + widget.extra}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text("transaction amount:\t \$10",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(fontSize: 18)),
                //     Text("Max fee:\t\t \$5", style: TextStyle(fontSize: 18)),
                //     Text("Total max payment:\t \$10",
                //         style: TextStyle(fontSize: 18))
                //   ],
                // ),
              ],
            ),
          ),
          // ),
          // ElevatedButton(
          //     onPressed: () async {
          //       var z = await web3.getPayableAmount(widget.payingAmountRupee,
          //           widget.senderAddress, widget.recvAddress);
          //     },
          //     child: Text("get amt"))
        ],
      ),
    );
  }
}
