
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_preview_widget.dart';
import './widgets/qr_code_widget.dart';
import './widgets/security_options_widget.dart';
import './widgets/sharing_history_widget.dart';
import './widgets/sharing_options_widget.dart';
import './widgets/success_animation_widget.dart';

class DocumentSharing extends StatefulWidget {
  const DocumentSharing({Key? key}) : super(key: key);

  @override
  State<DocumentSharing> createState() => _DocumentSharingState();
}

class _DocumentSharingState extends State<DocumentSharing> {
  bool _showSuccessAnimation = false;
  String _successMessage = 'Document shared successfully!';
  bool _passwordProtection = false;
  bool _watermarking = true;
  bool _accessLogging = true;

  // Mock data for document details
  final String _documentTitle =
      'Vehicle_Rental_Agreement_RajeshKumar_13Sep2025.pdf';
  final String _documentSize = '2.4 MB';
  final String _generatedDate = '13 Sep 2025, 03:37 AM';
  final String _qrExpirationDate = '20 Sep 2025';

  // Mock sharing history data
  final List<Map<String, dynamic>> _sharingHistory = [
    {
      'method': 'Email',
      'recipient': 'customer@example.com',
      'timestamp': '2 minutes ago',
      'status': 'delivered',
    },
    {
      'method': 'WhatsApp',
      'recipient': '+91 98765 43210',
      'timestamp': '5 minutes ago',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          SuccessAnimationWidget(
            isVisible: _showSuccessAnimation,
            message: _successMessage,
            onAnimationComplete: () {
              setState(() => _showSuccessAnimation = false);
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
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
          size: 6.w,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Sharing',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Step 9 of 9',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                'Complete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          SizedBox(height: 3.h),

          // Success message
          _buildSuccessHeader(),
          SizedBox(height: 3.h),

          // Document preview
          DocumentPreviewWidget(
            documentTitle: _documentTitle,
            documentSize: _documentSize,
            generatedDate: _generatedDate,
            hasDigitalSignature: true,
            onPreviewTap: _previewDocument,
          ),
          SizedBox(height: 3.h),

          // Sharing options
          SharingOptionsWidget(
            onEmailShare: _shareViaEmail,
            onWhatsAppShare: _shareViaWhatsApp,
            onCloudShare: _shareViaCloud,
            onPrintShare: _printDocument,
          ),
          SizedBox(height: 3.h),

          // QR Code
          QrCodeWidget(
            qrData: 'https://ridecircle.app/agreement/abc123',
            expirationDate: _qrExpirationDate,
            onShareQr: _shareQrCode,
          ),
          SizedBox(height: 3.h),

          // Security options
          SecurityOptionsWidget(
            passwordProtection: _passwordProtection,
            watermarking: _watermarking,
            accessLogging: _accessLogging,
            onPasswordToggle: (value) =>
                setState(() => _passwordProtection = value),
            onWatermarkToggle: (value) => setState(() => _watermarking = value),
            onLoggingToggle: (value) => setState(() => _accessLogging = value),
          ),
          SizedBox(height: 3.h),

          // Sharing history
          SharingHistoryWidget(
            sharingHistory: _sharingHistory,
          ),
          SizedBox(height: 3.h),

          // Document retention info
          _buildRetentionInfo(),
          SizedBox(height: 10.h), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            '100%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'celebration',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 8.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agreement Created Successfully!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Your legally binding rental agreement is ready to share with secure biometric verification.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Document Storage Policy',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Documents are stored locally on your device for 30 days. After this period, they will be automatically cleaned up to save storage space. You can manually backup important agreements to cloud storage.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _createNewAgreement,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Create New Agreement',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _previewDocument() {
    // Implement PDF preview functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Document Preview',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'PDF preview functionality would be implemented here using flutter_pdfview package.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareViaEmail() async {
    try {
      // Simulate email sharing with pre-populated content
      const String subject = 'Vehicle Rental Agreement - RideCircle';
      const String body = '''Dear Customer,

Please find attached your vehicle rental agreement for review and records.

Agreement Details:
- Document: Vehicle Rental Agreement
- Generated: 13 Sep 2025, 03:37 AM
- Security: Digitally signed and verified

This document contains all the terms and conditions agreed upon during the rental process, including biometric verification for enhanced security.

Please keep this document safe for your records.

Best regards,
RideCircle Team''';

      await Share.share(
        'Sharing vehicle rental agreement via email.\n\nSubject: $subject\n\nBody: $body',
        subject: subject,
      );

      _showSuccessMessage('Document shared via email successfully!');
      _addToSharingHistory('Email', 'customer@example.com');
    } catch (e) {
      _showErrorMessage('Failed to share via email. Please try again.');
    }
  }

  void _shareViaWhatsApp() async {
    try {
      const String message = '''🚗 *Vehicle Rental Agreement*

Your rental agreement is ready! 

📄 Document: Vehicle_Rental_Agreement_RajeshKumar_13Sep2025.pdf
📅 Generated: 13 Sep 2025, 03:37 AM
🔒 Security: Digitally signed & verified

This agreement contains all rental terms and biometric verification for your security.

*RideCircle - Secure Vehicle Rentals*''';

      await Share.share(message);
      _showSuccessMessage('Document shared via WhatsApp successfully!');
      _addToSharingHistory('WhatsApp', '+91 98765 43210');
    } catch (e) {
      _showErrorMessage('Failed to share via WhatsApp. Please try again.');
    }
  }

  void _shareViaCloud() async {
    try {
      // Simulate cloud storage sharing
      await Share.share(
        'Uploading vehicle rental agreement to cloud storage...\n\nFolder: RideCircle/Agreements/2025/September\nFile: $_documentTitle',
      );

      _showSuccessMessage('Document uploaded to cloud storage successfully!');
      _addToSharingHistory('Cloud', 'Google Drive');
    } catch (e) {
      _showErrorMessage('Failed to upload to cloud storage. Please try again.');
    }
  }

  void _printDocument() async {
    try {
      // Simulate printing functionality
      await Printing.layoutPdf(
        onLayout: (format) async {
          // This would contain the actual PDF bytes in a real implementation
          return Uint8List.fromList([]);
        },
      );

      _showSuccessMessage('Document sent to printer successfully!');
      _addToSharingHistory('Print', 'Local Printer');
    } catch (e) {
      _showErrorMessage('Failed to print document. Please try again.');
    }
  }

  void _shareQrCode() async {
    try {
      const String qrMessage = '''📱 *Quick Access QR Code*

Scan this QR code to access the vehicle rental agreement digitally.

🔗 Link: https://ridecircle.app/agreement/abc123
⏰ Expires: 20 Sep 2025

*RideCircle - Digital Agreement Access*''';

      await Share.share(qrMessage);
      _showSuccessMessage('QR code shared successfully!');
    } catch (e) {
      _showErrorMessage('Failed to share QR code. Please try again.');
    }
  }

  void _createNewAgreement() {
    // Navigate back to host details with pre-populated data
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/host-details-input',
      (route) => false,
    );
  }

  void _showSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
      _showSuccessAnimation = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _addToSharingHistory(String method, String recipient) {
    setState(() {
      _sharingHistory.insert(0, {
        'method': method,
        'recipient': recipient,
        'timestamp': 'Just now',
        'status': 'delivered',
      });
    });
  }
}
