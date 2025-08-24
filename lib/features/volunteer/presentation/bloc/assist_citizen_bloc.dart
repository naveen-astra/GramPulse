import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/volunteer/domain/models/citizen_model.dart';
import 'package:grampulse/features/volunteer/presentation/bloc/assist_citizen_event.dart';
import 'package:grampulse/features/volunteer/presentation/bloc/assist_citizen_state.dart';

class AssistCitizenBloc extends Bloc<AssistCitizenEvent, AssistCitizenState> {
  AssistCitizenBloc() : super(const AssistInitial()) {
    on<LoadAssistCitizenScreen>(_onLoadScreen);
    on<PhoneChangedEvent>(_onPhoneChanged);
    on<NameChangedEvent>(_onNameChanged);
    on<CitizenSelectedEvent>(_onCitizenSelected);
    on<ContinueToReportEvent>(_onContinueToReport);
  }

  Future<void> _onLoadScreen(
    LoadAssistCitizenScreen event,
    Emitter<AssistCitizenState> emit,
  ) async {
    emit(AssistLoading(recentCitizens: state.recentCitizens));
    
    try {
      // Fetch recent citizens from repository (mocked for now)
      final recentCitizens = await _fetchRecentCitizens();
      emit(AssistInitial(recentCitizens: recentCitizens));
    } catch (e) {
      emit(AssistError(error: e.toString(), recentCitizens: state.recentCitizens));
    }
  }

  Future<void> _onPhoneChanged(
    PhoneChangedEvent event,
    Emitter<AssistCitizenState> emit,
  ) async {
    if (event.phone.length == 10) {
      emit(AssistValidating(
        phone: event.phone,
        recentCitizens: state.recentCitizens,
        selectedCitizen: state.selectedCitizen,
      ));
      
      try {
        // Check if phone exists in system (mocked for now)
        final existingCitizen = await _checkPhoneExists(event.phone);
        
        if (existingCitizen != null) {
          emit(AssistReady(
            citizen: existingCitizen,
            recentCitizens: state.recentCitizens,
          ));
        } else {
          // If phone doesn't exist, keep the state but allow user to enter name
          emit(AssistInitial(recentCitizens: state.recentCitizens));
        }
      } catch (e) {
        emit(AssistError(
          error: e.toString(),
          recentCitizens: state.recentCitizens,
          selectedCitizen: state.selectedCitizen,
        ));
      }
    } else {
      // If phone is not 10 digits, reset selection
      emit(AssistInitial(recentCitizens: state.recentCitizens));
    }
  }

  void _onNameChanged(
    NameChangedEvent event,
    Emitter<AssistCitizenState> emit,
  ) {
    // Update the selected citizen with new name if it exists
    if (state.selectedCitizen != null) {
      final updatedCitizen = state.selectedCitizen!.copyWith(name: event.name);
      emit(AssistReady(
        citizen: updatedCitizen,
        recentCitizens: state.recentCitizens,
      ));
    }
  }

  void _onCitizenSelected(
    CitizenSelectedEvent event,
    Emitter<AssistCitizenState> emit,
  ) {
    emit(AssistReady(
      citizen: event.citizen,
      recentCitizens: state.recentCitizens,
    ));
  }

  Future<void> _onContinueToReport(
    ContinueToReportEvent event,
    Emitter<AssistCitizenState> emit,
  ) async {
    emit(AssistLoading(
      recentCitizens: state.recentCitizens,
      selectedCitizen: state.selectedCitizen,
    ));
    
    try {
      // Process the selected or new citizen data
      final citizen = state.selectedCitizen != null
          ? state.selectedCitizen!
          : CitizenModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: event.name,
              phone: event.phone,
              lastAssistedAt: DateTime.now(),
              assistCount: 1,
            );
      
      // In a real app, we'd save this to the database here
      
      emit(AssistReady(
        citizen: citizen,
        recentCitizens: state.recentCitizens,
      ));
    } catch (e) {
      emit(AssistError(
        error: e.toString(),
        recentCitizens: state.recentCitizens,
        selectedCitizen: state.selectedCitizen,
      ));
    }
  }
  
  // Mock data functions (in a real app, these would interact with a repository)
  Future<List<CitizenModel>> _fetchRecentCitizens() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock data
    return [
      CitizenModel(
        id: '1',
        name: 'Rajesh Kumar',
        phone: '9876543210',
        lastAssistedAt: DateTime.now().subtract(const Duration(days: 2)),
        assistCount: 3,
      ),
      CitizenModel(
        id: '2',
        name: 'Lakshmi Devi',
        phone: '8765432109',
        lastAssistedAt: DateTime.now().subtract(const Duration(days: 5)),
        assistCount: 1,
      ),
      CitizenModel(
        id: '3',
        name: 'Mohan Singh',
        phone: '7654321098',
        lastAssistedAt: DateTime.now().subtract(const Duration(days: 7)),
        assistCount: 2,
      ),
      CitizenModel(
        id: '4',
        name: 'Anita Patel',
        phone: '6543210987',
        lastAssistedAt: DateTime.now().subtract(const Duration(days: 10)),
        assistCount: 1,
      ),
    ];
  }
  
  Future<CitizenModel?> _checkPhoneExists(String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Check if phone exists in recent citizens
    if (state.recentCitizens != null) {
      return state.recentCitizens!.firstWhere(
        (citizen) => citizen.phone == phone,
        orElse: () => CitizenModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '',
          phone: phone,
          lastAssistedAt: DateTime.now(),
        ),
      );
    }
    
    return null;
  }
}
