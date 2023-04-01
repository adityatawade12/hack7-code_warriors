import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class AccountRadioTile extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String accountName;
  final String accountAddress;
  final String groupval;
  final func;

  const AccountRadioTile(
      {Key? key,
      this.animationController,
      this.animation,
      required this.accountName,
      required this.accountAddress,
      required this.groupval,
      this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.mainBlue.withOpacity(0.25),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: RadioListTile(
                    title: Text(
                      accountName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppTheme.mainBlue,
                      ),
                    ),
                    subtitle: Text(
                      accountAddress,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: -0.1,
                          color: AppTheme.darkText),
                    ),
                    value: accountAddress,
                    groupValue: groupval,
                    onChanged: ((value) {
                      func(accountAddress);
                    })),
              ),
            ),
          ),
        );
      },
    );
  }
}
