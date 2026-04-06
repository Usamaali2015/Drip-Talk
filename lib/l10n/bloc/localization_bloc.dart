import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final SecureStorage _secureStorage = SecureStorage.instance;

  LocalizationBloc() : super(const LocalizationState(locale: Locale('en'))) {
    on<SetLocaleEvent>(_onSetLocale);
    _initializeLocale();
  }

  /// Initialize the locale from secure storage
  Future<void> _initializeLocale() async {
    final savedLocale = await _secureStorage.getLocale();
    add(SetLocaleEvent(savedLocale));
  }

  /// Handle setting a new locale
  Future<void> _onSetLocale(
    SetLocaleEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    await _secureStorage.saveLocale(event.locale);
    emit(LocalizationState(locale: event.locale));
  }
}
