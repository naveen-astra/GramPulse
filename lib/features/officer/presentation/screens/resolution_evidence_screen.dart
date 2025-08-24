import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/presentation/widgets/app_bar_with_back_button.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/presentation/bloc/resolution_evidence/resolution_evidence_bloc.dart';
import 'package:grampulse/features/officer/presentation/bloc/resolution_evidence/resolution_evidence_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/resolution_evidence/resolution_evidence_state.dart';
import 'package:grampulse/features/officer/presentation/widgets/before_after_photo_section.dart';
import 'package:grampulse/features/officer/presentation/widgets/issue_summary_card.dart';
import 'package:grampulse/features/officer/presentation/widgets/resolution_details_form.dart';

class ResolutionEvidenceScreen extends StatefulWidget {
  final IssueModel issue;
  
  const ResolutionEvidenceScreen({
    super.key,
    required this.issue,
  });

  @override
  State<ResolutionEvidenceScreen> createState() => _ResolutionEvidenceScreenState();
}

class _ResolutionEvidenceScreenState extends State<ResolutionEvidenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _actionTakenController = TextEditingController();
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    _actionTakenController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider(
      create: (context) => ResolutionEvidenceBloc(
        repository: context.read<OfficerRepository>(),
        issue: widget.issue,
      ),
      child: BlocConsumer<ResolutionEvidenceBloc, ResolutionEvidenceState>(
        listener: (context, state) {
          if (state is ResolutionEvidenceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.resolutionSubmittedSuccessfully)),
            );
            Navigator.pop(context, state.issue);
          } else if (state is ResolutionEvidenceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.errorSubmittingResolution(state.errorMessage)),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<ResolutionEvidenceBloc>();
          
          return Scaffold(
            appBar: AppBarWithBackButton(
              title: l10n.addResolutionEvidence,
            ),
            body: _buildContent(context, state, bloc),
            bottomNavigationBar: _buildBottomButton(context, state, bloc),
          );
        },
      ),
    );
  }
  
  Widget _buildContent(
    BuildContext context, 
    ResolutionEvidenceState state,
    ResolutionEvidenceBloc bloc,
  ) {
    if (state is ResolutionEvidenceSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state is! ResolutionEvidenceInitial) {
      return Center(child: Text(AppLocalizations.of(context).errorLoadingData));
    }
    
    final initialState = state;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IssueSummaryCard(issue: initialState.issue),
          const SizedBox(height: Spacing.lg),
          
          ResolutionDetailsForm(
            descriptionController: _descriptionController,
            costController: _costController,
            actionTakenController: _actionTakenController,
            completionDate: initialState.completionDate,
            onCompletionDateChanged: (date) {
              bloc.add(UpdateCompletionDateEvent(date));
            },
            formKey: _formKey,
          ),
          
          BeforeAfterPhotoSection(
            beforePhotos: initialState.beforePhotos,
            newBeforePhotos: initialState.newBeforePhotos,
            afterPhotos: initialState.afterPhotos,
            newAfterPhotos: initialState.newAfterPhotos,
            onAddBeforePhoto: (File photo) {
              bloc.add(AddBeforePhotoEvent(photo));
            },
            onRemoveBeforePhoto: (photo) {
              bloc.add(RemoveBeforePhotoEvent(photo));
            },
            onRemoveNewBeforePhoto: (photo) {
              bloc.add(RemoveNewBeforePhotoEvent(photo));
            },
            onAddAfterPhoto: (File photo) {
              bloc.add(AddAfterPhotoEvent(photo));
            },
            onRemoveAfterPhoto: (photo) {
              bloc.add(RemoveAfterPhotoEvent(photo));
            },
            onRemoveNewAfterPhoto: (photo) {
              bloc.add(RemoveNewAfterPhotoEvent(photo));
            },
          ),
          
          // Bottom padding to avoid button overlap
          const SizedBox(height: 80),
        ],
      ),
    );
  }
  
  Widget _buildBottomButton(
    BuildContext context, 
    ResolutionEvidenceState state,
    ResolutionEvidenceBloc bloc,
  ) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = state is ResolutionEvidenceSubmitting;
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        Spacing.md, 
        Spacing.sm, 
        Spacing.md, 
        Spacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isSubmitting 
              ? null 
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final costText = _costController.text.trim();
                    double? cost;
                    if (costText.isNotEmpty) {
                      cost = double.tryParse(costText);
                    }
                    
                    bloc.add(SubmitResolutionEvent(
                      description: _descriptionController.text.trim(),
                      cost: cost,
                      actionTaken: _actionTakenController.text.trim().isEmpty 
                          ? null 
                          : _actionTakenController.text.trim(),
                    ));
                  }
                },
          icon: const Icon(Icons.check_circle_outline),
          label: Text(l10n.submitResolution),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(Spacing.md),
          ),
        ),
      ),
    );
  }
}
