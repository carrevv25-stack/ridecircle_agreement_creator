import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AadhaarSection extends StatefulWidget {
  final TextEditingController aadhaarController;
  final Function(bool) onValidationChanged;
  final Function(XFile?, XFile?) onImagesChanged;

  const AadhaarSection({
    Key? key,
    required this.aadhaarController,
    required this.onValidationChanged,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<AadhaarSection> createState() => _AadhaarSectionState();
}

class _AadhaarSectionState extends State<AadhaarSection> {
  bool _isAadhaarValid = false;
  XFile? _frontImage;
  XFile? _backImage;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    widget.aadhaarController.addListener(_validateAadhaar);
  }

  @override
  void dispose() {
    widget.aadhaarController.removeListener(_validateAadhaar);
    super.dispose();
  }

  void _validateAadhaar() {
    final aadhaarText =
        widget.aadhaarController.text.replaceAll(RegExp(r'[^\d]'), '');
    final isValid =
        aadhaarText.length == 12 && _frontImage != null && _backImage != null;
    if (_isAadhaarValid != isValid) {
      setState(() {
        _isAadhaarValid = isValid;
      });
      widget.onValidationChanged(isValid);
    }
  }

  String _formatAadhaar(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length <= 4) return digitsOnly;
    if (digitsOnly.length <= 8) {
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}';
    }
    return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 8)} ${digitsOnly.substring(8)}';
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
        _validateAadhaar();
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
        _validateAadhaar();
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
    final isComplete = _isAadhaarValid;

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
                      iconName: 'credit_card',
                      color: isComplete
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Aadhaar Details',
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
                    controller: widget.aadhaarController,
                    decoration: InputDecoration(
                      labelText: 'Aadhaar Number *',
                      hintText: '1234 5678 9012',
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: widget.aadhaarController.text
                                  .replaceAll(RegExp(r'[^\d]'), '')
                                  .length ==
                              12
                          ? Icon(
                              Icons.check_circle,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            )
                          : null,
                      errorText: widget.aadhaarController.text.isNotEmpty &&
                              widget.aadhaarController.text
                                      .replaceAll(RegExp(r'[^\d]'), '')
                                      .length !=
                                  12
                          ? 'Enter valid 12-digit Aadhaar number'
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final formatted = _formatAadhaar(newValue.text);
                        return TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Aadhaar Card Images *',
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
