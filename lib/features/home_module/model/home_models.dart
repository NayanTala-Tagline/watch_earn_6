import 'dart:ui';

import 'package:daily_cash/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';

/// Model for a daily mission task
class DailyMission {
  final String title;
  final bool isCompleted;

  const DailyMission({required this.title, this.isCompleted = false});
}

/// Model for an earn reward item (Quiz, Games, Scratch, Spin)
class EarnRewardItem {
  final String title;
  final String subtitle;
  final int reward;
  final SvgGenImage icon;

  const EarnRewardItem({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
  });
}

/// Model for a top earning opportunity (Invite Friends, Web Visits)
class TopEarningItem {
  final String title;
  final String subtitle;
  final int reward;
  final SvgGenImage icon;
  final Color color;
  final List<Color> colors;
  final VoidCallback onTap;

  const TopEarningItem({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
    required this.color,
    required this.colors,
    required this.onTap,
  });
}
