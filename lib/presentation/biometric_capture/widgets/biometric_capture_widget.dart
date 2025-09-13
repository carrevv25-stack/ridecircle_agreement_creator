import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricCaptureWidget extends StatefulWidget {
  final VoidCallback? onBiometricSuccess;
  final VoidCallback? onBiometricFailed;

  const BiometricCaptureWidget({
    Key? key,
    this.onBiometricSuccess,
    this.onBiometricFailed,
  }) : super(key: key);

  @override
  State<BiometricCaptureWidget> createState() => _BiometricCaptureWidgetState();
}

class _BiometricCaptureWidgetState extends State<BiometricCaptureWidget>
    with TickerProviderStateMixin {
  bool _isCapturing = false;
  bool _captureSuccess = false;
  bool _captureFailed = false;
  String _biometricQuality = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startBiometricCapture() async {
    setState(() {
      _isCapturing = true;
      _captureSuccess = false;
      _captureFailed = false;
      _biometricQuality = '';
    });

    try {
      // Simulate biometric capture process
      await Future.delayed(const Duration(seconds: 3));

      // Simulate success/failure randomly for demo
      final success = DateTime.now().millisecond % 2 == 0;

      if (success) {
        setState(() {
          _captureSuccess = true;
          _biometricQuality = 'Excellent';
        });

        // Haptic feedback for success
        HapticFeedback.lightImpact();
        widget.onBiometricSuccess?.call();
      } else {
        setState(() {
          _captureFailed = true;
          _biometricQuality = 'Poor - Please retry';
        });

        // Haptic feedback for failure
        HapticFeedback.heavyImpact();
        widget.onBiometricFailed?.call();
      }
    } catch (e) {
      setState(() {
        _captureFailed = true;
        _biometricQuality = 'Capture failed';
      });
      widget.onBiometricFailed?.call();
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _retryCapture() {
    setState(() {
      _captureSuccess = false;
      _captureFailed = false;
      _biometricQuality = '';
    });
  }

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
          color: _captureSuccess
              ? AppTheme.getAccentColor()
              : _captureFailed
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
          width: 1.5,
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
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Biometric Authentication',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Biometric capture area
          Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isCapturing
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!_isCapturing && !_captureSuccess && !_captureFailed) ...[
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: CustomIconWidget(
                          iconName: 'fingerprint',
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.6),
                          size: 20.w,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 4.h,
                    child: Text(
                      'Place your finger here',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
                if (_isCapturing) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15.w,
                        height: 15.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Capturing biometric data...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (_captureSuccess) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: AppTheme.getAccentColor(),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 8.w,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Biometric captured successfully',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getAccentColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (_captureFailed) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: Colors.white,
                          size: 8.w,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Capture failed - Please try again',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Quality indicator
          if (_biometricQuality.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _captureSuccess
                    ? AppTheme.getAccentColor().withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _captureSuccess ? 'verified' : 'warning',
                    color: _captureSuccess
                        ? AppTheme.getAccentColor()
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Quality: $_biometricQuality',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _captureSuccess
                          ? AppTheme.getAccentColor()
                          : AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Action buttons
          Row(
            children: [
              if (_captureFailed) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _retryCapture,
                    child: Text('Retry'),
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: _isCapturing
                      ? null
                      : (_captureSuccess || _captureFailed)
                          ? null
                          : _startBiometricCapture,
                  child: Text(
                    _isCapturing
                        ? 'Capturing...'
                        : _captureSuccess
                            ? 'Captured'
                            : 'Start Capture',
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
