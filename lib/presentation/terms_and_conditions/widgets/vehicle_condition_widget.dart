import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleConditionWidget extends StatefulWidget {
  final Map<String, bool> conditionStates;
  final ValueChanged<Map<String, bool>> onConditionsChanged;

  const VehicleConditionWidget({
    Key? key,
    required this.conditionStates,
    required this.onConditionsChanged,
  }) : super(key: key);

  @override
  State<VehicleConditionWidget> createState() => _VehicleConditionWidgetState();
}

class _VehicleConditionWidgetState extends State<VehicleConditionWidget> {
  late Map<String, bool> _conditions;
  final Map<String, bool> _expandedStates = {};

  final List<Map<String, dynamic>> _conditionItems = [
    {
      'key': 'cleaning_charges',
      'title': 'Cleaning Charges',
      'description':
          'Customer acknowledges responsibility for cleaning charges if vehicle is returned in unclean condition',
      'details':
          'Interior cleaning: ₹500\nExterior wash: ₹300\nDeep cleaning (smoking/pets): ₹2000\nStain removal: ₹1000',
      'icon': 'local_car_wash',
      'color': Color(0xFF2196F3),
    },
    {
      'key': 'spare_parts',
      'title': 'Spare Parts Responsibility',
      'description':
          'Customer is liable for any missing or damaged spare parts and accessories',
      'details':
          'Spare tire: ₹8000\nJack and tools: ₹2000\nFirst aid kit: ₹500\nFire extinguisher: ₹1500\nReflector triangles: ₹300',
      'icon': 'build',
      'color': Color(0xFFFF9800),
    },
    {
      'key': 'damage_acknowledgment',
      'title': 'Damage Acknowledgment',
      'description':
          'Customer accepts full responsibility for any damage caused during rental period',
      'details':
          'Minor scratches: ₹2000-5000\nDents: ₹5000-15000\nBroken lights: ₹3000-8000\nInterior damage: ₹2000-10000\nMajor accidents: As per insurance assessment',
      'icon': 'warning',
      'color': Color(0xFFF44336),
    },
    {
      'key': 'fuel_policy',
      'title': 'Fuel Policy Agreement',
      'description':
          'Vehicle must be returned with same fuel level as provided at pickup',
      'details':
          'Fuel shortage penalty: ₹100 per liter\nRefueling service charge: ₹500\nFuel type mismatch penalty: ₹5000\nEmpty tank return: ₹2000 + fuel cost',
      'icon': 'local_gas_station',
      'color': Color(0xFF4CAF50),
    },
  ];

  @override
  void initState() {
    super.initState();
    _conditions = Map.from(widget.conditionStates);
    for (var item in _conditionItems) {
      _expandedStates[item['key']] = false;
    }
  }

  void _updateCondition(String key, bool value) {
    setState(() {
      _conditions[key] = value;
    });
    widget.onConditionsChanged(_conditions);
  }

  void _toggleExpanded(String key) {
    setState(() {
      _expandedStates[key] = !(_expandedStates[key] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'fact_check',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Vehicle Condition Acknowledgment',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Condition items
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            itemCount: _conditionItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final item = _conditionItems[index];
              final key = item['key'] as String;
              final isExpanded = _expandedStates[key] ?? false;
              final isAccepted = _conditions[key] ?? false;

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAccepted
                        ? (item['color'] as Color).withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Main condition row
                    InkWell(
                      onTap: () => _toggleExpanded(key),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: (item['color'] as Color)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: item['icon'],
                                color: item['color'],
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 3.w),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    item['description'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      height: 1.3,
                                    ),
                                    maxLines: isExpanded ? null : 2,
                                    overflow: isExpanded
                                        ? null
                                        : TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Expand/collapse button
                            CustomIconWidget(
                              iconName:
                                  isExpanded ? 'expand_less' : 'expand_more',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded details
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              height: 1,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Penalty Details:',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              item['details'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Acceptance checkbox
                    Container(
                      padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAccepted,
                            onChanged: (value) =>
                                _updateCondition(key, value ?? false),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _updateCondition(key, !isAccepted),
                              child: Text(
                                'I acknowledge and accept responsibility for ${item['title'].toLowerCase()}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  fontWeight: isAccepted
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
