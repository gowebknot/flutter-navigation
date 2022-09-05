// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:easy_nav/src/shared/colors.dart';
import 'package:easy_nav/src/shared/icon_button_2.dart';

class BottomAnimatedNav extends StatefulWidget {
  final List<BottomNavButton> navItems;
  const BottomAnimatedNav({Key? key, required this.navItems})
      : assert(navItems.length >= 1 && navItems.length <= 5),
        super(key: key);

  @override
  State<BottomAnimatedNav> createState() => _BottomAnimatedNavState();
}

class _BottomAnimatedNavState extends State<BottomAnimatedNav>
    with SingleTickerProviderStateMixin {
  final double menuRadius = 168.0;
  final double buttonRadius = 52.0;
  Map<int, double> anglesMap = {5: 58, 4: 72, 3: 96, 2: 120, 1: 120};

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
      child: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, 100),
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
                        color: greyBgColor),
                    height: menuRadius,
                    width: menuRadius,
                    child: CustomPaint(
                      painter: WheelPainter(
                          index: currentActiveButtonIndex,
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
                    maxDistance: 63,
                    progress: _expandAnimation,
                    isActive: index == currentActiveButtonIndex,
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
                        borderRadius: BorderRadius.only(
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
                        color: whiteColor),
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
                            color: greyBgColor,
                            size: 19.0,
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

@immutable
class _ExpandingActionButton extends StatefulWidget {
  const _ExpandingActionButton(
      {required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child,
      required this.isActive,
      required this.index,
      required this.click});

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final BottomNavButton child;
  final bool isActive;
  final int index;
  final VoidCallback click;

  @override
  State<_ExpandingActionButton> createState() => _ExpandingActionButtonState();
}

class _ExpandingActionButtonState extends State<_ExpandingActionButton> {
  @override
  Widget build(BuildContext context) {
    final offset = Offset.fromDirection(
      widget.directionInDegrees * (math.pi / 338.0),
      widget.progress.value * widget.maxDistance,
    );
    return AnimatedBuilder(
      animation: widget.progress,
      builder: (context, child) {
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
              widget.child.onTap!();
            },
            icon: widget.child.icon,
            activeIconColor: widget.child.activeIconColor,
            iconColor: widget.child.iconColor,
            isActive: widget.isActive,
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  int index = 0;
  int widgetsCount = 0;
  WheelPainter({required this.index, required this.widgetsCount});
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
    double radius = pi / elementCount;
    canvas.drawPath(getWheelPath(wheelSize, 10, pi + 10),
        getColoredPaint(Colors.transparent));
    for (var i = 0; i < 5; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, pi + (radius * i), radius),
          getColoredPaint(index == i
              ? pinkColor
              : i % 2 == 0
                  ? blackColor
                  : greyBgColor));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
