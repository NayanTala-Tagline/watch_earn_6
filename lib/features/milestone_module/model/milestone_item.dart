import 'package:flutter/material.dart';

class MilestoneItem {
  final String title;
  final String description;
  final int reward;
  final bool isLocked;
  final Widget icon;

  const MilestoneItem({
    required this.title,
    required this.description,
    required this.reward,
    this.isLocked = true,
    required this.icon,
  });
}
