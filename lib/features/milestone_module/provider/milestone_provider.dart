import 'package:daily_cash/features/milestone_module/model/milestone_item.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class MilestoneProvider extends ChangeNotifier {
  final List<MilestoneItem> achievements = [
    MilestoneItem(
      title: 'Quiz Novice',
      description: 'Complete 10 quizzes',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.quizChampion.svg(width: AppDimens.w24),
    ),
    MilestoneItem(
      title: 'Lucky Spinner',
      description: 'Spin the wheel 50 times',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.rotatingWheel.svg(width: AppDimens.w24),
    ),
    MilestoneItem(
      title: 'Social Butterfly',
      description: 'Invite 5 friends',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.inviteEarn.svg(width: AppDimens.w24),
    ),
    MilestoneItem(
      title: 'Wealthy',
      description: 'Earn 10,000 coins',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.tokens.svg(width: AppDimens.w24),
    ),
    MilestoneItem(
      title: 'Quiz Master',
      description: 'Complete 100 quizzes',
      reward: 50,
      isLocked: true,
      icon: Assets.icons.quizChampion.svg(width: AppDimens.w24),
    ),
  ];
}
