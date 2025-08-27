import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CitizenHomeEvent {}

class LoadDashboard extends CitizenHomeEvent {}

class RefreshDashboard extends CitizenHomeEvent {}

// States
abstract class CitizenHomeState {}

class CitizenHomeInitial extends CitizenHomeState {}

class CitizenHomeLoading extends CitizenHomeState {}

class CitizenHomeLoaded extends CitizenHomeState {
  final String userName;
  
  CitizenHomeLoaded({this.userName = "John Doe"});
}

class CitizenHomeError extends CitizenHomeState {
  final String message;
  
  CitizenHomeError(this.message);
}

// Bloc
class CitizenHomeBloc extends Bloc<CitizenHomeEvent, CitizenHomeState> {
  CitizenHomeBloc() : super(CitizenHomeInitial()) {
    on<LoadDashboard>((event, emit) {
      emit(CitizenHomeLoading());
      emit(CitizenHomeLoaded());
    });
    
    on<RefreshDashboard>((event, emit) {
      emit(CitizenHomeLoading());
      emit(CitizenHomeLoaded());
    });
  }
}
