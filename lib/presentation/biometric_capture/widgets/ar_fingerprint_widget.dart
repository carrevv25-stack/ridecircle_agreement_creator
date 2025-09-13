import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArFingerprintWidget extends StatefulWidget {
  final VoidCallback? onCaptureSuccess;
  final VoidCallback? onCaptureFailed;

  const ArFingerprintWidget({
    Key? key,
    this.onCaptureSuccess,
    this.onCaptureFailed,
  }) : super(key: key);

  @override
  State<ArFingerprintWidget> createState() => _ArFingerprintWidgetState();
}

class _ArFingerprintWidgetState extends State<ArFingerprintWidget>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _fingerDetected = false;
  String _selectedFinger = 'thumb';
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _overlayAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));
    _overlayController.repeat(reverse: true);
    _initializeCamera();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        _cameraController = CameraController(
          camera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _captureFingerprint() async {
    if (!_isCameraInitialized || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Simulate finger detection and quality assessment
      await Future.delayed(const Duration(seconds: 2));

      final XFile photo = await _cameraController!.takePicture();

      // Simulate quality assessment
      final quality = DateTime.now().millisecond % 3;

      if (quality >= 1) {
        HapticFeedback.lightImpact();
        widget.onCaptureSuccess?.call();
      } else {
        HapticFeedback.heavyImpact();
        widget.onCaptureFailed?.call();
      }
    } catch (e) {
      widget.onCaptureFailed?.call();
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _simulateFingerDetection() {
    setState(() {
      _fingerDetected = !_fingerDetected;
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
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'AR Fingerprint Scanning',
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
            'Position your finger in the camera viewfinder for scanning',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Finger selection
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select finger to scan:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'Thumb',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        value: 'thumb',
                        groupValue: _selectedFinger,
                        onChanged: (value) {
                          setState(() {
                            _selectedFinger = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'Index',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        value: 'index',
                        groupValue: _selectedFinger,
                        onChanged: (value) {
                          setState(() {
                            _selectedFinger = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Camera viewfinder
          Container(
            width: double.infinity,
            height: 35.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _fingerDetected
                    ? AppTheme.getAccentColor()
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  if (_isCameraInitialized && _cameraController != null)
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CameraPreview(_cameraController!),
                    )
                  else
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.w,
                              height: 10.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Initializing camera...',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Finger positioning overlay
                  Center(
                    child: AnimatedBuilder(
                      animation: _overlayAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 30.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _fingerDetected
                                  ? AppTheme.getAccentColor()
                                  : Colors.white.withValues(
                                      alpha: _overlayAnimation.value),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'fingerprint',
                                  color: _fingerDetected
                                      ? AppTheme.getAccentColor()
                                      : Colors.white.withValues(alpha: 0.8),
                                  size: 12.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _fingerDetected
                                      ? 'Finger detected'
                                      : 'Place finger here',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: _fingerDetected
                                        ? AppTheme.getAccentColor()
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Quality indicators
                  if (_fingerDetected)
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getAccentColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: Colors.white,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Good Quality',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _simulateFingerDetection,
                  child: Text('Simulate Detection'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _isCameraInitialized && _fingerDetected && !_isCapturing
                          ? _captureFingerprint
                          : null,
                  child: _isCapturing
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text('Capture'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
