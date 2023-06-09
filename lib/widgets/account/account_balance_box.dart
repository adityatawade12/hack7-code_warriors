import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';

class AccountBalanceBox extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String account;
  final String type;

  const AccountBalanceBox(
      {Key? key,
      this.animationController,
      this.animation,
      required this.account,
      required this.type})
      : super(key: key);

  @override
  State<AccountBalanceBox> createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalanceBox> {
  var web3;
  var _switchState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.type == "eth") {
      web3 = Provider.of<Web3EthProvider>(context, listen: false);
    } else {
      web3 = Provider.of<Web3SolProvider>(context, listen: false);
    }
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
              child: Container(
                  height: 200,
                  width: double.infinity,
                  // color: Colors.white,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // HexColor('#6A88E5'),
                        AppTheme.mainBlue,
                        AppTheme.nearlyBlue
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FutureBuilder(
                      future: web3.getAccountBalance(widget.account),
                      builder: (ctx, dataSnapshot) {
                        if (dataSnapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          return Column(
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
                                    child: (widget.type == "eth")
                                        ? Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/8042/8042859.png")
                                        : Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/7016/7016539.png"),
                                  ),
                                ],
                              ),
                              const Text(
                                "Balance:",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              !_switchState
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '\u{20B9} ',
                                          style: TextStyle(
                                              fontSize: 48,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          data['rupee'].toString(),
                                          // .toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontSize: 48,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: (widget.type == "eth")
                                              ? Image.network(
                                                  "https://cdn-icons-png.flaticon.com/512/8042/8042859.png")
                                              : Image.network(
                                                  "https://cdn-icons-png.flaticon.com/512/7016/7016539.png"),
                                        ),
                                        (widget.type == "eth")
                                            ? Text(
                                                data['ether']
                                                    .toStringAsFixed(5),
                                                style: const TextStyle(
                                                    fontSize: 48,
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                data['sol'].toStringAsFixed(5),
                                                style: const TextStyle(
                                                    fontSize: 48,
                                                    color: Colors.white),
                                              ),
                                      ],
                                    ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: (widget.type == "eth")
                                        ? Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/8042/8042859.png")
                                        : Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/7016/7016539.png"),
                                  ),
                                  const Text(" 1 = ",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    "\u{20B9} ${web3.rupee.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const Spacer()
                            ],
                          );
                        }
                      }))),
        );
      },
    );
  }
}
