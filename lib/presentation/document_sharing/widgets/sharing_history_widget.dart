import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SharingHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sharingHistory;

  const SharingHistoryWidget({
    Key? key,
    required this.sharingHistory,
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
            'Sharing History',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          sharingHistory.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      sharingHistory.length > 3 ? 3 : sharingHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final history = sharingHistory[index];
                    return _buildHistoryItem(
                      method: history['method'] as String,
                      recipient: history['recipient'] as String,
                      timestamp: history['timestamp'] as String,
                      status: history['status'] as String,
                    );
                  },
                ),
          if (sharingHistory.length > 3) ...[
            SizedBox(height: 1.h),
            TextButton(
              onPressed: () {
                // Show full history
              },
              child: Text(
                'View All (${sharingHistory.length})',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'share',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'No sharing history yet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String method,
    required String recipient,
    required String timestamp,
    required String status,
  }) {
    final Color statusColor = status == 'delivered'
        ? AppTheme.lightTheme.colorScheme.tertiary
        : status == 'pending'
            ? AppTheme.lightTheme.colorScheme.secondary
            : AppTheme.lightTheme.colorScheme.error;

    final String statusIcon = status == 'delivered'
        ? 'check_circle'
        : status == 'pending'
            ? 'schedule'
            : 'error';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: _getMethodIcon(method),
              color: statusColor,
              size: 4.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$method to $recipient',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  timestamp,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: statusIcon,
            color: statusColor,
            size: 4.w,
          ),
        ],
      ),
    );
  }

  String _getMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'email':
        return 'email';
      case 'whatsapp':
        return 'message';
      case 'cloud':
        return 'cloud_upload';
      case 'print':
        return 'print';
      default:
        return 'share';
    }
  }
}
