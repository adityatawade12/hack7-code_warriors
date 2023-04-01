import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/no_vpa.dart';
import 'package:hack7/widgets/vpaQrBox.dart';
import 'package:provider/provider.dart';

class ProfileQrView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProfileQrView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthService>(context, listen: false);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 2, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.mainBlue, AppTheme.nearlyBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
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
                      SizedBox(height: 10),
                      Container(),
                      Container(
                        width: 210,
                        height: 210,
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
                        child: (auth.loggedInUser.primaryAccountEth == "")
                            ? NoVpa()
                            : VPAQr(auth.loggedInUser.vpa),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         height: 40,
                      //         child: Image.network(
                      //             "https://cdn-icons-png.flaticon.com/512/8042/8042859.png"),
                      //       ),
                      //       Text(" 1 = ",
                      //           style: TextStyle(
                      //               fontSize: 41,
                      //               color: AppTheme.white)),
                      //       Text(
                      //         "\u{20B9}90000",
                      //         style: TextStyle(
                      //             fontSize: 35, color: AppTheme.white),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        // "loggedInUser",
                        auth.loggedInUser.vpa,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          letterSpacing: 0.0,
                          color: AppTheme.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        // "loggedInUser",
                        auth.loggedInUser.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 30,
                          letterSpacing: 0.0,
                          color: AppTheme.white,
                        ),
                      ),
                      SizedBox(height: 5),

                      // Padding(
                      //   padding: const EdgeInsets.only(right: 4),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 4),
                      //         child: Icon(
                      //           Icons.timer,
                      //           color: AppTheme.white,
                      //           size: 16,
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 4.0),
                      //         child: const Text(
                      //           '68 min',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             fontFamily: AppTheme.fontName,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 14,
                      //             letterSpacing: 0.0,
                      //             color: AppTheme.white,
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: SizedBox(),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: AppTheme.nearlyBlue,
                      //           shape: BoxShape.circle,
                      //           boxShadow: <BoxShadow>[
                      //             BoxShadow(
                      //                 color: AppTheme.nearlyBlack
                      //                     .withOpacity(0.4),
                      //                 offset: Offset(8.0, 8.0),
                      //                 blurRadius: 8.0),
                      //           ],
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(0.0),
                      //           child: Icon(
                      //             Icons.refresh,
                      //             // color: AppTheme.nearlyBlue,
                      //             color: AppTheme.white,

                      //             size: 30,
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
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
