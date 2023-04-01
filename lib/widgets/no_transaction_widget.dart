import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class NoTransaction extends StatefulWidget {
  const NoTransaction(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      required this.title})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String title;

  @override
  _NoTransactionState createState() => _NoTransactionState();
}

class _NoTransactionState extends State<NoTransaction>
    with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  // child: NewWidget(),
                  child: SizedBox(
                    height: 230,
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/txn.png", height: 70),
                          // Image.network(
                          //   "https://cdn-icons-png.flaticon.com/512/3186/3186949.png",
                          //   height: 70,
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.title,
                            // "No transactions yet!",
                            style: const TextStyle(
                              color: AppTheme.mainBlue,
                              fontFamily: AppTheme.fontName,
                              fontSize: 20,
                            ),
                          )
                        ]),
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
