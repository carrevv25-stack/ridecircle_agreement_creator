import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleYearWidget extends StatefulWidget {
  final int? selectedYear;
  final Function(int?) onYearChanged;

  const VehicleYearWidget({
    Key? key,
    this.selectedYear,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  State<VehicleYearWidget> createState() => _VehicleYearWidgetState();
}

class _VehicleYearWidgetState extends State<VehicleYearWidget> {
  List<int> get availableYears {
    final currentYear = DateTime.now().year;
    final years = <int>[];
    for (int year = currentYear; year >= 1990; year--) {
      years.add(year);
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Manufacturing Year',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Year *',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () => _showYearPicker(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedYear?.toString() ?? 'Select Year',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: widget.selectedYear != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: 50.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Manufacturing Year',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  itemCount: availableYears.length,
                  itemBuilder: (context, index) {
                    final year = availableYears[index];
                    final isSelected = widget.selectedYear == year;

                    return ListTile(
                      title: Text(
                        year.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        widget.onYearChanged(year);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
