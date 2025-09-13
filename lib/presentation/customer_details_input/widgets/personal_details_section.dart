import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalDetailsSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final Function(bool) onValidationChanged;

  const PersonalDetailsSection({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.onValidationChanged,
  }) : super(key: key);

  @override
  State<PersonalDetailsSection> createState() => _PersonalDetailsSectionState();
}

class _PersonalDetailsSectionState extends State<PersonalDetailsSection> {
  bool _isNameValid = false;
  bool _isPhoneValid = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(_validateName);
    widget.phoneController.addListener(_validatePhone);
    widget.emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_validateName);
    widget.phoneController.removeListener(_validatePhone);
    widget.emailController.removeListener(_validateEmail);
    super.dispose();
  }

  void _validateName() {
    final isValid = widget.nameController.text.trim().length >= 2;
    if (_isNameValid != isValid) {
      setState(() {
        _isNameValid = isValid;
      });
      _updateValidation();
    }
  }

  void _validatePhone() {
    final phoneText =
        widget.phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    final isValid = phoneText.length == 10;
    if (_isPhoneValid != isValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
      _updateValidation();
    }
  }

  void _validateEmail() {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final isValid = emailRegex.hasMatch(widget.emailController.text.trim());
    if (_isEmailValid != isValid) {
      setState(() {
        _isEmailValid = isValid;
      });
      _updateValidation();
    }
  }

  void _updateValidation() {
    widget.onValidationChanged(_isNameValid && _isPhoneValid && _isEmailValid);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Personal Details',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Enter customer full name',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _isNameValid
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      )
                    : null,
                errorText:
                    widget.nameController.text.isNotEmpty && !_isNameValid
                        ? 'Name must be at least 2 characters'
                        : null,
              ),
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: widget.phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: '9876543210',
                prefixText: '+91 ',
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _isPhoneValid
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      )
                    : null,
                errorText:
                    widget.phoneController.text.isNotEmpty && !_isPhoneValid
                        ? 'Enter valid 10-digit phone number'
                        : null,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: widget.emailController,
              decoration: InputDecoration(
                labelText: 'Email Address *',
                hintText: 'customer@example.com',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _isEmailValid
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      )
                    : null,
                errorText:
                    widget.emailController.text.isNotEmpty && !_isEmailValid
                        ? 'Enter valid email address'
                        : null,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
