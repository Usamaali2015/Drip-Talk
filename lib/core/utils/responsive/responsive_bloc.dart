import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_type.dart';
import 'responsive_event.dart';
import 'responsive_state.dart';

class ResponsiveBloc extends Bloc<ResponsiveEvent, ResponsiveState> {
  ResponsiveBloc() : super(const ResponsiveState()) {
    on<ScreenSizeChanged>(_onScreenSizeChanged);
  }

  void _onScreenSizeChanged(
    ScreenSizeChanged event,
    Emitter<ResponsiveState> emit,
  ) {
    final next = DeviceTypeX.fromWidth(event.width);

    if (next == state.deviceType &&
        event.width == state.screenWidth &&
        event.height == state.screenHeight) {
      return;
    }

    emit(
      state.copyWith(
        deviceType: next,
        screenWidth: event.width,
        screenHeight: event.height,
      ),
    );
  }
}
