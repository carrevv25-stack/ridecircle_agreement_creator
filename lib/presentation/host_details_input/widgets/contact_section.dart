import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? phoneError;
  final String? emailError;
  final Function(String) onPhoneChanged;
  final Function(String) onEmailChanged;

  const ContactSection({
    Key? key,
    required this.phoneController,
    required this.emailController,
    this.phoneError,
    this.emailError,
    required this.onPhoneChanged,
    required this.onEmailChanged,
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
                  iconName: 'contact_phone',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              onChanged: onPhoneChanged,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: '9876543210',
                prefixIcon: Icon(
                  Icons.phone,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                prefixText: '+91 ',
                errorText: phoneError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: 'Enter 10-digit mobile number',
                helperStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                if (value.trim().length != 10) {
                  return 'Phone number must be 10 digits';
                }
                final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');
                if (!phoneRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid Indian mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: onEmailChanged,
              decoration: InputDecoration(
                labelText: 'Email Address *',
                hintText: 'business@example.com',
                prefixIcon: Icon(
                  Icons.email,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                errorText: emailError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email address is required';
                }
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
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
