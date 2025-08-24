import 'package:flutter/material.dart';
import 'package:grampulse/l10n/app_localizations.dart';
import 'package:grampulse/core/constants/spacing.dart';

class InstructionsCard extends StatelessWidget {
  const InstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.howToAssist,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            l10n.assistStep1,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.assistStep2,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.assistStep3,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.assistStep4,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
