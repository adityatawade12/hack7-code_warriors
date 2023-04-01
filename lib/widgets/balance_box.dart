
import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';


class Balance extends StatefulWidget {
  final String account;

  const Balance(this.account, {super.key});
  // Balance({Key? key}) : super(key: key);

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  var _switchState = false;
  @override
  Widget build(BuildContext context) {
    var web3 = Provider.of<Web3EthProvider>(context, listen: false);

    return Container(
      height: 200,
      width: double.infinity,
      // color: Colors.white,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          // HexColor('#6A88E5'),
          AppTheme.nearlyBlue,
          AppTheme.mainBlue,
          AppTheme.nearlyBlue
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: FutureBuilder(
        future: Provider.of<Web3EthProvider>(context, listen: false)
            .getAccountBalance(widget.account),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.nearlyWhite,
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text("An error occurred"),
              );
            }
            var data = dataSnapshot.data as Map<String, dynamic>;
            return Consumer<Web3EthProvider>(
              builder: (ctx, crypto, child) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '\u{20B9}',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                      Switch(
                          value: _switchState,
                          onChanged: (value) {
                            setState(() {
                              _switchState = value;
                            });
                          }),
                      // Text(
                      //   'Ether',
                      //   style: TextStyle(fontSize: 18),
                      // ),
                      Container(
                        height: 20,
                        margin: const EdgeInsets.only(right: 10),
                        child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/8042/8042859.png"),
                      ),
                    ],
                  ),
                  const Text(
                    "Balance:",
                    style:
                        TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  !_switchState
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '\u{20B9} ',
                              style: TextStyle(
                                  fontSize: 48, color: Colors.white),
                            ),
                            Text(
                              data['rupee'].toString(),
                              // .toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 48, color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/8042/8042859.png"),
                            ),
                            Text(
                              data['ether'].toStringAsFixed(5),
                              style: const TextStyle(
                                  fontSize: 48, color: Colors.white),
                            ),
                          ],
                        ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/8042/8042859.png"),
                      ),
                      const Text(" 1 = ",
                          style: TextStyle(
                              fontSize: 19, color: Colors.white)),
                      Text(
                        "\u{20B9} ${web3.rupee.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 19, color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer()
                ],
              )
            );
          }
        }
      )
    );
  }
}

// Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 '\u{20B9}',
//                 style: TextStyle(fontSize: 18),
//               ),
//               Switch(
//                   value: _switchState,
//                   onChanged: (value) {
//                     setState(() {
//                       _switchState = value;
//                     });
//                   }),
//               // Text(
//               //   'Ether',
//               //   style: TextStyle(fontSize: 18),
//               // ),
//               Container(
//                 height: 20,
//                 child: Image.network(
//                     "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
//               ),
//             ],
//           ),
//           Text(
//             "Balance:",
//             style: TextStyle(
//               fontSize: 18,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           !_switchState
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '\u{20B9} ',
//                       style: TextStyle(fontSize: 48),
//                     ),
//                     Text(
//                       '4500',
//                       style: TextStyle(fontSize: 48),
//                     ),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 50,
//                       child: Image.network(
//                           "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
//                     ),
//                     Text(
//                       '25.6978',
//                       style: TextStyle(fontSize: 48),
//                     ),
//                   ],
//                 )
//         ],
//       ),