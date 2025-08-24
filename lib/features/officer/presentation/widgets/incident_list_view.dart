import 'package:flutter/material.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class IncidentListView extends StatelessWidget {
  final List<OfficerIssueModel> issues;
  final String sortField;
  final bool sortAscending;
  final Function(OfficerIssueModel) onTap;
  final Function(OfficerIssueModel, String) onQuickAction;
  final Function(String, bool) onSort;
  final Set<String> selectedIds;
  final Function(String, bool) onSelect;
  
  const IncidentListView({
    Key? key,
    required this.issues,
    required this.sortField,
    required this.sortAscending,
    required this.onTap,
    required this.onQuickAction,
    required this.onSort,
    required this.selectedIds,
    required this.onSelect,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: issues.isNotEmpty && 
                             selectedIds.length == issues.length,
                      onChanged: (value) {
                        if (value == true) {
                          // Select all
                          issues.forEach((issue) {
                            onSelect(issue.id, true);
                          });
                        } else {
                          // Deselect all
                          issues.forEach((issue) {
                            onSelect(issue.id, false);
                          });
                        }
                      },
                      tristate: selectedIds.isNotEmpty && 
                               selectedIds.length < issues.length,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(l10n.all),
                ],
              ),
              onSort: (columnIndex, ascending) => onSort('id', ascending),
              tooltip: 'ID',
            ),
            DataColumn(
              label: Text(l10n.category),
              onSort: (columnIndex, ascending) => onSort('category', ascending),
              tooltip: l10n.category,
            ),
            DataColumn(
              label: Text('Title'),
              onSort: (columnIndex, ascending) => onSort('title', ascending),
              tooltip: 'Title',
            ),
            DataColumn(
              label: Text(l10n.status),
              onSort: (columnIndex, ascending) => onSort('status', ascending),
              tooltip: l10n.status,
            ),
            DataColumn(
              label: Text('SLA'),
              onSort: (columnIndex, ascending) => onSort('sla', ascending),
              tooltip: 'SLA',
            ),
            DataColumn(
              label: Text('Actions'),
              tooltip: 'Actions',
            ),
          ],
          rows: issues.map((issue) {
            return DataRow(
              selected: selectedIds.contains(issue.id),
              onSelectChanged: (selected) {
                if (selected != null) {
                  onSelect(issue.id, selected);
                }
              },
              cells: [
                DataCell(
                  Text('#${issue.id.substring(0, 8)}'),
                  onTap: () => onTap(issue),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: issue.category.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      issue.category.name,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: issue.category.color,
                      ),
                    ),
                  ),
                  onTap: () => onTap(issue),
                ),
                DataCell(
                  Text(
                    issue.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onTap(issue),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(issue.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(context, issue.status),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(issue.status),
                      ),
                    ),
                  ),
                  onTap: () => onTap(issue),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getSLAColor(issue.slaPercentage).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 12,
                          color: _getSLAColor(issue.slaPercentage),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          _getSLAText(context, issue),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _getSLAColor(issue.slaPercentage),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => onTap(issue),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildActionButtons(context, issue),
                  ),
                ),
              ],
            );
          }).toList(),
          sortColumnIndex: _getSortColumnIndex(sortField),
          sortAscending: sortAscending,
        ),
      ),
    );
  }
  
  int? _getSortColumnIndex(String field) {
    switch (field) {
      case 'id':
        return 0;
      case 'category':
        return 1;
      case 'title':
        return 2;
      case 'status':
        return 3;
      case 'sla':
        return 4;
      default:
        return null;
    }
  }
  
  List<Widget> _buildActionButtons(BuildContext context, OfficerIssueModel issue) {
    final actions = <Widget>[];
    final l10n = AppLocalizations.of(context);
    
    switch (issue.status) {
      case 'new':
        actions.add(
          IconButton(
            icon: const Icon(Icons.assignment_ind, size: 16),
            tooltip: 'Assign',
            onPressed: () => onQuickAction(issue, 'assign'),
            visualDensity: VisualDensity.compact,
          ),
        );
        break;
      case 'assigned':
      case 'in_progress':
        actions.add(
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 16),
            tooltip: 'Resolve',
            onPressed: () => onQuickAction(issue, 'resolve'),
            visualDensity: VisualDensity.compact,
          ),
        );
        break;
      case 'resolved':
        actions.add(
          IconButton(
            icon: const Icon(Icons.done_all, size: 16),
            tooltip: 'Close',
            onPressed: () => onQuickAction(issue, 'close'),
            visualDensity: VisualDensity.compact,
          ),
        );
        break;
    }
    
    // View details is always available
    actions.add(
      IconButton(
        icon: const Icon(Icons.visibility, size: 16),
        tooltip: l10n.viewDetails,
        onPressed: () => onTap(issue),
        visualDensity: VisualDensity.compact,
      ),
    );
    
    return actions;
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
  
  Color _getSLAColor(double percentage) {
    if (percentage >= 100) {
      return Colors.red;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
  
  String _getSLAText(BuildContext context, OfficerIssueModel issue) {
    if (issue.slaPercentage >= 100) {
      // Calculate how many hours/days overdue
      final now = DateTime.now();
      final overdue = now.difference(issue.slaDueAt!);
      
      if (overdue.inDays > 0) {
        return '${overdue.inDays}d overdue';
      } else {
        return '${overdue.inHours}h overdue';
      }
    } else {
      // Calculate remaining time
      final now = DateTime.now();
      final remaining = issue.slaDueAt!.difference(now);
      
      if (remaining.inDays > 0) {
        return '${remaining.inDays}d left';
      } else {
        return '${remaining.inHours}h left';
      }
    }
  }
}
