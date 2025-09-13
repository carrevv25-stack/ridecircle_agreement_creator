import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityOptionsWidget extends StatefulWidget {
  final bool passwordProtection;
  final bool watermarking;
  final bool accessLogging;
  final Function(bool)? onPasswordToggle;
  final Function(bool)? onWatermarkToggle;
  final Function(bool)? onLoggingToggle;

  const SecurityOptionsWidget({
    Key? key,
    this.passwordProtection = false,
    this.watermarking = true,
    this.accessLogging = true,
    this.onPasswordToggle,
    this.onWatermarkToggle,
    this.onLoggingToggle,
  }) : super(key: key);

  @override
  State<SecurityOptionsWidget> createState() => _SecurityOptionsWidgetState();
}

class _SecurityOptionsWidgetState extends State<SecurityOptionsWidget> {
  late bool _passwordProtection;
  late bool _watermarking;
  late bool _accessLogging;

  @override
  void initState() {
    super.initState();
    _passwordProtection = widget.passwordProtection;
    _watermarking = widget.watermarking;
    _accessLogging = widget.accessLogging;
  }

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
            'Security Options',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSecurityOption(
            icon: 'lock',
            title: 'Password Protection',
            subtitle: 'Require password to open document',
            value: _passwordProtection,
            onChanged: (value) {
              setState(() => _passwordProtection = value);
              widget.onPasswordToggle?.call(value);
            },
          ),
          SizedBox(height: 1.5.h),
          _buildSecurityOption(
            icon: 'watermark',
            title: 'Watermarking',
            subtitle: 'Add security watermark to pages',
            value: _watermarking,
            onChanged: (value) {
              setState(() => _watermarking = value);
              widget.onWatermarkToggle?.call(value);
            },
          ),
          SizedBox(height: 1.5.h),
          _buildSecurityOption(
            icon: 'history',
            title: 'Access Logging',
            subtitle: 'Track document access and sharing',
            value: _accessLogging,
            onChanged: (value) {
              setState(() => _accessLogging = value);
              widget.onLoggingToggle?.call(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
