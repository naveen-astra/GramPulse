import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

class AssignmentSection extends StatelessWidget {
  final OfficerModel? assignedOfficer;
  final String departmentName;
  final VoidCallback onReassign;
  
  const AssignmentSection({
    super.key,
    this.assignedOfficer,
    required this.departmentName,
    required this.onReassign,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(Spacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.assignment,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.md),
            
            // Department
            Row(
              children: [
                Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  l10n.department,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Text(
                    departmentName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.md),
            
            // Assigned Officer
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  l10n.assignedTo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: assignedOfficer != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignedOfficer!.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              assignedOfficer!.designation,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              assignedOfficer!.phone,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )
                      : Text(
                          l10n.notAssigned,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
                TextButton.icon(
                  onPressed: onReassign,
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(assignedOfficer != null
                      ? l10n.reassign
                      : l10n.assign),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
