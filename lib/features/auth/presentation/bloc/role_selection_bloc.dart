import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grampulse/features/auth/domain/services/auth_service.dart';

part 'role_selection_event.dart';
part 'role_selection_state.dart';

class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  RoleSelectionBloc() : super(const RoleSelectionState()) {
    on<RoleSelectionRoleChanged>(_onRoleChanged);
    on<RoleSelectionSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onRoleChanged(
    RoleSelectionRoleChanged event,
    Emitter<RoleSelectionState> emit,
  ) {
    emit(state.copyWith(selectedRole: event.role));
  }

  FutureOr<void> _onSubmitted(
    RoleSelectionSubmitted event,
    Emitter<RoleSelectionState> emit,
  ) async {
    emit(state.copyWith(status: RoleSelectionStatus.submitting));
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, we would call repository to save user role
      
      // Complete the authentication process by setting the user's role
      final authService = AuthService();
      final UserRole userRole;
      
      // Convert string role to UserRole enum
      switch (state.selectedRole) {
        case 'citizen':
          userRole = UserRole.citizen;
          break;
        case 'volunteer':
          userRole = UserRole.volunteer;
          break;
        case 'officer':
          userRole = UserRole.officer;
          break;
        case 'admin':
          userRole = UserRole.admin;
          break;
        default:
          userRole = UserRole.citizen; // Default to citizen
      }
      
      // Generate a temporary user ID
      final tempUserId = DateTime.now().millisecondsSinceEpoch.toString();
      final phoneNumber = authService.phoneNumber ?? '';
      
      // Set the user as fully authenticated with the selected role
      authService.setAuthenticated(
        role: userRole,
        userId: tempUserId,
        userName: 'User $tempUserId', // Temporary name
        phoneNumber: phoneNumber,
      );
      
      emit(state.copyWith(status: RoleSelectionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RoleSelectionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
