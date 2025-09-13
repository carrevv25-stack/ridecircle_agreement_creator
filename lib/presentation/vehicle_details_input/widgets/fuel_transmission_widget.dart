import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FuelTransmissionWidget extends StatefulWidget {
  final String? selectedFuelType;
  final String? selectedTransmissionType;
  final Function(String?) onFuelTypeChanged;
  final Function(String?) onTransmissionTypeChanged;

  const FuelTransmissionWidget({
    Key? key,
    this.selectedFuelType,
    this.selectedTransmissionType,
    required this.onFuelTypeChanged,
    required this.onTransmissionTypeChanged,
  }) : super(key: key);

  @override
  State<FuelTransmissionWidget> createState() => _FuelTransmissionWidgetState();
}

class _FuelTransmissionWidgetState extends State<FuelTransmissionWidget> {
  final List<Map<String, dynamic>> fuelTypes = [
    {
      'value': 'Petrol',
      'icon': 'local_gas_station',
      'color': Color(0xFF4CAF50)
    },
    {
      'value': 'Diesel',
      'icon': 'local_gas_station',
      'color': Color(0xFF2196F3)
    },
    {'value': 'CNG', 'icon': 'eco', 'color': Color(0xFF8BC34A)},
    {'value': 'Electric', 'icon': 'electric_bolt', 'color': Color(0xFFFF9800)},
    {'value': 'Other', 'icon': 'more_horiz', 'color': Color(0xFF9E9E9E)},
  ];

  final List<Map<String, dynamic>> transmissionTypes = [
    {'value': 'Manual', 'icon': 'settings', 'color': Color(0xFF3F51B5)},
    {'value': 'Automatic', 'icon': 'autorenew', 'color': Color(0xFF9C27B0)},
  ];

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
                iconName: 'build',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Fuel & Transmission',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Fuel Type Section
          Text(
            'Fuel Type *',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: fuelTypes.map((fuelType) {
                final isSelected = widget.selectedFuelType == fuelType['value'];
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: GestureDetector(
                    onTap: () => widget.onFuelTypeChanged(fuelType['value']),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: fuelType['icon'],
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : fuelType['color'],
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            fuelType['value'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 3.h),

          // Transmission Type Section
          Text(
            'Transmission Type *',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: transmissionTypes.map((transmissionType) {
              final isSelected =
                  widget.selectedTransmissionType == transmissionType['value'];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right:
                          transmissionType == transmissionTypes.last ? 0 : 2.w),
                  child: GestureDetector(
                    onTap: () => widget
                        .onTransmissionTypeChanged(transmissionType['value']),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: transmissionType['icon'],
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : transmissionType['color'],
                            size: 24,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            transmissionType['value'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
