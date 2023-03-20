/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/
import 'package:navigation_panel/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// class [NavButton]
///
/// IconButton for [CenterFloatAnimatedNav] menu
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

/// Private class [_NavButtonState]
///
/// Creates state for stateful widget [NavButton]
class _NavButtonState extends State<NavButton>
    with SingleTickerProviderStateMixin {
  ///
  /// Returns Small Rounded Button for [CenterFloatAnimatedNav] menu
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
