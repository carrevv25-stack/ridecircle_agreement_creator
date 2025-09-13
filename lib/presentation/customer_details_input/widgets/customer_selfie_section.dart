import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomerSelfieSection extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final Function(XFile?) onImageChanged;

  const CustomerSelfieSection({
    Key? key,
    required this.onValidationChanged,
    required this.onImageChanged,
  }) : super(key: key);

  @override
  State<CustomerSelfieSection> createState() => _CustomerSelfieSectionState();
}

class _CustomerSelfieSectionState extends State<CustomerSelfieSection> {
  XFile? _selfieImage;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = true;
  bool _isSelfieValid = false;

  void _validateSelfie() {
    final isValid = _selfieImage != null;
    if (_isSelfieValid != isValid) {
      setState(() {
        _isSelfieValid = isValid;
      });
      widget.onValidationChanged(isValid);
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _captureImage() async {
    try {
      if (!await _requestCameraPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Camera permission is required to take selfie')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _selfieImage = image;
        });
        widget.onImageChanged(image);
        _validateSelfie();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture selfie. Please try again.')),
      );
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _selfieImage = image;
        });
        widget.onImageChanged(image);
        _validateSelfie();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image. Please try again.')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Image Source',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Camera'),
              subtitle: Text('Take a selfie with front camera'),
              onTap: () {
                Navigator.pop(context);
                _captureImage();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Gallery'),
              subtitle: Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _selectFromGallery();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSelfieButton() {
    return Container(
      width: double.infinity,
      height: 20.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: _selfieImage != null
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.outline,
          width: _selfieImage != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: _selfieImage != null
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _showImageSourceDialog,
          child: _selfieImage != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: _selfieImage!.path,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2.h,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Tap to retake selfie',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'face',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Customer Selfie',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap to take passport-style selfie',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Face should be clearly visible',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _isSelfieValid;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
                bottom: _isExpanded ? Radius.zero : Radius.circular(12),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'face',
                      color: isComplete
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Customer Selfie',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isComplete
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : null,
                        ),
                      ),
                    ),
                    if (isComplete)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20,
                      ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Photo *',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Please ensure the customer\'s face is clearly visible and well-lit for identification purposes.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildSelfieButton(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
