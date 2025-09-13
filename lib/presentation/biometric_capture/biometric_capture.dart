import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ar_fingerprint_widget.dart';
import './widgets/biometric_capture_widget.dart';
import './widgets/privacy_disclosure_widget.dart';
import './widgets/progress_indicator_widget.dart';

class BiometricCapture extends StatefulWidget {
  const BiometricCapture({Key? key}) : super(key: key);

  @override
  State<BiometricCapture> createState() => _BiometricCaptureState();
}

class _BiometricCaptureState extends State<BiometricCapture> {
  bool _isConsentGiven = false;
  bool _biometricCaptured = false;
  bool _deviceSensorAvailable = true;
  bool _showArScanning = false;
  String _captureMethod = 'device_sensor';

  final List<Map<String, dynamic>> _mockBiometricData = [
    {
      "id": 1,
      "method": "device_sensor",
      "quality": "Excellent",
      "timestamp": "2025-09-13 03:32:33",
      "encrypted_data": "***ENCRYPTED_BIOMETRIC_DATA***",
      "device_info": "TouchID - iPhone 14 Pro",
    },
    {
      "id": 2,
      "method": "ar_scanning",
      "quality": "Good",
      "timestamp": "2025-09-13 03:32:33",
      "encrypted_data": "***ENCRYPTED_FINGERPRINT_SCAN***",
      "device_info": "Camera-based AR scanning",
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkDeviceSensorAvailability();
  }

  Future<void> _checkDeviceSensorAvailability() async {
    // Simulate device sensor availability check
    await Future.delayed(const Duration(milliseconds: 500));

    // For demo purposes, randomly determine availability
    final available = DateTime.now().millisecond % 2 == 0;

    setState(() {
      _deviceSensorAvailable = available;
      if (!available) {
        _showArScanning = true;
        _captureMethod = 'ar_scanning';
      }
    });
  }

  void _onBiometricSuccess() {
    setState(() {
      _biometricCaptured = true;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Biometric data captured successfully'),
        backgroundColor: AppTheme.getAccentColor(),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _onBiometricFailed() {
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Biometric capture failed. Please try again.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _switchToArScanning() {
    setState(() {
      _showArScanning = true;
      _captureMethod = 'ar_scanning';
    });
  }

  void _switchToDeviceSensor() {
    setState(() {
      _showArScanning = false;
      _captureMethod = 'device_sensor';
    });
  }

  bool get _canContinue => _isConsentGiven && _biometricCaptured;

  void _navigateToNext() {
    if (_canContinue) {
      Navigator.pushNamed(context, '/terms-and-conditions');
    }
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            ProgressIndicatorWidget(
              currentStep: 5,
              totalSteps: 12,
              stepTitle: 'Biometric Verification',
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Header section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'security',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 8.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  'Secure Biometric Authentication',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Complete your rental agreement with secure biometric verification. Your data is encrypted and stored locally on your device.',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Privacy disclosure
                    PrivacyDisclosureWidget(
                      isConsentGiven: _isConsentGiven,
                      onConsentChanged: (value) {
                        setState(() {
                          _isConsentGiven = value;
                        });
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Method selection
                    if (_deviceSensorAvailable && !_showArScanning) ...[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'Device biometric sensor detected. Using secure hardware authentication.',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _switchToArScanning,
                              child: Text('Use Camera'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    if (!_deviceSensorAvailable || _showArScanning) ...[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.getWarningColor(true)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.getWarningColor(true)
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.getWarningColor(true),
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _deviceSensorAvailable
                                    ? 'Using camera-based AR fingerprint scanning.'
                                    : 'Device sensor unavailable. Using camera-based scanning.',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.getWarningColor(true),
                                ),
                              ),
                            ),
                            if (_deviceSensorAvailable)
                              TextButton(
                                onPressed: _switchToDeviceSensor,
                                child: Text('Use Sensor'),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Biometric capture section
                    if (!_showArScanning)
                      BiometricCaptureWidget(
                        onBiometricSuccess: _onBiometricSuccess,
                        onBiometricFailed: _onBiometricFailed,
                      )
                    else
                      ArFingerprintWidget(
                        onCaptureSuccess: _onBiometricSuccess,
                        onCaptureFailed: _onBiometricFailed,
                      ),

                    SizedBox(height: 2.h),

                    // Alternative verification section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'accessibility',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  'Alternative Verification',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'If you\'re unable to provide biometric data due to physical limitations, alternative verification methods are available. Contact support for assistance.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Alternative verification options will be available in the full version'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text('Request Alternative Method'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed bottom navigation
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _navigateBack,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text('Back'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _canContinue ? _navigateToNext : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: _canContinue
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: _canContinue
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: _canContinue
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
