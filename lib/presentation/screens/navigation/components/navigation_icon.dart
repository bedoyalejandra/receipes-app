import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavigationIcon extends StatelessWidget {
  const NavigationIcon({
    Key? key,
    required this.iconPath,
    required this.onTap,
    this.badgeCount = 0,
  }) : super(key: key);
  final String iconPath;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
          if (badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(maxWidth: 16, maxHeight: 16),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
