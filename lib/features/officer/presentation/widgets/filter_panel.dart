import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/map/domain/models/category_model.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class FilterPanel extends StatelessWidget {
  final Map<String, dynamic> filters;
  final List<CategoryModel> categories;
  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onResetFilters;
  
  const FilterPanel({
    Key? key,
    required this.filters,
    required this.categories,
    required this.onApplyFilters,
    required this.onResetFilters,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Local copy of filters for temporary changes
    final localFilters = Map<String, dynamic>.from(filters);
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status filter
              Text(
                l10n.status,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                children: [
                  'all',
                  'new',
                  'assigned',
                  'in_progress',
                  'resolved',
                  'closed',
                  'rejected',
                ].map((status) {
                  final isSelected = localFilters['status'] == status || 
                                    (status == 'all' && localFilters['status'] == null);
                  
                  return FilterChip(
                    label: Text(_getStatusLabel(context, status)),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        localFilters['status'] = status == 'all' ? null : status;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: _getStatusColor(status).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? _getStatusColor(status)
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: Spacing.md),
              
              // Category filter
              Text(
                l10n.category,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              DropdownButtonFormField<String?>(
                value: localFilters['categoryId'],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<String?>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    localFilters['categoryId'] = value;
                  });
                },
              ),
              
              const SizedBox(height: Spacing.md),
              
              // SLA filter
              Text(
                l10n.slaStatus,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              DropdownButtonFormField<String?>(
                value: localFilters['slaStatus'],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'breached',
                    child: Text(l10n.slaBreached),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'at_risk',
                    child: Text(l10n.slaAtRisk),
                  ),
                  DropdownMenuItem<String?>(
                    value: 'on_track',
                    child: Text(l10n.slaOnTrack),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    localFilters['slaStatus'] = value;
                  });
                },
              ),
              
              const SizedBox(height: Spacing.md),
              
              // Date range
              Text(
                l10n.dateRange,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: localFilters['startDate'] != null
                          ? DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(localFilters['startDate']),
                            )
                          : '',
                      decoration: InputDecoration(
                        labelText: l10n.startDate,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        isDense: true,
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: localFilters['startDate'] != null
                              ? DateTime.parse(localFilters['startDate'])
                              : DateTime.now().subtract(const Duration(days: 30)),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        
                        if (date != null) {
                          setState(() {
                            localFilters['startDate'] = date.toIso8601String();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: TextFormField(
                      initialValue: localFilters['endDate'] != null
                          ? DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(localFilters['endDate']),
                            )
                          : '',
                      decoration: InputDecoration(
                        labelText: l10n.endDate,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        isDense: true,
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: localFilters['endDate'] != null
                              ? DateTime.parse(localFilters['endDate'])
                              : DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        
                        if (date != null) {
                          setState(() {
                            localFilters['endDate'] = date.toIso8601String();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: Spacing.xl),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onResetFilters,
                      child: Text(l10n.resetFilters),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => onApplyFilters(localFilters),
                      child: Text(l10n.applyFilters),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'assigned':
        return Colors.purple;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusLabel(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case 'all':
        return l10n.all;
      case 'new':
        return l10n.new_;
      case 'assigned':
        return l10n.assigned;
      case 'in_progress':
        return l10n.inProgress;
      case 'resolved':
        return l10n.resolved;
      case 'closed':
        return l10n.closed;
      case 'rejected':
        return l10n.rejected;
      default:
        return status;
    }
  }
}
