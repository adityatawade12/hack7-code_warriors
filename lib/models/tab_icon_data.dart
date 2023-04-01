import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    required this.image,
    this.index = 0,
    required this.selectedImage,
    this.isSelected = false,
    this.animationController, 
  });

  IconData image;
  IconData selectedImage;
  bool isSelected;
  int index;
  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      image: Icons.home_outlined,
      selectedImage: Icons.home_rounded,
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      image: Icons.account_circle_outlined,
      selectedImage: Icons.account_circle,
      index: 1,
      isSelected: false,
      animationController: null,
    )
  ];
}
