import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavigationIcon extends StatelessWidget {
  const NavigationIcon({Key? key, required this.iconPath, required this.onTap}) : super(key: key);
  final String iconPath;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(iconPath, width: 24, height: 24),
      )
    );
  }
}