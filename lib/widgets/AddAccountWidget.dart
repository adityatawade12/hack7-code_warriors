import 'package:flutter/material.dart';
import 'package:hack7/screens/account/AddAccountsScreen.dart';
import 'package:hack7/themes/apptheme.dart';

class AddAccountWidget extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final onGoBack;

  const AddAccountWidget({
    Key? key,
    this.animationController,
    this.animation,
    this.onGoBack,
  }) : super(key: key);

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      child: GridTile(
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(68.0)),
                              // color: Colors.blue,
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(68, 72, 214, 1),
                                    AppTheme.nearlyBlue
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                Text(
                                  "New",
                                  style: TextStyle(
                                      fontSize: 21, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        animationController!.reverse().then((value) {
                          Navigator.pushNamed(
                                  context, AddAccountScreen.routename)
                              .then(onGoBack);
                        });
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: 100,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "OR",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: 100,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: GridTile(
                      // footer: Text("Create"),
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(68.0),
                                bottomRight: Radius.circular(3.0),
                                topRight: Radius.circular(8.0)),
                            // color: Colors.blue,
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(68, 72, 214, 1),
                                  AppTheme.nearlyBlue
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        width: 150,
                        height: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.file_download_outlined,
                                size: 70,
                                color: Colors.white,
                              ),
                              Text(
                                "Import",
                                style: TextStyle(
                                    fontSize: 21, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      animationController!.reverse().then((value) {
                        Navigator.pushNamed(context, AddAccountScreen.routename)
                            .then(onGoBack);
                      });
                    },
                  ),
                ],
              )),
        );
      },
    );
  }
}
