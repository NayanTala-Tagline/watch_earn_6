import 'package:daily_cash/features/achievement_module/model/achievement_model.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class AchievementProvider extends ChangeNotifier {
  final List<AchievementItem> achievements = [
    AchievementItem(
      title: 'Quiz Novice',
      description: 'Complete 10 quizzes',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.quizMaster.svg(width: AppSize.w24),
    ),
    AchievementItem(
      title: 'Lucky Spinner',
      description: 'Spin the wheel 50 times',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.spinWheel.svg(width: AppSize.w24),
    ),
    AchievementItem(
      title: 'Social Butterfly',
      description: 'Invite 5 friends',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.referEarn.svg(width: AppSize.w24),
    ),
    AchievementItem(
      title: 'Wealthy',
      description: 'Earn 10,000 coins',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.coins.svg(width: AppSize.w24),
    ),
    AchievementItem(
      title: 'Quiz Master',
      description: 'Complete 100 quizzes',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.quizMaster.svg(width: AppSize.w24),
    ),
  ];
}
