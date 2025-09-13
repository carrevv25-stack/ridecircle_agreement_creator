import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/address_section.dart';
import './widgets/business_info_section.dart';
import './widgets/contact_section.dart';
import './widgets/logo_upload_section.dart';
import './widgets/progress_indicator_widget.dart';

class HostDetailsInput extends StatefulWidget {
  const HostDetailsInput({Key? key}) : super(key: key);

  @override
  State<HostDetailsInput> createState() => _HostDetailsInputState();
}

class _HostDetailsInputState extends State<HostDetailsInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Error states
  String? _businessNameError;
  String? _gstError;
  String? _streetError;
  String? _cityError;
  String? _stateError;
  String? _pinCodeError;
  String? _phoneError;
  String? _emailError;
  String? _logoError;

  // Form state
  XFile? _selectedLogo;
  bool _isFormValid = false;
  Timer? _validationTimer;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _gstController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _validationTimer?.cancel();
    super.dispose();
  }

  void _setupValidationListeners() {
    _businessNameController.addListener(_onFormChanged);
    _gstController.addListener(_onFormChanged);
    _streetController.addListener(_onFormChanged);
    _cityController.addListener(_onFormChanged);
    _stateController.addListener(_onFormChanged);
    _pinCodeController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    _validationTimer?.cancel();
    _validationTimer = Timer(const Duration(milliseconds: 500), () {
      _validateForm();
    });
  }

  void _validateForm() {
    setState(() {
      _businessNameError = _validateBusinessName(_businessNameController.text);
      _gstError = _validateGST(_gstController.text);
      _streetError = _validateStreet(_streetController.text);
      _cityError = _validateCity(_cityController.text);
      _stateError = _validateState(_stateController.text);
      _pinCodeError = _validatePinCode(_pinCodeController.text);
      _phoneError = _validatePhone(_phoneController.text);
      _emailError = _validateEmail(_emailController.text);

      _isFormValid = _businessNameError == null &&
          _gstError == null &&
          _streetError == null &&
          _cityError == null &&
          _stateError == null &&
          _pinCodeError == null &&
          _phoneError == null &&
          _emailError == null &&
          _businessNameController.text.trim().isNotEmpty &&
          _gstController.text.trim().isNotEmpty &&
          _streetController.text.trim().isNotEmpty &&
          _cityController.text.trim().isNotEmpty &&
          _stateController.text.trim().isNotEmpty &&
          _pinCodeController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty;
    });
  }

  String? _validateBusinessName(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length < 2) {
      return 'Business name must be at least 2 characters';
    }
    return null;
  }

  String? _validateGST(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length != 15) {
      return 'GST number must be exactly 15 characters';
    }
    final gstRegex =
        RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (!gstRegex.hasMatch(value.trim())) {
      return 'Please enter a valid GST number';
    }
    return null;
  }

  String? _validateStreet(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length < 5) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? _validateCity(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length < 2) {
      return 'Please enter a valid city name';
    }
    return null;
  }

  String? _validateState(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length < 2) {
      return 'Please enter a valid state name';
    }
    return null;
  }

  String? _validatePinCode(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length != 6) {
      return 'PIN code must be 6 digits';
    }
    return null;
  }

  String? _validatePhone(String value) {
    if (value.trim().isEmpty) return null;
    if (value.trim().length != 10) {
      return 'Phone number must be 10 digits';
    }
    final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Indian mobile number';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.trim().isEmpty) return null;
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _onLogoSelected(XFile? logo) {
    setState(() {
      _selectedLogo = logo;
      _logoError = null;
    });
  }

  Future<void> _saveProgress() async {
    // Auto-save form data locally to prevent data loss
    // This would typically use SharedPreferences or secure storage
    debugPrint('Form progress saved locally');
  }

  Future<bool> _showExitConfirmation() async {
    if (!_hasUnsavedChanges()) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Unsaved Changes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              content: Text(
                'You have unsaved changes. Are you sure you want to exit?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  bool _hasUnsavedChanges() {
    return _businessNameController.text.trim().isNotEmpty ||
        _gstController.text.trim().isNotEmpty ||
        _streetController.text.trim().isNotEmpty ||
        _cityController.text.trim().isNotEmpty ||
        _stateController.text.trim().isNotEmpty ||
        _pinCodeController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _selectedLogo != null;
  }

  void _onContinuePressed() {
    if (_isFormValid) {
      HapticFeedback.lightImpact();
      _saveProgress();
      Navigator.pushNamed(context, '/customer-details-input');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 12,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Host Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Enter your business information to create rental agreements',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        BusinessInfoSection(
                          businessNameController: _businessNameController,
                          gstController: _gstController,
                          businessNameError: _businessNameError,
                          gstError: _gstError,
                          onBusinessNameChanged: (value) => _onFormChanged(),
                          onGstChanged: (value) => _onFormChanged(),
                        ),
                        AddressSection(
                          streetController: _streetController,
                          cityController: _cityController,
                          stateController: _stateController,
                          pinCodeController: _pinCodeController,
                          streetError: _streetError,
                          cityError: _cityError,
                          stateError: _stateError,
                          pinCodeError: _pinCodeError,
                          onStreetChanged: (value) => _onFormChanged(),
                          onCityChanged: (value) => _onFormChanged(),
                          onStateChanged: (value) => _onFormChanged(),
                          onPinCodeChanged: (value) => _onFormChanged(),
                        ),
                        ContactSection(
                          phoneController: _phoneController,
                          emailController: _emailController,
                          phoneError: _phoneError,
                          emailError: _emailError,
                          onPhoneChanged: (value) => _onFormChanged(),
                          onEmailChanged: (value) => _onFormChanged(),
                        ),
                        LogoUploadSection(
                          selectedLogo: _selectedLogo,
                          onLogoSelected: _onLogoSelected,
                          logoError: _logoError,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _isFormValid ? _onContinuePressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  foregroundColor: _isFormValid
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  elevation: _isFormValid ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _isFormValid
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
