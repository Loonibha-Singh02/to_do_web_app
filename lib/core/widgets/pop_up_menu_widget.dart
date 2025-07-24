import 'package:flutter/material.dart';

class PopUpMenuWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextStyle? textStyle;
  final List<PopupMenuEntry> items;
  final void Function(dynamic)? onSelected;
  final Offset offset;
  final String? tooltip;
  final Color? color;

  const PopUpMenuWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.items,
    this.iconColor = Colors.black,
    this.textStyle,
    this.onSelected,
    this.offset = const Offset(0, 40),
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: color ?? Colors.white,
      offset: offset,
      tooltip: tooltip,
      onSelected: onSelected,
      itemBuilder: (context) => items,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text, style: textStyle),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      ),
    );
  }
}
