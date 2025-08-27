import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class MyIssuesEvent {}

class LoadMyIssues extends MyIssuesEvent {}

// States
abstract class MyIssuesState {}

class MyIssuesInitial extends MyIssuesState {}

class MyIssuesLoading extends MyIssuesState {}

class MyIssuesLoaded extends MyIssuesState {}

// Bloc
class MyIssuesBloc extends Bloc<MyIssuesEvent, MyIssuesState> {
  MyIssuesBloc() : super(MyIssuesInitial()) {
    on<LoadMyIssues>((event, emit) {
      emit(MyIssuesLoading());
      emit(MyIssuesLoaded());
    });
  }
}
