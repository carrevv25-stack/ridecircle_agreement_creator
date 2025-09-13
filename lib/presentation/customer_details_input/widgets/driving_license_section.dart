import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DrivingLicenseSection extends StatefulWidget {
  final TextEditingController dlController;
  final Function(bool) onValidationChanged;
  final Function(XFile?, XFile?) onImagesChanged;

  const DrivingLicenseSection({
    Key? key,
    required this.dlController,
    required this.onValidationChanged,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<DrivingLicenseSection> createState() => _DrivingLicenseSectionState();
}

class _DrivingLicenseSectionState extends State<DrivingLicenseSection> {
  bool _isDLValid = false;
  XFile? _frontImage;
  XFile? _backImage;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    widget.dlController.addListener(_validateDL);
  }

  @override
  void dispose() {
    widget.dlController.removeListener(_validateDL);
    super.dispose();
  }

  void _validateDL() {
    final dlText = widget.dlController.text.trim();
    // Basic DL validation - should be alphanumeric and 10-20 characters
    final isValid = dlText.length >= 10 &&
        dlText.length <= 20 &&
        RegExp(r'^[A-Z0-9]+$').hasMatch(dlText.toUpperCase()) &&
        _frontImage != null &&
        _backImage != null;
    if (_isDLValid != isValid) {
      setState(() {
        _isDLValid = isValid;
      });
      widget.onValidationChanged(isValid);
    }
  }

  Future<void> _captureImage(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          if (isFront) {
            _frontImage = image;
          } else {
            _backImage = image;
          }
        });
        widget.onImagesChanged(_frontImage, _backImage);
        _validateDL();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image. Please try again.')),
      );
    }
  }

  Future<void> _selectFromGallery(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          if (isFront) {
            _frontImage = image;
          } else {
            _backImage = image;
          }
        });
        widget.onImagesChanged(_frontImage, _backImage);
        _validateDL();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image. Please try again.')),
      );
    }
  }

  void _showImageSourceDialog(bool isFront) {
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
              subtitle: Text('Take a photo with camera'),
              onTap: () {
                Navigator.pop(context);
                _captureImage(isFront);
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
                _selectFromGallery(isFront);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(String title, XFile? image, bool isFront) {
    return Container(
      width: double.infinity,
      height: 12.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: image != null
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.outline,
          width: image != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: image != null
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showImageSourceDialog(isFront),
          child: image != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: image.path,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1.h,
                      left: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Tap to retake',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap to capture',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
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
    final isComplete = _isDLValid;

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
                      iconName: 'drive_eta',
                      color: isComplete
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Driving License',
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
                  TextFormField(
                    controller: widget.dlController,
                    decoration: InputDecoration(
                      labelText: 'Driving License Number *',
                      hintText: 'MH1420110012345',
                      prefixIcon: Icon(
                        Icons.drive_eta,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: _isDLValid
                          ? Icon(
                              Icons.check_circle,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            )
                          : null,
                      errorText:
                          widget.dlController.text.isNotEmpty && !_isDLValid
                              ? 'Enter valid driving license number'
                              : null,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Driving License Images *',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child:
                            _buildImageButton('Front Side', _frontImage, true),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child:
                            _buildImageButton('Back Side', _backImage, false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
