import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/constants/spacing.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_bloc.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_event.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_state.dart';
import 'package:grampulse/features/volunteer/models/citizen_model.dart';
import 'package:grampulse/l10n/app_localizations.dart';

class CitizenInfoSection extends StatelessWidget {
  const CitizenInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.watch<AssistCitizenBloc>();
    final state = bloc.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            l10n.citizenDetails,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        _PhoneNumberInput(
          isValid: state is ReadyState || !(state is ErrorState && state.phoneError != null),
          initialValue: state is ReadyState ? state.phone : '',
          errorText: state is ErrorState && state.phoneError != null ? state.phoneError : null,
        ),
        const SizedBox(height: Spacing.md),
        if (state is ReadyState && state.recentCitizens.isNotEmpty) ...[
          _RecentCitizensList(citizens: state.recentCitizens),
          const SizedBox(height: Spacing.md),
        ],
        _NameInput(
          isValid: state is ReadyState || !(state is ErrorState && state.nameError != null),
          initialValue: state is ReadyState ? state.name : '',
          errorText: state is ErrorState && state.nameError != null ? state.nameError : null,
        ),
      ],
    );
  }
}

class _PhoneNumberInput extends StatefulWidget {
  final bool isValid;
  final String initialValue;
  final String? errorText;

  const _PhoneNumberInput({
    required this.isValid,
    required this.initialValue,
    this.errorText,
  });

  @override
  State<_PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<_PhoneNumberInput> {
  late final TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_PhoneNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && !_hasFocus) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.citizenPhone,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: Spacing.xs),
          Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _hasFocus = hasFocus;
              });
            },
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.phoneHint,
                helperText: l10n.citizenPhoneHelper,
                errorText: widget.errorText,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  tooltip: l10n.speakPhoneNumber,
                  onPressed: () {
                    // TODO: Implement speech-to-text for phone
                  },
                ),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) {
                context.read<AssistCitizenBloc>().add(PhoneChangedEvent(value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentCitizensList extends StatelessWidget {
  final List<CitizenModel> citizens;

  const _RecentCitizensList({required this.citizens});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            l10n.recentlyAssisted,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
            itemCount: citizens.length,
            itemBuilder: (context, index) {
              final citizen = citizens[index];
              return Padding(
                padding: const EdgeInsets.only(left: Spacing.sm),
                child: _CitizenChip(citizen: citizen),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CitizenChip extends StatelessWidget {
  final CitizenModel citizen;

  const _CitizenChip({required this.citizen});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          citizen.name.isNotEmpty ? citizen.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      label: Text(citizen.name),
      onPressed: () {
        context.read<AssistCitizenBloc>().add(CitizenSelectedEvent(citizen));
      },
    );
  }
}

class _NameInput extends StatefulWidget {
  final bool isValid;
  final String initialValue;
  final String? errorText;

  const _NameInput({
    required this.isValid,
    required this.initialValue,
    this.errorText,
  });

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  late final TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_NameInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && !_hasFocus) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.citizenName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: Spacing.xs),
          Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _hasFocus = hasFocus;
              });
            },
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.nameHint,
                errorText: widget.errorText,
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                context.read<AssistCitizenBloc>().add(NameChangedEvent(value));
              },
            ),
          ),
        ],
      ),
    );
  }
}
