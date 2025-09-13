import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/clause_section_widget.dart';
import './widgets/custom_clause_editor_widget.dart';
import './widgets/search_clause_widget.dart';
import './widgets/vehicle_condition_widget.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final ScrollController _scrollController = ScrollController();

  // Search functionality
  String _searchQuery = '';

  // Clause expansion states
  final Map<String, bool> _clauseExpansionStates = {
    'rental_terms': false,
    'payment_policy': false,
    'insurance_liability': false,
    'fuel_mileage': false,
    'emergency_contact': false,
    'legal_jurisdiction': false,
  };

  // Mandatory clause acceptance states
  final Map<String, bool> _mandatoryAcceptanceStates = {
    'insurance_liability': false,
    'legal_jurisdiction': false,
  };

  // Vehicle condition states
  final Map<String, bool> _vehicleConditionStates = {
    'cleaning_charges': false,
    'spare_parts': false,
    'damage_acknowledgment': false,
    'fuel_policy': false,
  };

  // Custom clauses
  String _customClauses = '';

  // Mock data for standard clauses
  final List<Map<String, dynamic>> _standardClauses = [
    {
      'key': 'rental_terms',
      'title': 'Rental Terms & Duration',
      'content':
          '''The rental period begins at the agreed pickup time and ends at the scheduled return time. Late returns will incur additional charges at the rate of ₹100 per hour or part thereof. The vehicle must be returned to the same location unless alternative arrangements have been made in writing. Early returns do not qualify for refunds. Extensions to the rental period must be approved in advance and are subject to vehicle availability and additional charges.''',
      'isMandatory': false,
    },
    {
      'key': 'payment_policy',
      'title': 'Payment Terms & Security Deposit',
      'content':
          '''Full rental payment is due at the time of vehicle pickup. Accepted payment methods include cash, UPI, credit/debit cards, and bank transfers. A security deposit is required and will be held until the vehicle is returned in satisfactory condition. The deposit amount varies based on vehicle type and rental duration. Additional charges for fuel, tolls, parking, fines, or damages will be deducted from the security deposit or charged separately. Refund of security deposit will be processed within 7-10 business days after vehicle return and inspection.''',
      'isMandatory': false,
    },
    {
      'key': 'insurance_liability',
      'title': 'Insurance & Liability Coverage',
      'content':
          '''The vehicle is covered under comprehensive insurance policy. However, the renter is liable for the first ₹5,000 of any claim (deductible amount). The renter is fully responsible for any damage caused by negligent driving, driving under influence, or violation of traffic rules. Insurance does not cover personal belongings left in the vehicle. The company is not liable for theft or damage to personal items. In case of accidents, the renter must immediately inform the rental company and local authorities. Failure to report accidents may void insurance coverage.''',
      'isMandatory': true,
    },
    {
      'key': 'fuel_mileage',
      'title': 'Fuel Policy & Mileage Restrictions',
      'content':
          '''The vehicle will be provided with a specified fuel level and must be returned with the same level. Fuel shortage will be charged at ₹100 per liter plus service charges. Daily mileage limit is 300 km for local rentals and 500 km for outstation trips. Excess mileage will be charged at ₹8 per km for hatchbacks, ₹10 per km for sedans, and ₹12 per km for SUVs. The vehicle is restricted to specific geographical areas as mentioned in the agreement. Unauthorized travel outside permitted areas may result in additional charges and insurance void.''',
      'isMandatory': false,
    },
    {
      'key': 'emergency_contact',
      'title': 'Emergency Procedures & Breakdown Assistance',
      'content':
          '''24/7 emergency helpline: +91-9876543210 In case of breakdown or emergency, immediately contact our helpline. Do not attempt repairs or engage unauthorized mechanics. Emergency roadside assistance is provided free of charge within city limits. Outstation assistance may involve additional charges for towing and transportation. For medical emergencies, contact 108 (Ambulance) or 102 (Emergency Medical Services) immediately, then inform our helpline. Keep all emergency contact numbers readily accessible and ensure your mobile phone is charged during the rental period.''',
      'isMandatory': false,
    },
    {
      'key': 'legal_jurisdiction',
      'title': 'Legal Jurisdiction & Dispute Resolution',
      'content':
          '''This agreement is governed by the laws of India and subject to the jurisdiction of courts in Mumbai, Maharashtra. Any disputes arising from this rental agreement will be resolved through arbitration as per the Arbitration and Conciliation Act, 2015. The renter agrees to resolve disputes amicably through mediation before pursuing legal action. Legal proceedings, if necessary, will be conducted in English language. This agreement constitutes the entire understanding between parties and supersedes all prior negotiations, representations, or agreements.''',
      'isMandatory': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize all clauses as collapsed
    for (var clause in _standardClauses) {
      _clauseExpansionStates[clause['key']] = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    // Check if all mandatory clauses are accepted
    bool allMandatoryAccepted =
        _mandatoryAcceptanceStates.values.every((accepted) => accepted);

    // Check if all vehicle conditions are acknowledged
    bool allConditionsAccepted =
        _vehicleConditionStates.values.every((accepted) => accepted);

    return allMandatoryAccepted && allConditionsAccepted;
  }

  List<Map<String, dynamic>> get _filteredClauses {
    if (_searchQuery.isEmpty) return _standardClauses;

    return _standardClauses.where((clause) {
      final title = clause['title'].toString().toLowerCase();
      final content = clause['content'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) || content.contains(query);
    }).toList();
  }

  void _toggleClauseExpansion(String key) {
    setState(() {
      _clauseExpansionStates[key] = !(_clauseExpansionStates[key] ?? false);
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _updateMandatoryAcceptance(String key, bool? value) {
    setState(() {
      _mandatoryAcceptanceStates[key] = value ?? false;
    });

    // Auto-save functionality
    _autoSaveProgress();
  }

  void _updateVehicleConditions(Map<String, bool> conditions) {
    setState(() {
      _vehicleConditionStates.addAll(conditions);
    });

    // Auto-save functionality
    _autoSaveProgress();
  }

  void _updateCustomClauses(String text) {
    setState(() {
      _customClauses = text;
    });

    // Auto-save functionality
    _autoSaveProgress();
  }

  void _autoSaveProgress() {
    // Auto-save functionality - in a real app, this would save to local storage
    // For now, we'll just show a brief indication
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text('Progress saved'),
          ],
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 15.h,
          left: 4.w,
          right: 4.w,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _showClauseExplanation(String title, String explanation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            explanation,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _continueToNextStep() {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please accept all mandatory terms and vehicle conditions to continue'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    // Navigate to document sharing screen
    Navigator.pushNamed(context, '/document-sharing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showClauseExplanation(
              'Legal Terms Help',
              'These terms and conditions are legally binding. Please read carefully and accept only if you understand and agree to all clauses. Contact our support team if you need clarification on any terms.',
            ),
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            tooltip: 'Help & Explanation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  'Step 7 of 12',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 7 / 12,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search functionality
          SearchClauseWidget(
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Header text
                  Text(
                    'Please review and accept the rental agreement terms',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Standard clauses
                  if (_filteredClauses.isNotEmpty) ...[
                    Text(
                      'Standard Terms & Conditions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredClauses.length,
                      itemBuilder: (context, index) {
                        final clause = _filteredClauses[index];
                        final key = clause['key'] as String;

                        return ClauseSectionWidget(
                          title: clause['title'],
                          content: clause['content'],
                          isExpanded: _clauseExpansionStates[key] ?? false,
                          onToggle: () => _toggleClauseExpansion(key),
                          isMandatory: clause['isMandatory'] ?? false,
                          isAccepted: _mandatoryAcceptanceStates[key] ?? false,
                          onAcceptanceChanged: clause['isMandatory'] == true
                              ? (value) =>
                                  _updateMandatoryAcceptance(key, value)
                              : null,
                        );
                      },
                    ),
                  ] else if (_searchQuery.isNotEmpty) ...[
                    // No search results
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'search_off',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No clauses found for "$_searchQuery"',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 4.h),

                  // Vehicle condition acknowledgment
                  Text(
                    'Vehicle Condition Terms',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  VehicleConditionWidget(
                    conditionStates: _vehicleConditionStates,
                    onConditionsChanged: _updateVehicleConditions,
                  ),

                  SizedBox(height: 4.h),

                  // Custom clauses section
                  Text(
                    'Additional Terms (Optional)',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  CustomClauseEditorWidget(
                    initialText: _customClauses,
                    onTextChanged: _updateCustomClauses,
                    maxCharacters: 1000,
                  ),

                  SizedBox(height: 12.h), // Extra space for fixed button
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed bottom continue button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress summary
            if (!_canContinue)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Please accept all mandatory terms to continue',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue ? _continueToNextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canContinue
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                  foregroundColor: _canContinue
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Document Sharing',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _canContinue
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: _canContinue
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
