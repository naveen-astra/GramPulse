import 'package:flutter/material.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class BatchActionBar extends StatelessWidget {
  final int selectedCount;
  final Function(String) onBatchAction;
  final VoidCallback onClearSelection;
  
  const BatchActionBar({
    Key? key,
    required this.selectedCount,
    required this.onBatchAction,
    required this.onClearSelection,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            l10n.selectedCount.replaceAll('{}', selectedCount.toString()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: onClearSelection,
            child: Text(l10n.clearSelection),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: Spacing.md),
          PopupMenuButton<String>(
            onSelected: onBatchAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'assign',
                child: Text(l10n.assignSelected),
              ),
              PopupMenuItem(
                value: 'update_status',
                child: Text(l10n.updateStatus),
              ),
              PopupMenuItem(
                value: 'export',
                child: Text(l10n.exportData),
              ),
            ],
            child: FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.more_vert),
              label: const Text('Batch Actions'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
