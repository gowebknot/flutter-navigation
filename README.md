TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Usage

Example can be found in `/demo` folder.

```dart
Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: EasyNavigationMenu(
                navItems: [
                  MenuNavItem(onTap: () {}, icon: LineIcons.amazonWebServicesAws),
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
