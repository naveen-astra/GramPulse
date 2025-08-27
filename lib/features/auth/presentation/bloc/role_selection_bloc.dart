import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/services/api_service.dart';
import 'package:grampulse/features/auth/domain/services/auth_service.dart' as domain_auth;

// Events
abstract class RoleSelectionEvent {}

class RoleSelectionRoleChanged extends RoleSelectionEvent {
  final String role;
  RoleSelectionRoleChanged(this.role); // Removed const
}

class RoleSelectionSubmitted extends RoleSelectionEvent {
  RoleSelectionSubmitted(); // Removed const
}

// States
enum RoleSelectionStatus { initial, submitting, success, failure }

class RoleSelectionState {
  final String? selectedRole;
  final RoleSelectionStatus status;
  final String? errorMessage;

  const RoleSelectionState({
    this.selectedRole,
    this.status = RoleSelectionStatus.initial,
    this.errorMessage,
  });

  RoleSelectionState copyWith({
    String? selectedRole,
    RoleSelectionStatus? status,
    String? errorMessage,
  }) {
    return RoleSelectionState(
      selectedRole: selectedRole ?? this.selectedRole,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RoleSelectionInitial extends RoleSelectionState {}

// Bloc
class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  RoleSelectionBloc() : super(RoleSelectionInitial()) {
    on<RoleSelectionRoleChanged>((event, emit) {
      emit(state.copyWith(selectedRole: event.role));
    });
    
    on<RoleSelectionSubmitted>((event, emit) async {
      emit(state.copyWith(status: RoleSelectionStatus.submitting));
      try {
        final selected = state.selectedRole;
        if (selected == null) {
          emit(state.copyWith(status: RoleSelectionStatus.failure, errorMessage: 'Please select a role'));
          return;
        }

        final api = ApiService();

        // Fetch current user to get name/phone for the update payload
        final me = await api.get('/auth/me', (d) => d);
        if (!me.success || me.data == null) {
          emit(state.copyWith(status: RoleSelectionStatus.failure, errorMessage: me.message));
          return;
        }
        final meData = me.data as Map<String, dynamic>;
        final name = (meData['name'] as String?) ?? 'User';
        final phone = (meData['phone'] as String?) ?? '';
        final id = (meData['_id'] as String?) ?? '';

        // Persist selected role
        final update = await api.put('/auth/complete-profile', {
          'name': name,
          'role': selected,
          'email': meData['email'],
        }, (d) => d);

        if (!update.success || update.data == null) {
          emit(state.copyWith(status: RoleSelectionStatus.failure, errorMessage: update.message));
          return;
        }

        // Set final authenticated state in domain auth service
        final auth = domain_auth.AuthService();
        domain_auth.UserRole roleEnum;
        switch (selected) {
          case 'volunteer':
            roleEnum = domain_auth.UserRole.volunteer;
            break;
          case 'officer':
            roleEnum = domain_auth.UserRole.officer;
            break;
          case 'admin':
            roleEnum = domain_auth.UserRole.admin;
            break;
          case 'citizen':
          default:
            roleEnum = domain_auth.UserRole.citizen;
            break;
        }
        auth.setAuthenticated(
          role: roleEnum,
          userId: id,
          userName: name,
          phoneNumber: phone,
        );

        emit(state.copyWith(status: RoleSelectionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: RoleSelectionStatus.failure, errorMessage: e.toString()));
      }
    });
  }
}
