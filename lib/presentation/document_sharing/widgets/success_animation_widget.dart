import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuccessAnimationWidget extends StatefulWidget {
  final bool isVisible;
  final String message;
  final VoidCallback? onAnimationComplete;

  const SuccessAnimationWidget({
    Key? key,
    this.isVisible = false,
    this.message = 'Document shared successfully!',
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<SuccessAnimationWidget> createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<SuccessAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SuccessAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimation();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _reverseAnimation();
    }
  }

  void _startAnimation() async {
    await _scaleController.forward();
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    widget.onAnimationComplete?.call();
  }

  void _reverseAnimation() async {
    await _fadeController.reverse();
    await _scaleController.reverse();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 12.w,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Success!',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.message,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
