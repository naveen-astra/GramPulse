import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:grampulse/features/auth/domain/services/auth_service.dart';
import 'package:grampulse/core/services/api_service.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc() : super(ProfileSetupInitial()) {
    on<ProfileSetupFullNameChanged>(_onFullNameChanged);
    on<ProfileSetupEmailChanged>(_onEmailChanged);
    on<ProfileSetupAddressChanged>(_onAddressChanged);
    on<ProfileSetupPinCodeChanged>(_onPinCodeChanged);
    on<ProfileSetupImagePicked>(_onImagePicked);
    on<ProfileSetupSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onFullNameChanged(
    ProfileSetupFullNameChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(fullName: event.fullName));
  }

  FutureOr<void> _onEmailChanged(
    ProfileSetupEmailChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  FutureOr<void> _onAddressChanged(
    ProfileSetupAddressChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(address: event.address));
  }

  FutureOr<void> _onPinCodeChanged(
    ProfileSetupPinCodeChanged event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(pinCode: event.pinCode));
  }

  FutureOr<void> _onImagePicked(
    ProfileSetupImagePicked event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(state.copyWith(profileImage: event.profileImage));
  }

  FutureOr<void> _onSubmitted(
    ProfileSetupSubmitted event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(state.copyWith(status: ProfileSetupStatus.submitting));
    
    try {
      final api = ApiService();
      final body = {
        'name': state.fullName,
        'role': 'citizen', // default role until user picks one on next screen
        'email': state.email,
      };

      final resp = await api.put('/auth/complete-profile', body, (d) => d);
      if (!resp.success) throw Exception(resp.message);

      // Keep auth as in-progress; role selection will finalize
      final authService = AuthService();
      if (authService.phoneNumber == null) {
        // no-op, just ensure service is initialized
      }

      emit(state.copyWith(status: ProfileSetupStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileSetupStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
