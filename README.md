![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&color=blue)

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

# Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

> This Package provides three different types of animated navs.

1. Center Float Menu - `CenterFloatAnimatedNav`
2. Center Docked Menu - `CenterDockedAnimatedNav`
3. End Docked Menu - `EndDockedAnimatedNav`

# Installation

Add `navigation_panel: <latest_version>` in your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:menu_button/navigation_panel.dart';
```

# Usage

Example can be found in `/demo` folder.

## Simple Implementation

### `1. CenterDockedAnimatedNav`

> 💡 You can have max upto 5 nav items for this menu

```dart
Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: CenterDockedAnimatedNav(navItems: [
                MenuNavItem(onTap: () {}, icon: LineIcons.amazonWebServicesAws),
                MenuNavItem(onTap: () {}, icon: LineIcons.fire),
                MenuNavItem(onTap: () {}, icon: LineIcons.meteor),
                MenuNavItem(onTap: () {}, icon: LineIcons.futbol),
                MenuNavItem(onTap: () {}, icon: LineIcons.swimmer),
              ],)
        );
```

## Customization

| Parameter                | Description                                                                  |
| ------------------------ | ---------------------------------------------------------------------------- |
| `activeNavItemBgColor`   | This parameter can be used to apply Background Color to the active Nav Item. |
| `activeNavItemIconColor` | Active Nav Item Icon Color Parameter                                         |
| `menuIconColor`          | To apply color to the Menu Icon                                              |
| `navItemIconColor`       | Inactive Nav Items Icon Color                                                |
| `backgroundColor`        | Docked Menu Background Color                                                 |

### `2. CenterFloatAnimatedNav`

```dart
Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: CenterFloatAnimatedNav(
                    navItems: [
                      MenuNavItem(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          icon: LineIcons.amazonWebServicesAws),
                      MenuNavItem(onTap: () {}, icon: LineIcons.fire),
                      MenuNavItem(onTap: () {}, icon: LineIcons.meteor),
                      MenuNavItem(onTap: () {}, icon: LineIcons.futbol),
                      MenuNavItem(onTap: () {}, icon: LineIcons.areaChart),
                      MenuNavItem(onTap: () {}, icon: LineIcons.lifeRing),
                      MenuNavItem(onTap: () {}, icon: LineIcons.paperPlane),
                      MenuNavItem(onTap: () {}, icon: LineIcons.moon),
                    ],
                  )
        );
```

### `3. EndDockedAnimatedNav`

```dart
Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: EndDockedAnimatedNav(navItems: [
                    MenuNavItem(onTap: () {}, icon: LineIcons.amazonWebServicesAws),
                    MenuNavItem(onTap: () {}, icon: LineIcons.fire),
                    MenuNavItem(onTap: () {}, icon: LineIcons.meteor),
                    MenuNavItem(onTap: () {}, icon: LineIcons.futbol),
                    MenuNavItem(onTap: () {}, icon: LineIcons.swimmer),
                  ])
        );
```
