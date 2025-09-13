import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddressSection extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pinCodeController;
  final String? streetError;
  final String? cityError;
  final String? stateError;
  final String? pinCodeError;
  final Function(String) onStreetChanged;
  final Function(String) onCityChanged;
  final Function(String) onStateChanged;
  final Function(String) onPinCodeChanged;

  const AddressSection({
    Key? key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.pinCodeController,
    this.streetError,
    this.cityError,
    this.stateError,
    this.pinCodeError,
    required this.onStreetChanged,
    required this.onCityChanged,
    required this.onStateChanged,
    required this.onPinCodeChanged,
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
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Business Address',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: streetController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              onChanged: onStreetChanged,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Street Address *',
                hintText: 'Enter your complete street address',
                prefixIcon: Icon(
                  Icons.home,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                errorText: streetError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Street address is required';
                }
                if (value.trim().length < 5) {
                  return 'Please enter a complete address';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: cityController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    onChanged: onCityChanged,
                    decoration: InputDecoration(
                      labelText: 'City *',
                      hintText: 'City name',
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      errorText: cityError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextFormField(
                    controller: pinCodeController,
                    keyboardType: TextInputType.number,
                    onChanged: onPinCodeChanged,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'PIN *',
                      hintText: '400001',
                      errorText: pinCodeError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'PIN required';
                      }
                      if (value.trim().length != 6) {
                        return 'Invalid PIN';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: stateController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              onChanged: onStateChanged,
              decoration: InputDecoration(
                labelText: 'State *',
                hintText: 'Select or enter state',
                prefixIcon: Icon(
                  Icons.map,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                errorText: stateError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'State is required';
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
