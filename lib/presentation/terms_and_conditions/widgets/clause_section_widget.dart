import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClauseSectionWidget extends StatefulWidget {
  final String title;
  final String content;
  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final bool isMandatory;
  final bool isAccepted;
  final ValueChanged<bool?>? onAcceptanceChanged;

  const ClauseSectionWidget({
    Key? key,
    required this.title,
    required this.content,
    this.isExpandable = true,
    this.isExpanded = false,
    this.onToggle,
    this.isMandatory = false,
    this.isAccepted = false,
    this.onAcceptanceChanged,
  }) : super(key: key);

  @override
  State<ClauseSectionWidget> createState() => _ClauseSectionWidgetState();
}

class _ClauseSectionWidgetState extends State<ClauseSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and expand/collapse button
          InkWell(
            onTap: widget.isExpandable ? widget.onToggle : null,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (widget.isMandatory)
                    Container(
                      margin: EdgeInsets.only(left: 2.w, right: 2.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Required',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (widget.isExpandable)
                    CustomIconWidget(
                      iconName:
                          widget.isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),

          // Content section (expandable)
          if (widget.isExpanded || !widget.isExpandable)
            Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isExpandable)
                    Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      height: 1,
                    ),
                  SizedBox(height: widget.isExpandable ? 2.h : 0),

                  // Content text
                  Text(
                    widget.content,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  // Acceptance checkbox for mandatory clauses
                  if (widget.isMandatory && widget.onAcceptanceChanged != null)
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: widget.isAccepted,
                            onChanged: widget.onAcceptanceChanged,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => widget.onAcceptanceChanged
                                  ?.call(!widget.isAccepted),
                              child: Text(
                                'I acknowledge and accept the terms outlined in this clause',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
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
