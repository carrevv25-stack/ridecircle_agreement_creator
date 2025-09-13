import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FuelLevelWidget extends StatefulWidget {
  final double? fuelLevel;
  final Function(double) onFuelLevelChanged;

  const FuelLevelWidget({
    Key? key,
    this.fuelLevel,
    required this.onFuelLevelChanged,
  }) : super(key: key);

  @override
  State<FuelLevelWidget> createState() => _FuelLevelWidgetState();
}

class _FuelLevelWidgetState extends State<FuelLevelWidget> {
  late double _currentFuelLevel;

  @override
  void initState() {
    super.initState();
    _currentFuelLevel = widget.fuelLevel ?? 50.0;
  }

  Color _getFuelLevelColor(double level) {
    if (level <= 25) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (level <= 50) {
      return Color(0xFFFF9800); // Orange
    } else {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
  }

  String _getFuelLevelText(double level) {
    if (level <= 25) {
      return 'Low';
    } else if (level <= 50) {
      return 'Medium';
    } else if (level <= 75) {
      return 'Good';
    } else {
      return 'Full';
    }
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
                iconName: 'local_gas_station',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Fuel Level',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Fuel Gauge Visual
          Container(
            height: 12.h,
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Level',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${_currentFuelLevel.round()}%',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: _getFuelLevelColor(_currentFuelLevel),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getFuelLevelColor(_currentFuelLevel)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getFuelLevelText(_currentFuelLevel),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getFuelLevelColor(_currentFuelLevel),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Visual Fuel Gauge
                Container(
                  height: 3.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: (_currentFuelLevel / 100) *
                            100.w *
                            0.8, // Adjust based on container width
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getFuelLevelColor(_currentFuelLevel)
                                  .withValues(alpha: 0.7),
                              _getFuelLevelColor(_currentFuelLevel),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        right: 2.w,
                        top: 0,
                        bottom: 0,
                        child: CustomIconWidget(
                          iconName: 'local_gas_station',
                          color: _currentFuelLevel > 80
                              ? AppTheme.lightTheme.colorScheme.surface
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Fuel Level Slider
          Text(
            'Adjust Fuel Level *',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getFuelLevelColor(_currentFuelLevel),
              inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              thumbColor: _getFuelLevelColor(_currentFuelLevel),
              overlayColor:
                  _getFuelLevelColor(_currentFuelLevel).withValues(alpha: 0.2),
              valueIndicatorColor: _getFuelLevelColor(_currentFuelLevel),
              valueIndicatorTextStyle:
                  AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
              trackHeight: 1.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _currentFuelLevel,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${_currentFuelLevel.round()}%',
              onChanged: (value) {
                setState(() {
                  _currentFuelLevel = value;
                });
                widget.onFuelLevelChanged(value);
              },
            ),
          ),

          // Quick Select Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickSelectButton('Empty', 0),
              _buildQuickSelectButton('1/4', 25),
              _buildQuickSelectButton('1/2', 50),
              _buildQuickSelectButton('3/4', 75),
              _buildQuickSelectButton('Full', 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSelectButton(String label, double value) {
    final isSelected = _currentFuelLevel == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFuelLevel = value;
        });
        widget.onFuelLevelChanged(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
