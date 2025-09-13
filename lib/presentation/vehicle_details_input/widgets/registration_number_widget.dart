import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationNumberWidget extends StatefulWidget {
  final String? registrationNumber;
  final Function(String?) onRegistrationChanged;

  const RegistrationNumberWidget({
    Key? key,
    this.registrationNumber,
    required this.onRegistrationChanged,
  }) : super(key: key);

  @override
  State<RegistrationNumberWidget> createState() =>
      _RegistrationNumberWidgetState();
}

class _RegistrationNumberWidgetState extends State<RegistrationNumberWidget> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.registrationNumber);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidRegistrationNumber(String value) {
    // Indian vehicle registration number format: XX00XX0000 or XX-00-XX-0000
    final regExp = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}$');
    final cleanValue = value.replaceAll(RegExp(r'[-\s]'), '').toUpperCase();
    return regExp.hasMatch(cleanValue);
  }

  String _formatRegistrationNumber(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[-\s]'), '').toUpperCase();
    if (cleanValue.length >= 4) {
      String formatted = cleanValue.substring(0, 2);
      if (cleanValue.length > 2) {
        formatted +=
            '-${cleanValue.substring(2, cleanValue.length >= 4 ? 4 : cleanValue.length)}';
      }
      if (cleanValue.length > 4) {
        formatted +=
            '-${cleanValue.substring(4, cleanValue.length >= 6 ? 6 : cleanValue.length)}';
      }
      if (cleanValue.length > 6) {
        formatted += '-${cleanValue.substring(6)}';
      }
      return formatted;
    }
    return cleanValue;
  }

  void _onTextChanged(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[-\s]'), '').toUpperCase();

    setState(() {
      if (cleanValue.isEmpty) {
        _errorText = null;
      } else if (cleanValue.length < 8) {
        _errorText = 'Registration number is too short';
      } else if (!_isValidRegistrationNumber(cleanValue)) {
        _errorText = 'Invalid registration number format';
      } else {
        _errorText = null;
      }
    });

    widget.onRegistrationChanged(cleanValue.isEmpty ? null : cleanValue);
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
                iconName: 'confirmation_number',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Registration Number',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Registration Number *',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _controller,
            onChanged: _onTextChanged,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-\s]')),
              LengthLimitingTextInputFormatter(13), // XX-00-XX-0000 format
              TextInputFormatter.withFunction((oldValue, newValue) {
                final formatted = _formatRegistrationNumber(newValue.text);
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
            decoration: InputDecoration(
              hintText: 'e.g., MH-12-AB-1234',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              errorText: _errorText,
              errorStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
              ),
            ),
          ),
          if (_errorText == null && _controller.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Valid registration number',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
