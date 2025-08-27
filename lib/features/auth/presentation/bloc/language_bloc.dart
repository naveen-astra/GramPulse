import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class LanguageEvent {}

class SelectLanguage extends LanguageEvent {
  final String languageCode;
  SelectLanguage(this.languageCode);
}

// States
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageUpdating extends LanguageState {}

class LanguageSelected extends LanguageState {
  final String languageCode;
  LanguageSelected(this.languageCode);
}

class LanguageUpdated extends LanguageState {
  final String languageCode;
  LanguageUpdated(this.languageCode);
}

class LanguageError extends LanguageState {
  final String message;
  LanguageError(this.message);
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<SelectLanguage>((event, emit) {
      emit(LanguageUpdating());
      emit(LanguageSelected(event.languageCode));
    });
  }
}
