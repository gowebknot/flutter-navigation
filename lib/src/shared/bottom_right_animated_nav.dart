// ignore_for_file: depend_on_referenced_packages
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigation_panel/src/shared/colors.dart';
import 'package:navigation_panel/src/shared/menu_nav_item.dart';
import 'package:vector_math/vector_math.dart' as vector;

class EndDockedAnimatedNav extends StatefulWidget {
  final List<MenuNavItem> navItems;
  final Color? menuBgColor;
  final Widget menuOpenIcon;
  final Widget menuCloseIcon;
  final Color activeNavItemBgColor;
  final Color menuNavItemsIconColor;

  const EndDockedAnimatedNav(
      {Key? key,
      this.menuBgColor,
      this.menuOpenIcon = const Icon(Icons.menu),
      this.activeNavItemBgColor = pinkColor,
      this.menuCloseIcon = const Icon(Icons.close),
      this.menuNavItemsIconColor = whiteColor,
      required this.navItems})
      : assert(navItems.length >= 1),
        super(key: key);

  @override
  EndDockedAnimatedNavState createState() => EndDockedAnimatedNavState();
}

class EndDockedAnimatedNavState extends State<EndDockedAnimatedNav>
    with TickerProviderStateMixin {
  late double _screenWidth;
  late double _screenHeight;
  late double _marginH;
  late double _marginV;
  late double _directionX;
  late double _directionY;
  late double _translationX;
  late double _translationY;

  double? _ringDiameter;
  double? _ringWidth;
  Color? _menuOpenColor;
  double fabSize = 68.0;
  double ringWidth = 100.0;
  Curve animationCurve = Curves.easeInOutCirc;
  EdgeInsets fabMargin = const EdgeInsets.all(16.0);
  Alignment menuAlignment = Alignment.bottomRight;
  final ShapeBorder _fabIconBorder = const CircleBorder();

  late AnimationController _animationController;
  late AnimationController _animationController2;
  late Animation<double> _scaleAnimation;
  late Animation _scaleCurve;
  late Animation<double> _rotateAnimation;
  late Animation _rotateCurve;
  Animation<Color?>? _colorAnimation;
  late Animation _colorCurve;
  bool _isOpen = false;
  bool _isAnimating = false;
  List<MenuNavItem> localChild = [];

  @override
  void initState() {
    localChild = widget.navItems;
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animationController2 = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _scaleCurve = CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.4, curve: animationCurve));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_scaleCurve as Animation<double>)
      ..addListener(() {
        setState(() {});
      });

    _rotateCurve = CurvedAnimation(
        parent: _animationController2,
        curve: Interval(0.0, 1.0, curve: animationCurve));
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_rotateCurve as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateProps();
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
      _calculateProps();
    }

    return Transform.translate(
        offset: const Offset(20, 36),
        child: Container(
          transform: Matrix4.translationValues(16.0, 16.0, 0.0),
          child: Stack(
            alignment: menuAlignment,
            children: <Widget>[
              // Ring
              Transform(
                transform: Matrix4.translationValues(
                  _translationX,
                  _translationY,
                  0.0,
                )..scale(_scaleAnimation.value),
                alignment: FractionalOffset.center,
                child: OverflowBox(
                  maxWidth: _ringDiameter,
                  maxHeight: _ringDiameter,
                  child: SizedBox(
                    width: _ringDiameter,
                    height: _ringDiameter,
                    child: CustomPaint(
                        painter: WheelPainter(
                          activeBgColor: widget.activeNavItemBgColor,
                          width: _ringWidth,
                        ),
                        child:
                            // _scaleAnimation.value == 1.0 ?
                            Transform.rotate(
                          angle: (2 * pi) *
                              _rotateAnimation.value *
                              _directionX *
                              _directionY,
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: localChild
                                  .asMap()
                                  .map((index, child) => MapEntry(index,
                                      _applyTransformations(child, index)))
                                  .values
                                  .toList(),
                            ),
                          ),
                        )
                        // : Container(),
                        ),
                  ),
                ),
              ),

              SizedBox(
                width: fabSize,
                height: fabSize,
                child: RawMaterialButton(
                  fillColor: _colorAnimation!.value,
                  shape: _fabIconBorder,
                  elevation: 8.0,
                  onPressed: () {
                    if (_isAnimating) return;

                    if (_isOpen) {
                      close();
                    } else {
                      open();
                    }
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: (_scaleAnimation.value == 1.0
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: widget.menuCloseIcon,
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: widget.menuOpenIcon,
                          )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _applyTransformations(MenuNavItem child, int index) {
    double angleFix = 8.0;

    final angle =
        vector.radians(230.0 / (localChild.length - 1) * index + angleFix);

    return Transform(
      transform: Matrix4.translationValues(
          (-(_ringDiameter! / 1.7) * cos(angle) +
                  (_ringWidth! / 1.7 * cos(angle))) *
              _directionX,
          (-(_ringDiameter! / 1.7) * sin(angle) +
                  (_ringWidth! / 1.7 * sin(angle))) *
              _directionY,
          0.0),
      alignment: FractionalOffset.centerLeft,
      child: InkWell(
          onTap: () async {
            child.onTap();
            _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0)
                .animate(_scaleCurve as Animation<double>)
              ..addListener(() {
                setState(() {});
              });
            await _animationController2.reverse(from: 0.2);
            reArrangeItems(index: index);
            _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
                .animate(_scaleCurve as Animation<double>)
              ..addListener(() {
                setState(() {});
              });
          },
          child: Icon(
            child.icon,
            color: widget.menuNavItemsIconColor,
            size: 24.0,
          )),
    );
  }

  void _calculateProps() {
    _menuOpenColor = widget.menuBgColor ?? Theme.of(context).primaryColor;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _ringDiameter = 300.0;
    _ringWidth = ringWidth;
    _marginH = (fabMargin.right + fabMargin.left) / 2;
    _marginV = (fabMargin.top + fabMargin.bottom) / 2;
    _directionX = menuAlignment.x == 0 ? 1 : 1 * menuAlignment.x.sign;
    _directionY = menuAlignment.y == 0 ? 1 : 1 * menuAlignment.y.sign;
    _translationX = ((_screenWidth - fabSize) / 2 - _marginH) * menuAlignment.x;
    _translationY =
        ((_screenHeight - fabSize) / 2 - _marginV) * menuAlignment.y;

    if (_colorAnimation == null || !kReleaseMode) {
      _colorCurve = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.4,
            curve: animationCurve,
          ));
      _colorAnimation = ColorTween(begin: _menuOpenColor, end: _menuOpenColor)
          .animate(_colorCurve as Animation<double>)
        ..addListener(() {
          setState(() {});
        });
    }
  }

  void open() {
    _isAnimating = true;
    _animationController.forward().then((_) {
      _isAnimating = false;
      _isOpen = true;
    });
  }

  void close() {
    _isAnimating = true;
    _animationController.reverse().then((_) {
      _isAnimating = false;
      _isOpen = false;
    });
  }

  void reArrangeItems({required int index}) {
    List<MenuNavItem> tempList = [];
    tempList.add(localChild.elementAt(index));
    for (var i = index + 1; i < localChild.length; i++) {
      if (i != index) {
        tempList.add(localChild.elementAt(i));
      }
    }
    for (var i = 0; i <= index; i++) {
      if (i != index) {
        tempList.add(localChild.elementAt(i));
      }
    }
    setState(() {
      localChild = tempList;
    });
  }

  bool get isOpen => _isOpen;
}

class WheelPainter extends CustomPainter {
  final double? width;
  final Color activeBgColor;

  WheelPainter({required this.width, required this.activeBgColor});
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
    double wheelSize = 174;
    double radius = 0.58;

    for (var i = 0; i < 3; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, pi + (radius * i), radius),
          getColoredPaint(i == 1
              ? blackColor2
              : i == 2
                  ? greyBgColor
                  : activeBgColor));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
