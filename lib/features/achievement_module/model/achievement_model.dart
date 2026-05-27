import 'package:flutter/material.dart';

class AchievementItem {
  final String title;
  final String description;
  final int reward;
  final bool isLocked;
  final Widget icon;

  const AchievementItem({
    required this.title,
    required this.description,
    required this.reward,
    this.isLocked = true,
    required this.icon,
  });
}
