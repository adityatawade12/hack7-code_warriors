import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';

class AccountTypes extends StatefulWidget {
  const AccountTypes(
      {Key? key,
      this.animationController,
      this.animation,
      required this.onGoBack})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final onGoBack;

  @override
  State<AccountTypes> createState() => _AccountTypesState();
}

class _AccountTypesState extends State<AccountTypes> {
  @override
  Widget build(BuildContext context) {
    var web3 = Provider.of<Web3EthProvider>(context, listen: false);

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 18),
                child: SizedBox(
                    height: 350,
                    // color: Colors.amber,
                    width: double.infinity,
                    // color: Colors.yellow,
                    child: SingleChildScrollView(
                      child: GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              // ignore: prefer_const_constructors
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                  topRight: const Radius.circular(8.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.2),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    "https://cdn-icons-png.flaticon.com/512/8193/8193845.png",
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "Solana",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: 0.5,
                                        color: AppTheme.lightText,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              // ignore: prefer_const_constructors
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                  topRight: const Radius.circular(8.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.2),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    "https://cdn-icons-png.flaticon.com/512/7016/7016523.png",
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "Ethereum",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: 0.5,
                                        color: AppTheme.lightText,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              // ignore: prefer_const_constructors
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                  topRight: const Radius.circular(38.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.2),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Center(
                              child: Text("Eth"),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              // ignore: prefer_const_constructors
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                  topRight: const Radius.circular(38.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.2),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Center(
                              child: Text("Solana"),
                            ),
                          ),
                        ],
                      ),

                      // GridView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: 4,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: 2,
                      //             crossAxisSpacing: 4.0,
                      //             mainAxisSpacing: 4.0),
                      //     itemBuilder: (ctx, i) => Container(
                      //           height: 120,
                      //           width: 120,
                      //           margin: EdgeInsets.all(10),
                      //           decoration: BoxDecoration(
                      //             color: AppTheme.white,
                      //             // ignore: prefer_const_constructors
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: const Radius.circular(8.0),
                      //                 bottomLeft: const Radius.circular(8.0),
                      //                 bottomRight: const Radius.circular(8.0),
                      //                 topRight: const Radius.circular(38.0)),
                      //             boxShadow: <BoxShadow>[
                      //               BoxShadow(
                      //                   color: AppTheme.grey.withOpacity(0.2),
                      //                   offset: const Offset(1.1, 1.1),
                      //                   blurRadius: 10.0),
                      //             ],
                      //           ),
                      //           child: Center(
                      //             child: Text("BitC"),
                      //           ),
                      //         ))
                    ))),
          ),
        );
      },
    );
  }
}
