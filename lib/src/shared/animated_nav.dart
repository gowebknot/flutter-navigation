/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/
import 'package:navigation_panel/navigation_panel.dart';
import 'package:navigation_panel/src/shared/colors.dart';
import 'package:navigation_panel/src/shared/icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

/// class [CenterFloatAnimatedNav]
///
/// Center Float Main Navigation Menu Widget
class CenterFloatAnimatedNav extends StatefulWidget {
  final List<MenuNavItem> navItems;
  final Color backgroundColor;
  final Color menuBgColor;
  final Color menuIconColor;
  final Color navItemIconColor;
  final Color activeNavItemIconColor;
  final Color activeNavItemBackground;

  const CenterFloatAnimatedNav(
      {Key? key,
      required this.navItems,
      this.backgroundColor = AppColors.whiteColor,
      this.menuBgColor = AppColors.primaryColor,
      this.navItemIconColor = AppColors.blackColor,
      this.activeNavItemIconColor = AppColors.whiteColor,
      this.activeNavItemBackground = AppColors.secondaryColor,
      this.menuIconColor = AppColors.whiteColor})
      : super(key: key);

  @override
  State<CenterFloatAnimatedNav> createState() => _CenterFloatAnimatedNavState();
}

class _CenterFloatAnimatedNavState extends State<CenterFloatAnimatedNav>
    with SingleTickerProviderStateMixin {
  final double menuRadius = 168.0;
  final double buttonRadius = 44.0;

  late AnimationController _controller;
  late final Animation<double> _expandAnimation;

  bool _isOpen = false;
  int currentActiveButtonIndex = 0;

  /// on init
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
      parent: _controller,
    );
    super.initState();
  }

  /// overriding dispose method
  ///
  /// triggers when object is removed from tree
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// returns center positioned Main Navigation Menu
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _expandAnimation,
              alignment: FractionalOffset.center,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    color: widget.backgroundColor),
                height: menuRadius,
                width: menuRadius,
              ),
            ),
            for (var index = 0, angleInDegrees = 0.0;
                index < widget.navItems.length;
                index++,
                angleInDegrees += (widget.navItems.length * 60.0) /
                    (widget.navItems.length - 1))
              _ExpandingActionButton(
                click: () {
                  setState(() {
                    currentActiveButtonIndex = index;
                  });
                },
                directionInDegrees: angleInDegrees,
                maxDistance: 62,
                progress: _expandAnimation,
                isActive: index == currentActiveButtonIndex,
                child: widget.navItems[index],
                activeNavItemBackground: widget.activeNavItemBackground,
                activeNavItemIconColor: widget.activeNavItemIconColor,
                navItemIconColor: widget.navItemIconColor,
              ),
            InkWell(
              onTap: () {
                setState(() {
                  _isOpen = !_isOpen;
                  if (kDebugMode) {
                    print(_controller.value);
                  }
                  _isOpen ? _controller.forward() : _controller.reverse();
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(
                            2.0,
                            4.0,
                          ),
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                        )
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0)),
                      color: widget.menuBgColor),
                  height: buttonRadius,
                  width: buttonRadius,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.13).animate(_controller),
                    child: Center(
                        child: Icon(
                      LineIcons.plus,
                      color: widget.menuIconColor,
                      size: 26.0,
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

/// class [_ExpandingActionButton]
///
/// Each _ExpandingActionButton represents one Menu Icon
@immutable
class _ExpandingActionButton extends StatefulWidget {
  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final MenuNavItem child;
  final bool isActive;
  final VoidCallback click;
  final Color navItemIconColor;
  final Color activeNavItemIconColor;
  final Color activeNavItemBackground;
  const _ExpandingActionButton(
      {required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child,
      required this.isActive,
      required this.activeNavItemBackground,
      required this.activeNavItemIconColor,
      required this.navItemIconColor,
      required this.click});

  @override
  State<_ExpandingActionButton> createState() => _ExpandingActionButtonState();
}

class _ExpandingActionButtonState extends State<_ExpandingActionButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          widget.directionInDegrees * (math.pi / 274.0),
          widget.progress.value * widget.maxDistance,
        );
        return Positioned(
          right: 67.0 + offset.dx,
          bottom: 68.0 + offset.dy - 2,
          child: Transform.rotate(
            angle: (1.0 - widget.progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: widget.progress,
        child: NavButton(
          onTap: () {
            widget.click();
            widget.child.onTap();
          },
          icon: widget.child.icon,
          activeIconColor: widget.activeNavItemIconColor,
          iconColor: widget.navItemIconColor,
          isActive: widget.isActive,
          activeNavItemBgColor: widget.activeNavItemBackground,
        ),
      ),
    );
  }
}
