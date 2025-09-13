import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessInfoSection extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController gstController;
  final String? businessNameError;
  final String? gstError;
  final Function(String) onBusinessNameChanged;
  final Function(String) onGstChanged;

  const BusinessInfoSection({
    Key? key,
    required this.businessNameController,
    required this.gstController,
    this.businessNameError,
    this.gstError,
    required this.onBusinessNameChanged,
    required this.onGstChanged,
  }) : super(key: key);

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
                  iconName: 'business',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Business Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: businessNameController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              onChanged: onBusinessNameChanged,
              decoration: InputDecoration(
                labelText: 'Business Name *',
                hintText: 'Enter your business name',
                prefixIcon: Icon(
                  Icons.store,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                errorText: businessNameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Business name is required';
                }
                if (value.trim().length < 2) {
                  return 'Business name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: gstController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              onChanged: onGstChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                labelText: 'GST Number *',
                hintText: '22AAAAA0000A1Z5',
                prefixIcon: Icon(
                  Icons.receipt_long,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                errorText: gstError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: '15-digit GST identification number',
                helperStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'GST number is required';
                }
                if (value.trim().length != 15) {
                  return 'GST number must be exactly 15 characters';
                }
                final gstRegex = RegExp(
                    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                if (!gstRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid GST number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
