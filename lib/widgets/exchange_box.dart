import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';

class ExchangeBox extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ExchangeBox({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<ExchangeBox> createState() => _ExchangeBoxState();
}

class _ExchangeBoxState extends State<ExchangeBox> {
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
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.mainBlue, AppTheme.nearlyBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.6),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ignore: prefer_const_constructors
                      Text(
                        'Exchange:',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          letterSpacing: 0.0,
                          color: AppTheme.white,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: const Text(
                      //     'Legs Toning and\nGlutes Workout at Home',
                      //     textAlign: TextAlign.left,
                      //     style: TextStyle(
                      //       fontFamily: AppTheme.fontName,
                      //       fontWeight: FontWeight.normal,
                      //       fontSize: 20,
                      //       letterSpacing: 0.0,
                      //       color: AppTheme.white,
                      //     ),
                      //   ),
                      // ),
                      Container(
                          height: 90,
                          child: FutureBuilder(
                            future: Provider.of<Web3EthProvider>(context, listen: false).getEtherExchange(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: SizedBox(
                                      width: 35,
                                      child: CircularProgressIndicator(
                                        color: AppTheme.nearlyWhite,
                                      )),
                                );
                              } else {
                                var data = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/8042/8042859.png"),
                                      ),
                                      const Text(" 1 = ",
                                          style: TextStyle(
                                              fontSize: 45,
                                              color: AppTheme.white)),
                                      Text(
                                        "\u{20B9}$data",
                                        style: const TextStyle(
                                            fontSize: 45,
                                            color: AppTheme.white),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          )),
                      const SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              // child: Icon(
                              //   Icons.timer,
                              //   color: AppTheme.white,
                              //   size: 16,
                              // ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(
                            //       Icons.refresh,
                            //       // color: AppTheme.nearlyBlue,
                            //       color: AppTheme.white,

                            //       size: 30,
                            //     )),
                            InkWell(
                              onTap: (() {
                                setState(() {});
                              }),
                              child: Container(
                                decoration: const BoxDecoration(
                                  // color: AppTheme.nearlyBlue,
                                  shape: BoxShape.circle,
                                  // boxShadow: <BoxShadow>[
                                  //   BoxShadow(
                                  //       color: AppTheme.nearlyBlack
                                  //           .withOpacity(0.4),
                                  //       offset: Offset(8.0, 8.0),
                                  //       blurRadius: 8.0),
                                  // ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.refresh,
                                    // color: AppTheme.nearlyBlue,
                                    color: AppTheme.white,

                                    size: 25,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
