import 'package:easy_nav/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BottomRightNavButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  final Color activeIconColor;
  final bool isActive;

  const BottomRightNavButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.iconColor,
      required this.activeIconColor,
      this.isActive = false})
      : super(key: key);

  @override
  State<BottomRightNavButton> createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<BottomRightNavButton>
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
          size: 24.0,
          color: widget.isActive ? widget.activeIconColor : widget.iconColor,
        ),
      ),
    );
  }
}
