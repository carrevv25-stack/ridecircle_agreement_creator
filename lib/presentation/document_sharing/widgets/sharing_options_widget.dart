import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SharingOptionsWidget extends StatelessWidget {
  final VoidCallback? onEmailShare;
  final VoidCallback? onWhatsAppShare;
  final VoidCallback? onCloudShare;
  final VoidCallback? onPrintShare;

  const SharingOptionsWidget({
    Key? key,
    this.onEmailShare,
    this.onWhatsAppShare,
    this.onCloudShare,
    this.onPrintShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share Agreement',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildShareOption(
                  context,
                  icon: 'email',
                  label: 'Email',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: onEmailShare,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildShareOption(
                  context,
                  icon: 'message',
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: onWhatsAppShare,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildShareOption(
                  context,
                  icon: 'cloud_upload',
                  label: 'Cloud',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: onCloudShare,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildShareOption(
                  context,
                  icon: 'print',
                  label: 'Print',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  onTap: onPrintShare,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
