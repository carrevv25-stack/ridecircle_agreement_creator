import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LogoUploadSection extends StatelessWidget {
  final XFile? selectedLogo;
  final Function(XFile?) onLogoSelected;
  final String? logoError;

  const LogoUploadSection({
    Key? key,
    this.selectedLogo,
    required this.onLogoSelected,
    this.logoError,
  }) : super(key: key);

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
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
                'Select Logo Source',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceOption(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildSourceOption(
                    context,
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 8.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Request permission for camera if needed
      if (source == ImageSource.camera && !kIsWeb) {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          return;
        }
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        onLogoSelected(image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'image',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Business Logo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
                Spacer(),
                Text(
                  'Optional',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            selectedLogo != null
                ? _buildSelectedLogo(context)
                : _buildUploadPlaceholder(context),
            if (logoError != null) ...[
              SizedBox(height: 1.h),
              Text(
                logoError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedLogo(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: kIsWeb
                ? Image.network(
                    selectedLogo!.path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(selectedLogo!.path),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
          ),
          Positioned(
            top: 1.h,
            right: 2.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceDialog(context),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 4.w,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () => onLogoSelected(null),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 4.w,
                      color: Colors.white,
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

  Widget _buildUploadPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: double.infinity,
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 12.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 1.h),
            Text(
              'Upload Business Logo',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Tap to select from camera or gallery',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
