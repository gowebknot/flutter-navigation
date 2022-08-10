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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.title),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: EasyNavigationMenu(
          navItems: [
            NavButton(onTap: () {}, icon: LineIcons.amazonWebServicesAws),
            NavButton(onTap: () {}, icon: LineIcons.fire),
            NavButton(onTap: () {}, icon: LineIcons.meteor),
            NavButton(onTap: () {}, icon: LineIcons.futbol),
            NavButton(onTap: () {}, icon: LineIcons.areaChart),
            NavButton(onTap: () {}, icon: LineIcons.lifeRing),
            NavButton(onTap: () {}, icon: LineIcons.paperPlane),
            NavButton(onTap: () {}, icon: LineIcons.moon),
          ],
        ));
  }
}
