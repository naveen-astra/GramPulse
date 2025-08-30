import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/officer_api_service.dart';
import 'officer_event.dart';
import 'officer_state.dart';

class OfficerBloc extends Bloc<OfficerEvent, OfficerState> {
  final OfficerApiService _apiService = OfficerApiService();

  OfficerBloc() : super(const OfficerInitial()) {
    on<OfficerRequestOTP>(_onRequestOTP);
    on<OfficerVerifyOTP>(_onVerifyOTP);
    on<OfficerLoadProfile>(_onLoadProfile);
    on<OfficerLoadDashboard>(_onLoadDashboard);
    on<OfficerLoadIncidents>(_onLoadIncidents);
    on<OfficerUpdateAssignmentStatus>(_onUpdateAssignmentStatus);
    on<OfficerLoadDepartments>(_onLoadDepartments);
    on<OfficerLoadCategories>(_onLoadCategories);
    on<OfficerLogout>(_onLogout);
  }

  Future<void> _onRequestOTP(OfficerRequestOTP event, Emitter<OfficerState> emit) async {
    emit(const OfficerAuthLoading());
    
    try {
      final response = await _apiService.requestOTPForOfficer(event.phone);
      
      if (response.success) {
        emit(OfficerOTPRequested(event.phone));
      } else {
        emit(OfficerAuthError(response.message));
      }
    } catch (e) {
      emit(OfficerAuthError('Failed to request OTP: $e'));
    }
  }

  Future<void> _onVerifyOTP(OfficerVerifyOTP event, Emitter<OfficerState> emit) async {
    emit(const OfficerAuthLoading());
    
    try {
      final response = await _apiService.verifyOTPForOfficer(event.phone, event.otp);
      
      if (response.success && response.data != null) {
        emit(OfficerAuthenticated(
          userData: response.data!['user'] ?? {},
          officerData: response.data!['officer'],
        ));
      } else {
        emit(OfficerAuthError(response.message));
      }
    } catch (e) {
      emit(OfficerAuthError('Failed to verify OTP: $e'));
    }
  }

  Future<void> _onLoadProfile(OfficerLoadProfile event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.getCurrentOfficer();
      
      if (response.success && response.data != null) {
        emit(OfficerAuthenticated(
          userData: response.data!['user'] ?? {},
          officerData: response.data!['officer'],
        ));
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to load profile: $e'));
    }
  }

  Future<void> _onLoadDashboard(OfficerLoadDashboard event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.getOfficerDashboard();
      
      if (response.success && response.data != null) {
        emit(OfficerDashboardLoaded(response.data!));
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to load dashboard: $e'));
    }
  }

  Future<void> _onLoadIncidents(OfficerLoadIncidents event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.getOfficerIncidents(
        category: event.category,
        status: event.status,
        page: event.page,
      );
      
      if (response.success && response.data != null) {
        emit(OfficerIncidentsLoaded(
          incidents: List<Map<String, dynamic>>.from(response.data!['incidents'] ?? []),
          pagination: response.data!['pagination'],
        ));
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to load incidents: $e'));
    }
  }

  Future<void> _onUpdateAssignmentStatus(OfficerUpdateAssignmentStatus event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.updateAssignmentStatus(
        event.assignmentId,
        event.status,
        notes: event.notes,
      );
      
      if (response.success) {
        emit(OfficerAssignmentUpdated(response.message));
        // Reload dashboard after update
        add(const OfficerLoadDashboard());
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to update assignment: $e'));
    }
  }

  Future<void> _onLoadDepartments(OfficerLoadDepartments event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.getDepartments();
      
      if (response.success && response.data != null) {
        emit(OfficerDepartmentsLoaded(response.data!));
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to load departments: $e'));
    }
  }

  Future<void> _onLoadCategories(OfficerLoadCategories event, Emitter<OfficerState> emit) async {
    emit(const OfficerLoading());
    
    try {
      final response = await _apiService.getOfficerCategories();
      
      if (response.success && response.data != null) {
        emit(OfficerCategoriesLoaded(response.data!));
      } else {
        emit(OfficerError(response.message));
      }
    } catch (e) {
      emit(OfficerError('Failed to load categories: $e'));
    }
  }

  Future<void> _onLogout(OfficerLogout event, Emitter<OfficerState> emit) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userRole');
      emit(const OfficerUnauthenticated());
    } catch (e) {
      emit(OfficerError('Failed to logout: $e'));
    }
  }
}
