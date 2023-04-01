import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class LoadingAccountTileList extends StatefulWidget {
  const LoadingAccountTileList(
      {Key? key,
      this.animationController,
      this.animation,
      required this.onGoBack})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;
  final onGoBack;

  @override
  State<LoadingAccountTileList> createState() => _LoadingAccountTileListState();
}

class _LoadingAccountTileListState extends State<LoadingAccountTileList>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late Animation _animation1;
  @override
  void initState() {
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController1.repeat(reverse: true);
    _animation1 = Tween(begin: 2.0, end: 15.0).animate(_animationController1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var web3 = Provider.of<Web3EthProvider>(context, listen: false);
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
                    height: 400,
                    // color: Colors.amber,
                    width: double.infinity,
                    // color: Colors.yellow,
                    child: AccountBuilder(
                        widget: widget, animation: _animation1))),
          ),
        );
      },
    );
  }
}

class AccountBuilder extends StatelessWidget {
  const AccountBuilder({
    Key? key,
    required this.widget,
    required Animation animation,
  })  : _animation = animation,
        super(key: key);

  final LoadingAccountTileList widget;
  final Animation _animation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: scrollController,
      padding: EdgeInsets.only(
        // top: AppBar().preferredSize.height +
        //     MediaQuery.of(context).padding.top +
        //     24,
        bottom: 110 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: 3,
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx, int index) {
        widget.animationController?.forward();
        return Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Container(
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
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value),
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
                            children: const <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 4, bottom: 3),
                                child: Text(
                                  "accountName",
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
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 4, bottom: 3, top: 3),
                        child: Text(
                          "Account Adress",
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
        );
      },
    );
  }
}
