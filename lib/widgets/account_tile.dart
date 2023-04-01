import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class AccountTile extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String accountName;
  final String accountAddress;

  const AccountTile(
      {Key? key,
      this.animationController,
      this.animation,
      required this.accountName,
      required this.accountAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  left: 10, right: 10, top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  // ignore: prefer_const_constructors
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 16, right: 24, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      accountName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: AppTheme.mainBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 3, top: 3),
                            child: Text(
                              accountAddress,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  letterSpacing: -0.1,
                                  color: AppTheme.darkText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
