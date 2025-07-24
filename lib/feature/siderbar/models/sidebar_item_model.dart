import 'package:flutter/material.dart';

class SidebarItemModel {
  final String label;
  final String route;
  final IconData? icon;

  SidebarItemModel({
    required this.label,
    required this.route,
    this.icon,
  });
}
