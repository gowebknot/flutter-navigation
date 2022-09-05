import 'package:easy_nav/easy_nav.dart';
import 'package:easy_nav/src/shared/colors.dart';
import 'package:easy_nav/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BottomNavButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? iconColor;
  final Color? activeIconColor;
  final bool isActive;

  const BottomNavButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      this.iconColor = blackColor,
      this.activeIconColor = whiteColor,
      this.isActive = false})
      : super(key: key);

  @override
  State<BottomNavButton> createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<BottomNavButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onTap!();
        });
      },
      child: AnimatedContainer(
        duration: 500.ms,
        curve: Curves.easeInSine,
        decoration: const BoxDecoration(
            // color: widget.isActive ? secondaryColor : whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          widget.icon,
          size: 22.0,
          color: widget.activeIconColor,
        ),
      ),
    );
  }
}
