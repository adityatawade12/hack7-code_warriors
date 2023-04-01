import 'package:flutter/material.dart';
import 'package:hack7/screens/payment/request_pay_create.dart';
import 'package:hack7/themes/apptheme.dart';


class TransactionsHeader extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String address;
  final onGoBack;

  const TransactionsHeader(
      {Key? key,
      this.animationController,
      this.animation,
      required this.onGoBack,
      required this.address})
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
              padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      "Transactions:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      animationController!.reverse().then((value) {
                        Navigator.pushNamed(
                                context, CreatePayRequestScreen.routename,
                                arguments: address)
                            .then(onGoBack);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            "Request Payment",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              letterSpacing: 0.5,
                              color: AppTheme.mainBlue,
                            ),
                          ),
                          SizedBox(
                            height: 38,
                            width: 26,
                            child: Icon(
                              Icons.arrow_forward,
                              color: AppTheme.darkText,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
