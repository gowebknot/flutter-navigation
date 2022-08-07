// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easy_nav/src/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

class EasyNavigationMenu extends StatefulWidget {
  const EasyNavigationMenu({Key? key}) : super(key: key);

  @override
  State<EasyNavigationMenu> createState() => _EasyNavigationMenuState();
}

class _EasyNavigationMenuState extends State<EasyNavigationMenu>
    with SingleTickerProviderStateMixin {
  final double menuRadius = 164.0;
  final double buttonRadius = 44.0;
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late final Animation<double> _expandAnimation;
  late Animation _scaleCurve;
  double currentRad = 1.0;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
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
    return Stack(
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
        ..._buildExpandingActionButtons([
          IconButton(onPressed: () {}, icon: Icon(LineIcons.dotCircle)),
          IconButton(
              onPressed: () {}, icon: Icon(LineIcons.faceWithRollingEyes)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.yelp)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.hockeyPuck)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.firefox)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.faceBlowingAKiss)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.meteor)),
          IconButton(
              onPressed: () {}, icon: Icon(LineIcons.amazonWebServicesAws)),
          IconButton(onPressed: () {}, icon: Icon(LineIcons.cheese)),
        ]),
        InkWell(
          onTap: () {
            setState(() {
              _isOpen = !_isOpen;
              print(_controller.value);
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
                  color: primaryColor),
              height: buttonRadius,
              width: buttonRadius,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.13).animate(_controller),
                child: Center(
                    child: Icon(
                  LineIcons.plus,
                  color: Colors.white,
                  size: 26.0,
                )),
              )),
        ),
      ],
    );
  }

  List<Widget> _buildExpandingActionButtons(List<Widget> widgets) {
    final children = <Widget>[];
    final count = widgets.length;
    final step = (count * 60.0) / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: 64,
          progress: _expandAnimation,
          child: widgets[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 300.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 58.0 + offset.dx,
          bottom: 58.0 + offset.dy - 2,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}


// 6 -> 220