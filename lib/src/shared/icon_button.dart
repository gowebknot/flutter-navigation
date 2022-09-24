import 'package:easy_nav/src/utils/utils.dart';
import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  final Color activeIconColor;
  final bool isActive;
  final Color activeNavItemBgColor;

  const NavButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.iconColor,
      required this.activeIconColor,
      required this.activeNavItemBgColor,
      this.isActive = false})
      : super(key: key);

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton>
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
        decoration: BoxDecoration(
            color: widget.isActive
                ? widget.activeNavItemBgColor
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(50.0))),
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          widget.icon,
          size: 22.0,
          color: widget.isActive ? widget.activeIconColor : widget.iconColor,
        ),
      ),
    );
  }
}
