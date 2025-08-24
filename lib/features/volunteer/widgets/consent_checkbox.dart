import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_bloc.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_event.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_state.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class ConsentCheckbox extends StatelessWidget {
  const ConsentCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.watch<AssistCitizenBloc>();
    final state = bloc.state;
    final isChecked = state is ReadyState ? state.hasConsent : false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: (value) {
                if (value != null) {
                  context.read<AssistCitizenBloc>().add(ConsentChangedEvent(value));
                }
              },
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              l10n.citizenConsentText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
