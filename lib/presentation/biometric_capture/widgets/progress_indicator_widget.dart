import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stepTitle,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$currentStep/$totalSteps',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Progress bar
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary,
                      AppTheme.lightTheme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Step indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.getAccentColor()
                      : isCurrent
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 4.w,
                        )
                      : Text(
                          '$stepNumber',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isCurrent
                                ? Colors.white
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
