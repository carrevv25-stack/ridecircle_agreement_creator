import 'package:flutter/material.dart';
import '../presentation/host_details_input/host_details_input.dart';
import '../presentation/customer_details_input/customer_details_input.dart';
import '../presentation/terms_and_conditions/terms_and_conditions.dart';
import '../presentation/biometric_capture/biometric_capture.dart';
import '../presentation/document_sharing/document_sharing.dart';
import '../presentation/vehicle_details_input/vehicle_details_input.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String hostDetailsInput = '/host-details-input';
  static const String customerDetailsInput = '/customer-details-input';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String biometricCapture = '/biometric-capture';
  static const String documentSharing = '/document-sharing';
  static const String vehicleDetailsInput = '/vehicle-details-input';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HostDetailsInput(),
    hostDetailsInput: (context) => const HostDetailsInput(),
    customerDetailsInput: (context) => const CustomerDetailsInput(),
    termsAndConditions: (context) => const TermsAndConditions(),
    biometricCapture: (context) => const BiometricCapture(),
    documentSharing: (context) => const DocumentSharing(),
    vehicleDetailsInput: (context) => const VehicleDetailsInput(),
    // TODO: Add your other routes here
  };
}
