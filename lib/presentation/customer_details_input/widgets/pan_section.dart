import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PanSection extends StatefulWidget {
  final TextEditingController panController;
  final Function(bool) onValidationChanged;
  final Function(XFile?) onImageChanged;

  const PanSection({
    Key? key,
    required this.panController,
    required this.onValidationChanged,
    required this.onImageChanged,
  }) : super(key: key);

  @override
  State<PanSection> createState() => _PanSectionState();
}

class _PanSectionState extends State<PanSection> {
  bool _isPanValid = false;
  XFile? _panImage;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    widget.panController.addListener(_validatePan);
  }

  @override
  void dispose() {
    widget.panController.removeListener(_validatePan);
    super.dispose();
  }

  void _validatePan() {
    final panText = widget.panController.text.trim().toUpperCase();
    // PAN format: ABCDE1234F (5 letters, 4 digits, 1 letter)
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    final isValid = panRegex.hasMatch(panText) && _panImage != null;
    if (_isPanValid != isValid) {
      setState(() {
        _isPanValid = isValid;
      });
      widget.onValidationChanged(isValid);
    }
  }

  String _formatPan(String value) {
    final upperCase = value.toUpperCase();
    return upperCase;
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _panImage = image;
        });
        widget.onImageChanged(image);
        _validatePan();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image. Please try again.')),
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
          _panImage = image;
        });
        widget.onImageChanged(image);
        _validatePan();
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
              subtitle: Text('Take a photo with camera'),
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

  Widget _buildImageButton() {
    return Container(
      width: double.infinity,
      height: 12.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: _panImage != null
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.outline,
          width: _panImage != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _panImage != null
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _showImageSourceDialog,
          child: _panImage != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: _panImage!.path,
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
                      'PAN Card Image',
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
    final isComplete = _isPanValid;

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
                      iconName: 'account_balance_wallet',
                      color: isComplete
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'PAN Card Details',
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
                    controller: widget.panController,
                    decoration: InputDecoration(
                      labelText: 'PAN Number *',
                      hintText: 'ABCDE1234F',
                      prefixIcon: Icon(
                        Icons.account_balance_wallet,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: _isPanValid
                          ? Icon(
                              Icons.check_circle,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            )
                          : null,
                      errorText:
                          widget.panController.text.isNotEmpty && !_isPanValid
                              ? 'Enter valid PAN number (ABCDE1234F format)'
                              : null,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      LengthLimitingTextInputFormatter(10),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final formatted = _formatPan(newValue.text);
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
                    'PAN Card Image *',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildImageButton(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
