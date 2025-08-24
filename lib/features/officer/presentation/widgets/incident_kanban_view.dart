import 'package:flutter/material.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class IncidentKanbanView extends StatelessWidget {
  final List<OfficerIssueModel> issues;
  final Function(OfficerIssueModel) onTap;
  final Function(OfficerIssueModel, String) onStatusChange;
  
  const IncidentKanbanView({
    Key? key,
    required this.issues,
    required this.onTap,
    required this.onStatusChange,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Group issues by status
    final Map<String, List<OfficerIssueModel>> issuesByStatus = {
      'new': [],
      'assigned': [],
      'in_progress': [],
      'resolved': [],
      'closed': [],
      'rejected': [],
    };
    
    for (final issue in issues) {
      if (issuesByStatus.containsKey(issue.status)) {
        issuesByStatus[issue.status]!.add(issue);
      } else {
        // Fallback for unknown statuses
        issuesByStatus['new']!.add(issue);
      }
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: issuesByStatus.entries.map((entry) {
          return KanbanColumn(
            status: entry.key,
            issues: entry.value,
            onTap: onTap,
            onStatusChange: onStatusChange,
          );
        }).toList(),
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final String status;
  final List<OfficerIssueModel> issues;
  final Function(OfficerIssueModel) onTap;
  final Function(OfficerIssueModel, String) onStatusChange;
  
  const KanbanColumn({
    Key? key,
    required this.status,
    required this.issues,
    required this.onTap,
    required this.onStatusChange,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      width: 300,
      margin: const EdgeInsets.all(Spacing.sm),
      child: Column(
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: _getStatusColor(status),
                  child: Text(
                    issues.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  _getStatusLabel(context, status),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(status),
                  ),
                ),
              ],
            ),
          ),
          
          // Issue cards
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            constraints: const BoxConstraints(
              minHeight: 400,
            ),
            child: DragTarget<Map<String, dynamic>>(
              onAccept: (data) {
                final issue = data['issue'] as OfficerIssueModel;
                if (issue.status != status) {
                  onStatusChange(issue, status);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.sm),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    return KanbanCard(
                      issue: issues[index],
                      onTap: onTap,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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

class KanbanCard extends StatelessWidget {
  final OfficerIssueModel issue;
  final Function(OfficerIssueModel) onTap;
  
  const KanbanCard({
    Key? key,
    required this.issue,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Draggable<Map<String, dynamic>>(
      data: {'issue': issue},
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '#${issue.id.substring(0, 8)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(issue.priority).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getPriorityLabel(context, issue.priority),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getPriorityColor(issue.priority),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                issue.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: Spacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          child: const SizedBox(
            width: double.infinity,
            height: 100,
          ),
        ),
      ),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: Spacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        child: InkWell(
          onTap: () => onTap(issue),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${issue.id.substring(0, 8)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(issue.priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPriorityLabel(context, issue.priority),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getPriorityColor(issue.priority),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  issue.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: issue.category.color.withOpacity(0.2),
                      child: Icon(
                        IconData(
                          int.parse(issue.category.iconCode),
                          fontFamily: 'MaterialIcons',
                        ),
                        color: issue.category.color,
                        size: 10,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        issue.category.name,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                if (issue.slaDueAt != null)
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
                          size: 10,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  String _getPriorityLabel(BuildContext context, String priority) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case 'high':
        return l10n.high;
      case 'medium':
        return l10n.medium;
      case 'low':
        return l10n.low;
      default:
        return priority;
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
