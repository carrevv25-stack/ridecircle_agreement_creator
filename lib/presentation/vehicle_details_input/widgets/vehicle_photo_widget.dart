import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehiclePhotoWidget extends StatefulWidget {
  final XFile? capturedImage;
  final Function(XFile?) onImageCaptured;

  const VehiclePhotoWidget({
    Key? key,
    this.capturedImage,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  State<VehiclePhotoWidget> createState() => _VehiclePhotoWidgetState();
}

class _VehiclePhotoWidgetState extends State<VehiclePhotoWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isInitializing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageCaptured(image);
      }
    } catch (e) {
      // Handle error silently
    }
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
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle & Customer Photo',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Capture a photo showing both the vehicle and customer together *',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Camera Preview or Captured Image
          Container(
            height: 30.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.capturedImage != null
                  ? _buildCapturedImagePreview()
                  : _buildCameraPreview(),
            ),
          ),

          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text('Gallery'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCameraInitialized ? _capturePhoto : null,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text('Capture'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),

          if (widget.capturedImage != null) ...[
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () => widget.onImageCaptured(null),
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 18,
              ),
              label: Text(
                'Remove Photo',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],

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
                    'Ensure both vehicle and customer are clearly visible in the frame for verification purposes',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
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

  Widget _buildCameraPreview() {
    if (_isInitializing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Initializing camera...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Camera not available',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Use gallery to select photo',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        Positioned(
          bottom: 2.h,
          left: 4.w,
          right: 4.w,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Position both vehicle and customer in the frame',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapturedImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        kIsWeb
            ? Image.network(
                widget.capturedImage!.path,
                fit: BoxFit.cover,
              )
            : CustomImageWidget(
                imageUrl: widget.capturedImage!.path,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
        Positioned(
          top: 2.h,
          right: 2.w,
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
