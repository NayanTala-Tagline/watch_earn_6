import 'package:flutter/material.dart';

class GameEntry {
  final String title;
  final int reward;
  final List<Color> gradientColors;
  final Widget? icon;

  const GameEntry({
    required this.title,
    required this.reward,
    required this.gradientColors,
    this.icon,
  });
}
