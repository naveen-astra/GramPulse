import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_event.dart';
import 'package:grampulse/features/volunteer/bloc/assist_citizen_state.dart';
import 'package:grampulse/features/volunteer/models/citizen_model.dart';

class AssistCitizenBloc extends Bloc<AssistCitizenEvent, AssistCitizenState> {
  AssistCitizenBloc() : super(InitialState()) {
    on<InitEvent>(_onInit);
    on<PhoneChangedEvent>(_onPhoneChanged);
    on<NameChangedEvent>(_onNameChanged);
    on<CitizenSelectedEvent>(_onCitizenSelected);
    on<ConsentChangedEvent>(_onConsentChanged);
    on<ContinueToReportEvent>(_onContinueToReport);
  }

  final RegExp _phoneRegex = RegExp(r'^\d{10}$');

  void _onInit(InitEvent event, Emitter<AssistCitizenState> emit) async {
    emit(LoadingState());

    try {
      // TODO: Fetch recently assisted citizens from repository
      final recentCitizens = [
        CitizenModel(id: '1', name: 'John Doe', phone: '9876543210', lastAssistedAt: DateTime.now().subtract(const Duration(days: 2)), assistCount: 1),
        CitizenModel(id: '2', name: 'Jane Smith', phone: '9876543211', lastAssistedAt: DateTime.now().subtract(const Duration(days: 7)), assistCount: 2),
      ];

      emit(ReadyState(
        phone: '',
        name: '',
        recentCitizens: recentCitizens,
        isPhoneValid: false,
        isNameValid: false,
        hasConsent: false,
      ));
    } catch (e) {
      emit(ErrorState(message: 'Failed to load data'));
    }
  }

  void _onPhoneChanged(PhoneChangedEvent event, Emitter<AssistCitizenState> emit) {
    final currentState = state;
    if (currentState is ReadyState) {
      final isValid = _isPhoneValid(event.phone);
      emit(currentState.copyWith(
        phone: event.phone,
        isPhoneValid: isValid,
      ));
    }
  }

  void _onNameChanged(NameChangedEvent event, Emitter<AssistCitizenState> emit) {
    final currentState = state;
    if (currentState is ReadyState) {
      final isValid = _isNameValid(event.name);
      emit(currentState.copyWith(
        name: event.name,
        isNameValid: isValid,
      ));
    }
  }

  void _onCitizenSelected(CitizenSelectedEvent event, Emitter<AssistCitizenState> emit) {
    final currentState = state;
    if (currentState is ReadyState) {
      emit(currentState.copyWith(
        phone: event.citizen.phone,
        name: event.citizen.name,
        isPhoneValid: _isPhoneValid(event.citizen.phone),
        isNameValid: _isNameValid(event.citizen.name),
      ));
    }
  }

  void _onConsentChanged(ConsentChangedEvent event, Emitter<AssistCitizenState> emit) {
    final currentState = state;
    if (currentState is ReadyState) {
      emit(currentState.copyWith(
        hasConsent: event.hasConsent,
      ));
    }
  }

  void _onContinueToReport(ContinueToReportEvent event, Emitter<AssistCitizenState> emit) async {
    final currentState = state;
    if (currentState is ReadyState && 
        currentState.isPhoneValid && 
        currentState.isNameValid && 
        currentState.hasConsent) {
          
      emit(ValidatingState());

      try {
        // TODO: Save citizen data and navigate to report screen
        // For now, we just simulate a delay
        await Future.delayed(const Duration(seconds: 1));
        
        // TODO: Navigate to report screen
        // The navigation will be handled by a listener in the UI
        
        // Return to ready state with same data
        emit(currentState);
      } catch (e) {
        emit(ErrorState(
          message: 'Failed to process request',
          phoneError: null,
          nameError: null,
        ));
      }
    }
  }

  bool _isPhoneValid(String phone) {
    return _phoneRegex.hasMatch(phone);
  }

  bool _isNameValid(String name) {
    return name.trim().isNotEmpty;
  }
}
