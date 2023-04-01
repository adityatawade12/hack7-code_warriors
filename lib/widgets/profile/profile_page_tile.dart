import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class ProfilePageTile extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String imageLink;
  final IconData? imageIcon;
  final String title;
  final String subtext;

  const ProfilePageTile(
      {Key? key,
      this.animationController,
      this.animation,
      required this.imageLink,
      this.imageIcon,
      required this.title,
      required this.subtext})
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 0, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Row(
                            // alignment: Alignment.centerLeft,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 45,
                                width: 50,
                                // color: Colors.yellow,
                                // child: AspectRatio(
                                //     aspectRatio: 1,
                                //     // child: Image.network(imageLink)
                                    child: Icon(
                                      imageIcon,
                                      color: AppTheme.mainBlue,
                                      size: 45,
                                    ),
                                    // Image.asset("assets/images/back.png"),
                                    // ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              // ClipRRect(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(8.0)),
                              //   child: Container(
                              //     height: 50,
                              //     width: 50,
                              //     color: Colors.yellow,
                              //     child: AspectRatio(
                              //         aspectRatio: 1,
                              //         child: Image.network(
                              //             "https://cdn-icons-png.flaticon.com/512/9063/9063966.png")
                              //         // Image.asset("assets/images/back.png"),
                              //         ),
                              //   ),
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 00,
                                      right: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        color: AppTheme.mainBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 0,
                                      bottom: 12,
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        subtext,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          letterSpacing: 0.0,
                                          color: AppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: -16,
                      //   left: 0,
                      //   child: SizedBox(
                      //     width: 110,
                      //     height: 50,
                      //     child: Image.network(
                      //         "https://cdn-icons-png.flaticon.com/512/9063/9063966.png"),
                      //   ),
                      // )
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
