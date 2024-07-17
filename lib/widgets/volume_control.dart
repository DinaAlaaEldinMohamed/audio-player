import 'package:flutter/material.dart';

class VolumeControl extends StatelessWidget {
    final double volume;
  final Function(double) onChange;

  const VolumeControl({required this.volume,required this.onChange, super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}