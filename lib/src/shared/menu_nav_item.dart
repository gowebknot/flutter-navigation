import 'package:flutter/material.dart';

class MenuNavItem {
  VoidCallback onTap;
  IconData icon;
  MenuNavItem({
    required this.onTap,
    required this.icon,
  });
}
