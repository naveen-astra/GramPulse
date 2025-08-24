import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';

class StatusBanner extends StatelessWidget {
  final String status;
  final DateTime? slaDueAt;
  final double slaPercentage;
  
  const StatusBanner({
    super.key,
    required this.status,
    this.slaDueAt,
    required this.slaPercentage,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      color: _getStatusColor(status),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(status),
                color: Colors.white,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                _getStatusLabel(context, status),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (slaDueAt != null && status != 'closed' && status != 'rejected') ...[
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  _getSLAText(context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
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
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'new':
        return Icons.fiber_new;
      case 'assigned':
        return Icons.assignment_ind;
      case 'in_progress':
        return Icons.engineering;
      case 'resolved':
        return Icons.check_circle;
      case 'closed':
        return Icons.done_all;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
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
  
  String _getSLAText(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (slaPercentage >= 100) {
      // Calculate how many hours/days overdue
      final now = DateTime.now();
      final overdue = now.difference(slaDueAt!);
      
      if (overdue.inDays > 0) {
        return l10n.daysOverdue(overdue.inDays);
      } else {
        return l10n.hoursOverdue(overdue.inHours);
      }
    } else {
      // Calculate remaining time
      final now = DateTime.now();
      final remaining = slaDueAt!.difference(now);
      
      if (remaining.inDays > 0) {
        return l10n.daysRemaining(remaining.inDays);
      } else {
        return l10n.hoursRemaining(remaining.inHours);
      }
    }
  }
}
