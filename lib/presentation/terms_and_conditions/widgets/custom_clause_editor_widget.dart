import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomClauseEditorWidget extends StatefulWidget {
  final String initialText;
  final ValueChanged<String> onTextChanged;
  final int maxCharacters;

  const CustomClauseEditorWidget({
    Key? key,
    this.initialText = '',
    required this.onTextChanged,
    this.maxCharacters = 1000,
  }) : super(key: key);

  @override
  State<CustomClauseEditorWidget> createState() =>
      _CustomClauseEditorWidgetState();
}

class _CustomClauseEditorWidgetState extends State<CustomClauseEditorWidget> {
  late TextEditingController _textController;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isBulletMode = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onTextChanged(_textController.text);
  }

  void _insertBulletPoint() {
    final text = _textController.text;
    final selection = _textController.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '• ',
    );
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + 2),
    );
  }

  void _clearText() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = _textController.text.length;
    final isNearLimit = currentLength > (widget.maxCharacters * 0.8);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'edit_note',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Custom Clauses',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                Text(
                  '$currentLength/${widget.maxCharacters}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isNearLimit
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Formatting toolbar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Bold button
                _FormatButton(
                  icon: 'format_bold',
                  isActive: _isBold,
                  onPressed: () => setState(() => _isBold = !_isBold),
                  tooltip: 'Bold',
                ),
                SizedBox(width: 2.w),

                // Italic button
                _FormatButton(
                  icon: 'format_italic',
                  isActive: _isItalic,
                  onPressed: () => setState(() => _isItalic = !_isItalic),
                  tooltip: 'Italic',
                ),
                SizedBox(width: 2.w),

                // Bullet point button
                _FormatButton(
                  icon: 'format_list_bulleted',
                  isActive: _isBulletMode,
                  onPressed: () {
                    setState(() => _isBulletMode = !_isBulletMode);
                    if (_isBulletMode) _insertBulletPoint();
                  },
                  tooltip: 'Bullet Point',
                ),

                Spacer(),

                // Clear button
                IconButton(
                  onPressed:
                      _textController.text.isNotEmpty ? _clearText : null,
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: _textController.text.isNotEmpty
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                    size: 20,
                  ),
                  tooltip: 'Clear All',
                  padding: EdgeInsets.all(1.w),
                  constraints: BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                ),
              ],
            ),
          ),

          // Text editor
          Container(
            constraints: BoxConstraints(
              minHeight: 20.h,
              maxHeight: 30.h,
            ),
            child: TextField(
              controller: _textController,
              maxLength: widget.maxCharacters,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: _isBold ? FontWeight.w600 : FontWeight.w400,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText:
                    'Add your custom rental terms and conditions here...\n\nExample:\n• Late return penalty: ₹500 per hour\n• Smoking in vehicle: ₹2000 fine\n• Pet policy: Additional ₹1000 cleaning fee',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String icon;
  final bool isActive;
  final VoidCallback onPressed;
  final String tooltip;

  const _FormatButton({
    Key? key,
    required this.icon,
    required this.isActive,
    required this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 18,
          ),
        ),
      ),
    );
  }
}
