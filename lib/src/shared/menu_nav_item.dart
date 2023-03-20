/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/
import 'package:flutter/material.dart';

/// class [MenuNavItem]
///
/// Each object of [MenuNavItem] represents one Menu Icon
class MenuNavItem {
  final VoidCallback onTap;
  final IconData icon;
  const MenuNavItem({
    required this.onTap,
    required this.icon,
  });
}
