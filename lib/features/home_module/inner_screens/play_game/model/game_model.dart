import 'package:flutter/material.dart';

class GameItem {
  final String title;
  final int reward;
  final List<Color> gradientColors;
  final Widget? icon;

  const GameItem({
    required this.title,
    required this.reward,
    required this.gradientColors,
    this.icon,
  });
}
