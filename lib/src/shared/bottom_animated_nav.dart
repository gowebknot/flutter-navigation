/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/
import 'dart:math' as math;
import 'package:navigation_panel/navigation_panel.dart';
import 'package:navigation_panel/src/shared/bottom_nav_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:navigation_panel/src/shared/colors.dart';

/// class [CenterDockedAnimatedNav]
///
/// center docked navigation menu widget
class CenterDockedAnimatedNav extends StatefulWidget {
  final List<MenuNavItem> navItems;
  final Color navItemIconColor;
  final Color activeNavItemIconColor;
  final Color backgroundColor;
  final Color menuIconColor;
  final Color activeNavItemBgColor;
  final Color menuItemsFirstColor;
  final Color menuItemsSecondColor;
  const CenterDockedAnimatedNav(
      {Key? key,
      required this.navItems,
      this.activeNavItemIconColor = AppColors.whiteColor,
      this.backgroundColor = AppColors.whiteColor,
      this.menuIconColor = AppColors.greyBgColor,
      this.menuItemsFirstColor = AppColors.blackColor,
      this.menuItemsSecondColor = AppColors.greyBgColor,
      this.activeNavItemBgColor = AppColors.pinkColor,
      this.navItemIconColor = AppColors.whiteColor})
      : assert(navItems.length >= 1 && navItems.length <= 5),
        super(key: key);

  @override
  State<CenterDockedAnimatedNav> createState() =>
      _CenterDockedAnimatedNavState();
}

class _CenterDockedAnimatedNavState extends State<CenterDockedAnimatedNav>
    with SingleTickerProviderStateMixin {
  /// Main menu radius
  final double menuRadius = 168.0;

  /// Menu Icon radius
  final double buttonRadius = 60.0;
  Map<int, double> anglesMap = {5: 58, 4: 72, 3: 96, 2: 120, 1: 120};

  /// animation controller
  late AnimationController _controller;
  late final Animation<double> _expandAnimation;

  /// menu initial state
  bool _isOpen = false;

  /// initial active index
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

  /// Returns main view for center docked navigation menu
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0, 100),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: _expandAnimation,
                  alignment: FractionalOffset.center,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    ),
                    height: menuRadius,
                    width: menuRadius,
                    child: CustomPaint(
                      painter: _WheelPainter(
                          index: currentActiveButtonIndex,
                          activeNavItemBgColor: widget.activeNavItemBgColor,
                          menuItemsFirstColor: widget.menuItemsFirstColor,
                          menuItemsSecondColor: widget.menuItemsSecondColor,
                          widgetsCount: widget.navItems.length),
                    ),
                  ),
                ),
                for (var index = 0,
                        angleInDegrees = (widget.navItems.length <= 2)
                            ? (widget.navItems.length + 40.0)
                            : (widget.navItems.length + 22.0);
                    index < widget.navItems.length;
                    index++,
                    angleInDegrees += (widget.navItems.length *
                            anglesMap[widget.navItems.length]!) /
                        (widget.navItems.length - 1))
                  _ExpandingActionButton(
                    index: index,
                    click: () {
                      setState(() {
                        currentActiveButtonIndex = index;
                      });
                    },
                    directionInDegrees: angleInDegrees,
                    maxDistance: 62,
                    progress: _expandAnimation,
                    isActive: index == currentActiveButtonIndex,
                    activeNavItemIconColor: widget.activeNavItemIconColor,
                    navItemIconColor: widget.navItemIconColor,
                    child: widget.navItems[index],
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
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
                        color: widget.backgroundColor),
                    height: buttonRadius,
                    width: buttonRadius,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: RotationTransition(
                          turns:
                              Tween(begin: 0.0, end: 0.13).animate(_controller),
                          child: Icon(
                            LineIcons.plus,
                            color: widget.menuIconColor,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
  const _ExpandingActionButton(
      {required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child,
      required this.isActive,
      required this.index,
      required this.activeNavItemIconColor,
      required this.navItemIconColor,
      required this.click});

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final MenuNavItem child;
  final bool isActive;
  final int index;
  final VoidCallback click;
  final Color navItemIconColor;
  final Color activeNavItemIconColor;

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
          widget.directionInDegrees * (math.pi / 338.0),
          widget.progress.value * widget.maxDistance,
        );
        return Positioned(
          right: 70.0 + offset.dx,
          bottom: 72.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - widget.progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: widget.progress,
        child: Center(
          child: BottomNavButton(
            onTap: () {
              widget.click();
              widget.child.onTap();
            },
            icon: widget.child.icon,
            activeIconColor: widget.activeNavItemIconColor,
            iconColor: widget.navItemIconColor,
            isActive: widget.isActive,
          ),
        ),
      ),
    );
  }
}

/// class [_WheelPainter]
///
/// Divides a semi circle into [widgetsCount] equal parts
///
class _WheelPainter extends CustomPainter {
  int index = 0;
  int widgetsCount = 0;
  final Color activeNavItemBgColor;
  final Color menuItemsFirstColor;
  final Color menuItemsSecondColor;

  _WheelPainter(
      {required this.index,
      required this.widgetsCount,
      required this.menuItemsFirstColor,
      required this.menuItemsSecondColor,
      required this.activeNavItemBgColor});
  Path getWheelPath(double wheelSize, double fromRadius, double toRadius) {
    return Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
              radius: wheelSize, center: Offset(wheelSize, wheelSize)),
          fromRadius,
          toRadius,
          false)
      ..close();
  }

  Paint getColoredPaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 84;
    int elementCount = widgetsCount;
    double radius = math.pi / elementCount;
    canvas.drawPath(getWheelPath(wheelSize, 10, math.pi + 10),
        getColoredPaint(Colors.transparent));
    for (var i = 0; i < 5; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, math.pi + (radius * i), radius),
          getColoredPaint(index == i
              ? activeNavItemBgColor
              : i % 2 == 0
                  ? menuItemsFirstColor
                  : menuItemsSecondColor));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
