import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrCodeWidget extends StatelessWidget {
  final String qrData;
  final String expirationDate;
  final VoidCallback? onShareQr;

  const QrCodeWidget({
    Key? key,
    required this.qrData,
    required this.expirationDate,
    this.onShareQr,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QR Code Access',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: onShareQr,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text(
                  'Share',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Center(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 15.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'QR Code',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Expires on $expirationDate',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
