import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_bloc.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_event.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_state.dart';
import 'package:grampulse/features/volunteer/widgets/citizen_info_section.dart';
import 'package:grampulse/features/volunteer/widgets/consent_checkbox.dart';
import 'package:grampulse/features/volunteer/widgets/instructions_card.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class AssistCitizenScreen extends StatelessWidget {
  const AssistCitizenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider(
      create: (context) => AssistCitizenBloc()..add(InitEvent()),
      child: Builder(
        builder: (context) {
          final state = context.watch<AssistCitizenBloc>().state;
          final isLoading = state is LoadingState || state is ValidatingState;

          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.assistCitizen),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Spacing.sm),
                  const InstructionsCard(),
                  const SizedBox(height: Spacing.md),
                  const CitizenInfoSection(),
                  const SizedBox(height: Spacing.md),
                  const ConsentCheckbox(),
                  const SizedBox(height: Spacing.xl),
                  _buildBottomButton(context, l10n, state),
                ],
              ),
            ),
            // Show loading overlay when validating input or processing
            bottomSheet: isLoading
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, AppLocalizations l10n, AssistCitizenState state) {
    final bool isEnabled = state is ReadyState && 
                         state.isPhoneValid &&
                         state.isNameValid &&
                         state.hasConsent;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: isEnabled
              ? () {
                  context.read<AssistCitizenBloc>().add(ContinueToReportEvent());
                  // Navigation will be handled in BLoC
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            child: Text(l10n.continueToReport),
          ),
        ),
      ),
    );
  }
}
