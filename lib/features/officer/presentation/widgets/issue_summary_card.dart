import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';

class IssueSummaryCard extends StatelessWidget {
  final IssueModel issue;
  final bool showActions;

  const IssueSummaryCard({
    super.key,
    required this.issue,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryIcon(),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        issue.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Row(
                        children: [
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
                              _getStatusText(context, issue.status),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: _getStatusColor(issue.status),
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM yyyy').format(issue.dateReported),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            const Divider(),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    issue.location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  issue.submittedBy,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            
            if (showActions) ...[
              const SizedBox(height: Spacing.md),
              const Divider(),
              const SizedBox(height: Spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.check_circle_outline,
                    label: l10n.resolve,
                    onPressed: () {
                      // Navigation to resolve screen would happen here
                    },
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.assignment_outlined,
                    label: l10n.assignTask,
                    onPressed: () {
                      // Navigation to assign task screen would happen here
                    },
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.message_outlined,
                    label: l10n.contact,
                    onPressed: () {
                      // Navigation to contact citizen screen would happen here
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.report_problem_outlined,
        color: Colors.blue,
        size: 24,
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.amber;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    
    switch (status.toLowerCase()) {
      case 'pending':
        return l10n.pending;
      case 'in_progress':
      case 'inprogress':
      case 'in progress':
        return l10n.inProgress;
      case 'resolved':
        return l10n.resolved;
      case 'rejected':
        return l10n.rejected;
      default:
        return status;
    }
  }
}
