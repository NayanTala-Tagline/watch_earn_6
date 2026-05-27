import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DailyMissionsSection extends StatelessWidget {
  const DailyMissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
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
                fontSize: AppSize.sp20,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: AppSize.h12),
            GradientCard(
              padding: EdgeInsets.all(AppSize.w16),
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
                                fontSize: AppSize.sp16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            TextSpan(
                              text: 'Tasks Completed',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.themeTextColors.descriptionColor,
                                fontSize: AppSize.sp16,
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
                          padding: EdgeInsets.symmetric(horizontal: AppSize.w12, vertical: AppSize.h6),
                          decoration: BoxDecoration(
                            gradient: context.themeColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppSize.r20),
                          ),
                          child: Text(
                            'View Guide',
                            strutStyle: StrutStyle(
                              fontSize: AppSize.sp15,
                              height: 1.1,
                              forceStrutHeight: true,
                            ),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppSize.sp14,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.h12),
                  const Divider(color: Colors.white10),
                  SizedBox(height: AppSize.h12),
                  // List of Missions
                  ...missions.map((mission) => _MissionItem(mission: mission)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MissionItem extends StatelessWidget {
  final DailyMission mission;

  const _MissionItem({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.h12),
      child: Row(
        children: [
          // Icon(
          //   mission.isCompleted ? Icons.check_circle : Icons.circle_outlined,
          //   color: mission.isCompleted ? context.themeColors.secondaryGradient2 : context.themeTextColors.descriptionColor,
          //   size: AppSize.r18,
          // ),
          Icon(
            mission.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: mission.isCompleted ? context.themeColors.secondaryGradient2 : context.themeTextColors.descriptionColor,
            size: AppSize.r18,
          ),
          SizedBox(width: AppSize.w12),
          Text(
            mission.title,
            strutStyle: StrutStyle(
              fontSize: AppSize.sp15,
              height: 1.1,
              forceStrutHeight: true,
            ),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppSize.sp16,
              fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
