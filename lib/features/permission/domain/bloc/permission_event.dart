import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object?> get props => [];
}

class CheckPermissionEvent extends PermissionEvent {
  final Permission permission;

  const CheckPermissionEvent(this.permission);

  @override
  List<Object?> get props => [permission];
}

class RequestPermissionEvent extends PermissionEvent {
  final Permission permission;

  const RequestPermissionEvent(this.permission);

  @override
  List<Object?> get props => [permission];
}
