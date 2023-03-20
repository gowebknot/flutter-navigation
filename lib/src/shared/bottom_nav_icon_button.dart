/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/
import 'package:navigation_panel/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// class BottomNavButton
/// 
/// Main menu button widget for [CenterDockedAnimatedNav]
class BottomNavButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;
  final Color activeIconColor;
  final bool isActive;

  const BottomNavButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.iconColor,
      required this.activeIconColor,
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
          color: widget.isActive ? widget.activeIconColor : widget.iconColor,
        ),
      ),
    );
  }
}
