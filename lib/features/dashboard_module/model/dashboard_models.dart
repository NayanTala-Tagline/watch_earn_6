import 'dart:ui';

import 'package:daily_cash/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';

/// Model for a daily mission task
class DailyQuest {
  final String title;
  final bool isCompleted;

  const DailyQuest({required this.title, this.isCompleted = false});
}

/// Model for an earn reward item (Quiz, Games, Scratch, Spin)
class EarnPrizeItem {
  final String title;
  final String subtitle;
  final int reward;
  final SvgGenImage icon;

  const EarnPrizeItem({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
  });
}

/// Model for a top earning opportunity (Invite Friends, Web Visits)
class TopEarnerItem {
  final String title;
  final String subtitle;
  final int reward;
  final SvgGenImage icon;
  final Color color;
  final List<Color> colors;
  final VoidCallback onTap;

  const TopEarnerItem({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
    required this.color,
    required this.colors,
    required this.onTap,
  });
}
