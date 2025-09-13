import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/aadhaar_section.dart';
import './widgets/customer_selfie_section.dart';
import './widgets/driving_license_section.dart';
import './widgets/pan_section.dart';
import './widgets/personal_details_section.dart';
import './widgets/progress_indicator_widget.dart';

class CustomerDetailsInput extends StatefulWidget {
  const CustomerDetailsInput({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsInput> createState() => _CustomerDetailsInputState();
}

class _CustomerDetailsInputState extends State<CustomerDetailsInput> {
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _dlController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  // Validation states
  bool _isPersonalDetailsValid = false;
  bool _isAadhaarValid = false;
  bool _isDLValid = false;
  bool _isPanValid = false;
  bool _isSelfieValid = false;

  // Image storage
  XFile? _aadhaarFront;
  XFile? _aadhaarBack;
  XFile? _dlFront;
  XFile? _dlBack;
  XFile? _panImage;
  XFile? _selfieImage;

  bool get _isFormValid {
    return _isPersonalDetailsValid &&
        _isAadhaarValid &&
        _isDLValid &&
        _isPanValid &&
        _isSelfieValid;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _dlController.dispose();
    _panController.dispose();
    super.dispose();
  }

  void _onPersonalDetailsValidationChanged(bool isValid) {
    setState(() {
      _isPersonalDetailsValid = isValid;
    });
  }

  void _onAadhaarValidationChanged(bool isValid) {
    setState(() {
      _isAadhaarValid = isValid;
    });
  }

  void _onAadhaarImagesChanged(XFile? front, XFile? back) {
    setState(() {
      _aadhaarFront = front;
      _aadhaarBack = back;
    });
  }

  void _onDLValidationChanged(bool isValid) {
    setState(() {
      _isDLValid = isValid;
    });
  }

  void _onDLImagesChanged(XFile? front, XFile? back) {
    setState(() {
      _dlFront = front;
      _dlBack = back;
    });
  }

  void _onPanValidationChanged(bool isValid) {
    setState(() {
      _isPanValid = isValid;
    });
  }

  void _onPanImageChanged(XFile? image) {
    setState(() {
      _panImage = image;
    });
  }

  void _onSelfieValidationChanged(bool isValid) {
    setState(() {
      _isSelfieValid = isValid;
    });
  }

  void _onSelfieImageChanged(XFile? image) {
    setState(() {
      _selfieImage = image;
    });
  }

  void _navigateToVehicleDetails() {
    if (_isFormValid) {
      // Save form data locally (encrypted storage would be implemented here)
      Navigator.pushNamed(context, '/vehicle-details-input');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Customer Details'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Show help or info dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Customer Information'),
                  content: Text(
                    'Please collect and verify all customer documents carefully. '
                    'Ensure all images are clear and readable for legal compliance.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Help'),
          ),
        ],
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(
            currentStep: 2,
            totalSteps: 12,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Information',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Collect customer details and documents for rental agreement',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PersonalDetailsSection(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    emailController: _emailController,
                    onValidationChanged: _onPersonalDetailsValidationChanged,
                  ),
                  AadhaarSection(
                    aadhaarController: _aadhaarController,
                    onValidationChanged: _onAadhaarValidationChanged,
                    onImagesChanged: _onAadhaarImagesChanged,
                  ),
                  DrivingLicenseSection(
                    dlController: _dlController,
                    onValidationChanged: _onDLValidationChanged,
                    onImagesChanged: _onDLImagesChanged,
                  ),
                  PanSection(
                    panController: _panController,
                    onValidationChanged: _onPanValidationChanged,
                    onImageChanged: _onPanImageChanged,
                  ),
                  CustomerSelfieSection(
                    onValidationChanged: _onSelfieValidationChanged,
                    onImageChanged: _onSelfieImageChanged,
                  ),
                  SizedBox(height: 10.h), // Space for fixed button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isFormValid)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Complete all sections to continue',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          _isFormValid ? _navigateToVehicleDetails : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue'),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: _isFormValid
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
