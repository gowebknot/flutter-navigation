// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:navigation_panel/navigation_panel.dart';
import 'package:navigation_panel/src/shared/icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

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
      this.backgroundColor = whiteColor,
      this.menuBgColor = primaryColor,
      this.navItemIconColor = blackColor,
      this.activeNavItemIconColor = whiteColor,
      this.activeNavItemBackground = secondaryColor,
      this.menuIconColor = whiteColor})
      : super(key: key);

  @override
  State<CenterFloatAnimatedNav> createState() => _CenterFloatAnimatedNavState();
}

class _CenterFloatAnimatedNavState extends State<CenterFloatAnimatedNav>
    with SingleTickerProviderStateMixin {
  final double menuRadius = 168.0;
  final double buttonRadius = 44.0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late final Animation<double> _expandAnimation;
  late Animation _scaleCurve;

  bool _isOpen = false;
  int currentActiveButtonIndex = 0;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleCurve = CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0)
        .animate(_scaleCurve as Animation<double>)
      ..addListener(() {
        setState(() {});
      });

    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
      parent: _controller,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                1.0,
                0.0,
              )..scale(_expandAnimation.value),
              alignment: FractionalOffset.center,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
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
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
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
