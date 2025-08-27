import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SplashEvent {
  const SplashEvent();
}

class CheckAuthStatusEvent extends SplashEvent {
  const CheckAuthStatusEvent();
}

// States  
abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

class SplashUpdateRequired extends SplashState {
  final String currentVersion;
  final String requiredVersion;
  
  const SplashUpdateRequired(this.currentVersion, this.requiredVersion);
}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);
}

// Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashUnauthenticated());
  }
}
