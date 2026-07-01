import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionState.initial()) {
    on<CheckPermissionEvent>(_onCheckPermission);
    on<RequestPermissionEvent>(_onRequestPermission);
  }

  Future<void> _onCheckPermission(
    CheckPermissionEvent event,
    Emitter<PermissionState> emit,
  ) async {
    final status = await event.permission.status;
    final updatedStatuses = Map<Permission, PermissionStatus>.from(state.statuses)
      ..[event.permission] = status;
    emit(state.copyWith(statuses: updatedStatuses));
  }

  Future<void> _onRequestPermission(
    RequestPermissionEvent event,
    Emitter<PermissionState> emit,
  ) async {
    final status = await event.permission.request();
    final updatedStatuses = Map<Permission, PermissionStatus>.from(state.statuses)
      ..[event.permission] = status;
    emit(state.copyWith(statuses: updatedStatuses));
  }
}
