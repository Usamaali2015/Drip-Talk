import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class SetLocaleEvent extends LocalizationEvent {
  final Locale locale;

  const SetLocaleEvent(this.locale);

  @override
  List<Object> get props => [locale];
}
