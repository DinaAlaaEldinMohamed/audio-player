import 'package:flutter/material.dart';

class TabBarTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  const TabBarTitle({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        Text(title),
      ],
    );
  }
}
