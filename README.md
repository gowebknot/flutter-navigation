<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

![demo alt](https://raw.githubusercontent.com/gowebknot/flutter-navigation/sai/demo.jpg?token=GHSAT0AAAAAABVOHJ6DWEATRDSI5C457MBEYXTTDSQ)
TODO: List what your package can do. Maybe include images, gifs, or videos.

## Usage

Example can be found in `/demo` folder.

```dart
Scaffold(
        backgroundColor: Colors.grey[200],
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
```
