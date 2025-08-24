import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ResolutionDetailsForm extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController costController;
  final TextEditingController actionTakenController;
  final DateTime? completionDate;
  final ValueChanged<DateTime?> onCompletionDateChanged;
  final GlobalKey<FormState> formKey;
  
  const ResolutionDetailsForm({
    super.key,
    required this.descriptionController,
    required this.costController,
    required this.actionTakenController,
    this.completionDate,
    required this.onCompletionDateChanged,
    required this.formKey,
  });

  @override
  State<ResolutionDetailsForm> createState() => _ResolutionDetailsFormState();
}

class _ResolutionDetailsFormState extends State<ResolutionDetailsForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.resolutionDetails,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Spacing.md),
          
          // Description field
          TextFormField(
            controller: widget.descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            maxLength: 500,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.fieldRequired;
              }
              if (value.length < 10) {
                return l10n.descriptionTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: Spacing.md),
          
          // Action taken field
          TextFormField(
            controller: widget.actionTakenController,
            decoration: InputDecoration(
              labelText: l10n.actionTaken,
              border: const OutlineInputBorder(),
              hintText: l10n.actionTakenHint,
            ),
            maxLines: 2,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Spacing.md),
          
          // Cost field
          TextFormField(
            controller: widget.costController,
            decoration: InputDecoration(
              labelText: l10n.cost,
              border: const OutlineInputBorder(),
              hintText: l10n.costHint,
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Spacing.md),
          
          // Completion date field
          _buildDatePicker(context),
          const SizedBox(height: Spacing.md),
        ],
      ),
    );
  }
  
  Widget _buildDatePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final completionDate = widget.completionDate;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.completionDate,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Spacing.xs),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (completionDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.onCompletionDateChanged(null);
                      },
                      iconSize: 20,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                    ),
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: Spacing.sm),
                ],
              ),
            ),
            isEmpty: completionDate == null,
            child: completionDate != null
                ? Text(
                    DateFormat('dd MMM yyyy').format(completionDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Text(
                    l10n.selectDate,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.completionDate ?? currentDate,
      firstDate: currentDate.subtract(const Duration(days: 365)),
      lastDate: currentDate,
      helpText: l10n.selectCompletionDate,
      cancelText: l10n.cancel,
      confirmText: l10n.confirm,
    );
    
    if (pickedDate != null && pickedDate != widget.completionDate) {
      widget.onCompletionDateChanged(pickedDate);
    }
  }
}
