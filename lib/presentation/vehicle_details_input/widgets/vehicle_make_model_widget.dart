import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleMakeModelWidget extends StatefulWidget {
  final String? selectedMake;
  final String? selectedModel;
  final Function(String?) onMakeChanged;
  final Function(String?) onModelChanged;

  const VehicleMakeModelWidget({
    Key? key,
    this.selectedMake,
    this.selectedModel,
    required this.onMakeChanged,
    required this.onModelChanged,
  }) : super(key: key);

  @override
  State<VehicleMakeModelWidget> createState() => _VehicleMakeModelWidgetState();
}

class _VehicleMakeModelWidgetState extends State<VehicleMakeModelWidget> {
  final List<String> vehicleMakes = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata',
    'Mahindra',
    'Honda',
    'Toyota',
    'Kia',
    'Renault',
    'Nissan',
    'Ford',
    'Volkswagen',
    'Skoda',
    'MG',
    'Jeep',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Jaguar',
    'Land Rover',
    'Volvo',
  ];

  final Map<String, List<String>> vehicleModels = {
    'Maruti Suzuki': [
      'Swift',
      'Baleno',
      'Dzire',
      'Alto',
      'WagonR',
      'Vitara Brezza',
      'Ertiga',
      'XL6',
      'S-Cross',
      'Ciaz'
    ],
    'Hyundai': [
      'i20',
      'Creta',
      'Verna',
      'Venue',
      'Grand i10 Nios',
      'Santro',
      'Tucson',
      'Elantra',
      'Kona Electric'
    ],
    'Tata': [
      'Nexon',
      'Harrier',
      'Safari',
      'Altroz',
      'Tiago',
      'Tigor',
      'Punch',
      'Hexa'
    ],
    'Mahindra': [
      'XUV700',
      'Scorpio',
      'Thar',
      'XUV300',
      'Bolero',
      'KUV100',
      'Marazzo'
    ],
    'Honda': ['City', 'Amaze', 'WR-V', 'Jazz', 'CR-V', 'Civic'],
    'Toyota': [
      'Innova Crysta',
      'Fortuner',
      'Yaris',
      'Glanza',
      'Urban Cruiser',
      'Camry',
      'Land Cruiser'
    ],
    'Kia': ['Seltos', 'Sonet', 'Carnival', 'EV6'],
    'Renault': ['Kwid', 'Triber', 'Duster', 'Kiger'],
    'Nissan': ['Magnite', 'Kicks', 'GT-R'],
    'Ford': ['EcoSport', 'Figo', 'Aspire', 'Endeavour'],
    'Volkswagen': ['Polo', 'Vento', 'Tiguan', 'T-Roc'],
    'Skoda': ['Rapid', 'Superb', 'Octavia', 'Kushaq', 'Slavia'],
    'MG': ['Hector', 'ZS EV', 'Astor', 'Gloster'],
    'Jeep': ['Compass', 'Wrangler', 'Grand Cherokee'],
    'BMW': ['3 Series', '5 Series', 'X1', 'X3', 'X5', 'X7', 'Z4'],
    'Mercedes-Benz': [
      'C-Class',
      'E-Class',
      'S-Class',
      'GLA',
      'GLC',
      'GLE',
      'GLS'
    ],
    'Audi': ['A3', 'A4', 'A6', 'A8', 'Q3', 'Q5', 'Q7', 'Q8'],
    'Jaguar': ['XE', 'XF', 'XJ', 'F-Pace', 'E-Pace', 'I-Pace'],
    'Land Rover': [
      'Discovery Sport',
      'Range Rover Evoque',
      'Range Rover Velar',
      'Range Rover'
    ],
    'Volvo': ['XC40', 'XC60', 'XC90', 'S60', 'S90'],
  };

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
                iconName: 'directions_car',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Make & Model',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make *',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownSearch<String>(
                      items: vehicleMakes,
                      selectedItem: widget.selectedMake,
                      onChanged: (value) {
                        widget.onMakeChanged(value);
                        if (value != widget.selectedMake) {
                          widget.onModelChanged(null);
                        }
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: 'Select Make',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.5.h),
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
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search make...',
                            prefixIcon: CustomIconWidget(
                              iconName: 'search',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        menuProps: MenuProps(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 8,
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            child: Text(
                              item,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model *',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownSearch<String>(
                      items: widget.selectedMake != null
                          ? (vehicleModels[widget.selectedMake!] ?? [])
                          : [],
                      selectedItem: widget.selectedModel,
                      onChanged: widget.onModelChanged,
                      enabled: widget.selectedMake != null,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: widget.selectedMake != null
                              ? 'Select Model'
                              : 'Select Make First',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.5.h),
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
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search model...',
                            prefixIcon: CustomIconWidget(
                              iconName: 'search',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        menuProps: MenuProps(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 8,
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            child: Text(
                              item,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
