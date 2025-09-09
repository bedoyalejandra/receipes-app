import 'package:flutter/material.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = CustomColors.primaryColor,
    this.verticalPadding = 16,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String title;
  final Color? backgroundColor;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
    );
  }
}
