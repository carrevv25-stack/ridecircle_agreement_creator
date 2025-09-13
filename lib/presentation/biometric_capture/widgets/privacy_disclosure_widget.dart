import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyDisclosureWidget extends StatefulWidget {
  final bool isConsentGiven;
  final ValueChanged<bool> onConsentChanged;

  const PrivacyDisclosureWidget({
    Key? key,
    required this.isConsentGiven,
    required this.onConsentChanged,
  }) : super(key: key);

  @override
  State<PrivacyDisclosureWidget> createState() =>
      _PrivacyDisclosureWidgetState();
}

class _PrivacyDisclosureWidgetState extends State<PrivacyDisclosureWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Biometric Data Privacy',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Your biometric data is encrypted and stored securely on your device. It will only be used for this rental agreement verification.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  'View Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '''• Biometric data is processed locally on your device
• No biometric information is transmitted to external servers
• Data is encrypted using device security features
• You can request deletion of biometric data at any time
• This data is used solely for rental agreement verification
• We comply with applicable data protection regulations''',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
          SizedBox(height: 3.h),
          Row(
            children: [
              Checkbox(
                value: widget.isConsentGiven,
                onChanged: (value) {
                  widget.onConsentChanged(value ?? false);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                checkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'I consent to the collection and processing of my biometric data for rental agreement verification',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
