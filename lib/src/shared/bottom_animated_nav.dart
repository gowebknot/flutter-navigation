// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easy_nav/src/shared/colors.dart';
import 'package:easy_nav/src/shared/icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

class BottomAnimatedNav extends StatefulWidget {
  final List<NavButton> navItems;
  const BottomAnimatedNav({Key? key, required this.navItems}) : super(key: key);

  @override
  State<BottomAnimatedNav> createState() => _BottomAnimatedNavState();
}

class _BottomAnimatedNavState extends State<BottomAnimatedNav>
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
    final size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, size.height / 14 + 18),
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
                        color: whiteColor),
                    height: menuRadius,
                    width: menuRadius,
                  ),
                ),
                for (var index = 0, angleInDegrees = 15.0;
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
                              BorderRadius.all(Radius.circular(100.0)),
                          color: primaryColor),
                      height: buttonRadius,
                      width: buttonRadius,
                      child: RotationTransition(
                        turns:
                            Tween(begin: 0.0, end: 0.13).animate(_controller),
                        child: Center(
                            child: Icon(
                          LineIcons.plus,
                          color: Colors.white,
                          size: 26.0,
                        )),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
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
      required this.click});

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final NavButton child;
  final bool isActive;
  final VoidCallback click;

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
          widget.directionInDegrees * (math.pi / 340.0),
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
            widget.child.onTap!();
          },
          icon: widget.child.icon,
          activeIconColor: widget.child.activeIconColor,
          iconColor: widget.child.iconColor,
          isActive: widget.isActive,
        ),
      ),
    );
  }
}
