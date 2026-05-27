import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/gradient_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DailyQuestsSection extends StatelessWidget {
  const DailyQuestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final missions = provider.missions;
        final total = provider.totalMissions;
        final completed = provider.completedMissions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Missions',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp20,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: AppDimens.h12),
            GradientPanel(
              padding: EdgeInsets.all(AppDimens.w16),
              border: Border.all(
                color: context.themeColors.secondaryGradient2.withValues(alpha: 0.5)
              ),
              child: Column(
                children: [
                  // Mission Progress Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$completed/$total ',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.themeTextColors.textColor,
                                fontSize: AppDimens.sp16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            TextSpan(
                              text: 'Tasks Completed',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.themeTextColors.descriptionColor,
                                fontSize: AppDimens.sp16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                      ),
                      // View Guide Button
                      GestureDetector(
                        onTap: provider.onViewGuide,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: AppDimens.w12, vertical: AppDimens.h6),
                          decoration: BoxDecoration(
                            gradient: context.themeColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppDimens.r20),
                          ),
                          child: Text(
                            'View Guide',
                            strutStyle: StrutStyle(
                              fontSize: AppDimens.sp15,
                              height: 1.1,
                              forceStrutHeight: true,
                            ),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppDimens.sp14,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimens.h12),
                  const Divider(color: Colors.white10),
                  SizedBox(height: AppDimens.h12),
                  // List of Missions
                  ...missions.map((mission) => _QuestItem(mission: mission)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuestItem extends StatelessWidget {
  final DailyQuest mission;

  const _QuestItem({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.h12),
      child: Row(
        children: [
          // Icon(
          //   mission.isCompleted ? Icons.check_circle : Icons.circle_outlined,
          //   color: mission.isCompleted ? context.themeColors.secondaryGradient2 : context.themeTextColors.descriptionColor,
          //   size: AppDimens.r18,
          // ),
          Icon(
            mission.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: mission.isCompleted ? context.themeColors.secondaryGradient2 : context.themeTextColors.descriptionColor,
            size: AppDimens.r18,
          ),
          SizedBox(width: AppDimens.w12),
          Text(
            mission.title,
            strutStyle: StrutStyle(
              fontSize: AppDimens.sp15,
              height: 1.1,
              forceStrutHeight: true,
            ),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
