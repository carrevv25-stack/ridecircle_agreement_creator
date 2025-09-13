import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FastagWidget extends StatefulWidget {
  final bool hasFastag;
  final String? fastagNumber;
  final Function(bool) onFastagToggle;
  final Function(String?) onFastagNumberChanged;

  const FastagWidget({
    Key? key,
    required this.hasFastag,
    this.fastagNumber,
    required this.onFastagToggle,
    required this.onFastagNumberChanged,
  }) : super(key: key);

  @override
  State<FastagWidget> createState() => _FastagWidgetState();
}

class _FastagWidgetState extends State<FastagWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fastagNumber);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                iconName: 'toll',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'FASTag Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // FASTag Toggle
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle has FASTag',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Enable if vehicle has an active FASTag',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.hasFastag,
                  onChanged: (value) {
                    widget.onFastagToggle(value);
                    if (!value) {
                      _controller.clear();
                      widget.onFastagNumberChanged(null);
                    }
                  },
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  activeTrackColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  inactiveThumbColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ],
            ),
          ),

          // FASTag Number Input (shown only when toggle is enabled)
          if (widget.hasFastag) ...[
            SizedBox(height: 3.h),
            Text(
              'FASTag Number (Optional)',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _controller,
              onChanged: widget.onFastagNumberChanged,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: InputDecoration(
                hintText: 'Enter FASTag number',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.7),
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'credit_card',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'FASTag number helps in toll payment tracking and vehicle identification',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
