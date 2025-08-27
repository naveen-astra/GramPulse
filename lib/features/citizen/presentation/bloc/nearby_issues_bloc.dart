import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NearbyIssuesEvent {}

class LoadNearbyIssues extends NearbyIssuesEvent {}

// States
abstract class NearbyIssuesState {}

class NearbyIssuesInitial extends NearbyIssuesState {}

class NearbyIssuesLoading extends NearbyIssuesState {}

class NearbyIssuesLoaded extends NearbyIssuesState {}

// Bloc
class NearbyIssuesBloc extends Bloc<NearbyIssuesEvent, NearbyIssuesState> {
  NearbyIssuesBloc() : super(NearbyIssuesInitial()) {
    on<LoadNearbyIssues>((event, emit) {
      emit(NearbyIssuesLoading());
      emit(NearbyIssuesLoaded());
    });
  }
}
