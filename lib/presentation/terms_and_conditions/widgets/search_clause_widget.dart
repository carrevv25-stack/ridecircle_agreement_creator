import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchClauseWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onClearSearch;

  const SearchClauseWidget({
    Key? key,
    required this.onSearchChanged,
    this.onClearSearch,
  }) : super(key: key);

  @override
  State<SearchClauseWidget> createState() => _SearchClauseWidgetState();
}

class _SearchClauseWidgetState extends State<SearchClauseWidget> {
  late TextEditingController _searchController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final searchText = _searchController.text;
    setState(() {
      _isSearchActive = searchText.isNotEmpty;
    });
    widget.onSearchChanged(searchText);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: _isSearchActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),

          // Search input field
          Expanded(
            child: TextField(
              controller: _searchController,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search terms and conditions...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                // Handle search submission if needed
              },
            ),
          ),

          // Clear button (shown when search is active)
          if (_isSearchActive)
            IconButton(
              onPressed: _clearSearch,
              icon: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: BoxConstraints(minWidth: 8.w, minHeight: 4.h),
              tooltip: 'Clear search',
            ),

          // Filter button (optional for future enhancement)
          if (!_isSearchActive)
            IconButton(
              onPressed: () {
                // Handle filter options if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Filter options coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: BoxConstraints(minWidth: 8.w, minHeight: 4.h),
              tooltip: 'Filter clauses',
            ),
        ],
      ),
    );
  }
}
