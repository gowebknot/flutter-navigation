import 'package:flutter/material.dart';
import 'package:easy_nav/easy_nav.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Nav',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

enum AnimatedNavs { centerFloat, centerDocked, endDocked }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool toggle = false;
  AnimatedNavs? _navs = AnimatedNavs.centerDocked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Center Float'),
              leading: Radio<AnimatedNavs>(
                value: AnimatedNavs.centerFloat,
                groupValue: _navs,
                onChanged: (AnimatedNavs? value) {
                  setState(() {
                    _navs = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Center Docked'),
              leading: Radio<AnimatedNavs>(
                value: AnimatedNavs.centerDocked,
                groupValue: _navs,
                onChanged: (AnimatedNavs? value) {
                  setState(() {
                    _navs = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('End Docked'),
              leading: Radio<AnimatedNavs>(
                value: AnimatedNavs.endDocked,
                groupValue: _navs,
                onChanged: (AnimatedNavs? value) {
                  setState(() {
                    _navs = value;
                  });
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _navs == AnimatedNavs.centerDocked
            ? BottomAnimatedNav(navItems: [
                MenuNavItem(onTap: () {}, icon: LineIcons.amazonWebServicesAws),
                MenuNavItem(onTap: () {}, icon: LineIcons.fire),
                MenuNavItem(onTap: () {}, icon: LineIcons.meteor),
                MenuNavItem(onTap: () {}, icon: LineIcons.futbol),
                MenuNavItem(onTap: () {}, icon: LineIcons.swimmer),
              ])
            : EasyNavigationMenu(
                navItems: [
                  MenuNavItem(
                      onTap: () {}, icon: LineIcons.amazonWebServicesAws),
                  MenuNavItem(onTap: () {}, icon: LineIcons.fire),
                  MenuNavItem(onTap: () {}, icon: LineIcons.meteor),
                  MenuNavItem(onTap: () {}, icon: LineIcons.futbol),
                  MenuNavItem(onTap: () {}, icon: LineIcons.areaChart),
                  MenuNavItem(onTap: () {}, icon: LineIcons.lifeRing),
                  MenuNavItem(onTap: () {}, icon: LineIcons.paperPlane),
                  MenuNavItem(onTap: () {}, icon: LineIcons.moon),
                ],
              )
        // floatingActionButton:

        );
  }
}
