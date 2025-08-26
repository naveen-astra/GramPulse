import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:grampulse/features/auth/domain/services/auth_service.dart';

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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, we would call repository to save user profile
      
      // Temporarily set user ID as we don't have a real one yet
      final authService = AuthService();
      final tempUserId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // For now, we'll keep the user in "auth in progress" state
      // The role selection screen will finally set the user as fully authenticated
      
      emit(state.copyWith(status: ProfileSetupStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileSetupStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
