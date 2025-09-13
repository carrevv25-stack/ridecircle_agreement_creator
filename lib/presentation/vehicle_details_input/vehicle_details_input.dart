import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/fastag_widget.dart';
import './widgets/fuel_level_widget.dart';
import './widgets/fuel_transmission_widget.dart';
import './widgets/registration_number_widget.dart';
import './widgets/vehicle_make_model_widget.dart';
import './widgets/vehicle_photo_widget.dart';
import './widgets/vehicle_year_widget.dart';

class VehicleDetailsInput extends StatefulWidget {
  const VehicleDetailsInput({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsInput> createState() => _VehicleDetailsInputState();
}

class _VehicleDetailsInputState extends State<VehicleDetailsInput> {
  // Form data
  String? _selectedMake;
  String? _selectedModel;
  int? _selectedYear;
  String? _registrationNumber;
  String? _selectedFuelType;
  String? _selectedTransmissionType;
  double _fuelLevel = 50.0;
  bool _hasFastag = false;
  String? _fastagNumber;
  XFile? _vehicleCustomerPhoto;

  // Vehicle condition checklist
  final Map<String, Map<String, bool>> _vehicleCondition = {
    'Exterior': {
      'Body damage or scratches': false,
      'Headlights and taillights working': false,
      'Mirrors intact and clean': false,
      'Tires in good condition': false,
      'License plate clearly visible': false,
    },
    'Interior': {
      'Seats clean and undamaged': false,
      'Dashboard and controls working': false,
      'Air conditioning functional': false,
      'Seat belts working properly': false,
      'Interior lights functional': false,
    },
    'Mechanical': {
      'Engine starts smoothly': false,
      'Brakes working properly': false,
      'Steering responsive': false,
      'Horn functional': false,
      'Wipers working': false,
    },
    'Accessories': {
      'Spare tire available': false,
      'Jack and tools present': false,
      'First aid kit available': false,
      'Documents in vehicle': false,
      'Keys and remotes working': false,
    },
  };

  bool get _isFormValid {
    return _selectedMake != null &&
        _selectedModel != null &&
        _selectedYear != null &&
        _registrationNumber != null &&
        _selectedFuelType != null &&
        _selectedTransmissionType != null &&
        _vehicleCustomerPhoto != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  SizedBox(height: 3.h),

                  // Vehicle Make & Model
                  VehicleMakeModelWidget(
                    selectedMake: _selectedMake,
                    selectedModel: _selectedModel,
                    onMakeChanged: (value) =>
                        setState(() => _selectedMake = value),
                    onModelChanged: (value) =>
                        setState(() => _selectedModel = value),
                  ),
                  SizedBox(height: 3.h),

                  // Vehicle Year
                  VehicleYearWidget(
                    selectedYear: _selectedYear,
                    onYearChanged: (value) =>
                        setState(() => _selectedYear = value),
                  ),
                  SizedBox(height: 3.h),

                  // Registration Number
                  RegistrationNumberWidget(
                    registrationNumber: _registrationNumber,
                    onRegistrationChanged: (value) =>
                        setState(() => _registrationNumber = value),
                  ),
                  SizedBox(height: 3.h),

                  // Fuel & Transmission
                  FuelTransmissionWidget(
                    selectedFuelType: _selectedFuelType,
                    selectedTransmissionType: _selectedTransmissionType,
                    onFuelTypeChanged: (value) =>
                        setState(() => _selectedFuelType = value),
                    onTransmissionTypeChanged: (value) =>
                        setState(() => _selectedTransmissionType = value),
                  ),
                  SizedBox(height: 3.h),

                  // Fuel Level
                  FuelLevelWidget(
                    fuelLevel: _fuelLevel,
                    onFuelLevelChanged: (value) =>
                        setState(() => _fuelLevel = value),
                  ),
                  SizedBox(height: 3.h),

                  // FASTag
                  FastagWidget(
                    hasFastag: _hasFastag,
                    fastagNumber: _fastagNumber,
                    onFastagToggle: (value) =>
                        setState(() => _hasFastag = value),
                    onFastagNumberChanged: (value) =>
                        setState(() => _fastagNumber = value),
                  ),
                  SizedBox(height: 3.h),

                  // Vehicle Condition Assessment
                  _buildVehicleConditionSection(),
                  SizedBox(height: 3.h),

                  // Vehicle & Customer Photo
                  VehiclePhotoWidget(
                    capturedImage: _vehicleCustomerPhoto,
                    onImageCaptured: (image) =>
                        setState(() => _vehicleCustomerPhoto = image),
                  ),
                  SizedBox(height: 10.h), // Space for fixed button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Vehicle Details',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            // Show help or info
          },
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Step 3 of 12',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: LinearProgressIndicator(
              value: 3 / 12,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            '25%',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Information',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Enter comprehensive vehicle details for the rental agreement. All marked fields are required.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleConditionSection() {
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
                iconName: 'checklist',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Condition Assessment',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Check all applicable conditions for the vehicle',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ..._vehicleCondition.entries.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(
                    category.key,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                ...category.value.entries.map((condition) {
                  return CheckboxListTile(
                    title: Text(
                      condition.key,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    value: condition.value,
                    onChanged: (value) {
                      setState(() {
                        _vehicleCondition[category.key]![condition.key] =
                            value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                }).toList(),
                if (category.key != _vehicleCondition.keys.last)
                  SizedBox(height: 2.h),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid ? _handleContinue : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Continue to Biometric Capture',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_isFormValid) {
      Navigator.pushNamed(context, '/biometric-capture');
    }
  }
}
