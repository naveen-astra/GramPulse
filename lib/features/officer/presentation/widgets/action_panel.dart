import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

class ActionPanel extends StatefulWidget {
  final String currentStatus;
  final OfficerModel? assignedOfficer;
  final String notes;
  final Function(String) onStatusChanged;
  final Function(String) onNotesChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  
  const ActionPanel({
    super.key,
    required this.currentStatus,
    this.assignedOfficer,
    required this.notes,
    required this.onStatusChanged,
    required this.onNotesChanged,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  State<ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends State<ActionPanel> {
  late String selectedStatus;
  
  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availableStatuses = _getAvailableStatuses(widget.currentStatus);
    
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
              l10n.takeAction,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.md),
            
            // Status update
            Text(
              l10n.changeStatus,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
              ),
              items: availableStatuses.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Text(_getStatusLabel(context, status)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                  widget.onStatusChanged(value);
                }
              },
            ),
            
            const SizedBox(height: Spacing.md),
            
            // Notes
            Text(
              l10n.addNotes,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            TextField(
              onChanged: widget.onNotesChanged,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.notesHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const SizedBox(height: Spacing.xl),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isSubmitting ? null : widget.onSubmit,
                child: widget.isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(l10n.updateIncident),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<String> _getAvailableStatuses(String currentStatus) {
    switch (currentStatus) {
      case 'new':
        return ['new', 'assigned', 'rejected'];
      case 'assigned':
        return ['assigned', 'in_progress', 'rejected'];
      case 'in_progress':
        return ['in_progress', 'resolved', 'rejected'];
      case 'resolved':
        return ['resolved', 'closed', 'in_progress'];
      case 'closed':
        return ['closed'];
      case 'rejected':
        return ['rejected', 'new'];
      default:
        return [currentStatus];
    }
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
