import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionState extends Equatable {
  final Map<Permission, PermissionStatus> statuses;

  const PermissionState({required this.statuses});

  factory PermissionState.initial() => const PermissionState(statuses: {});

  PermissionState copyWith({
    Map<Permission, PermissionStatus>? statuses,
  }) {
    return PermissionState(
      statuses: statuses ?? this.statuses,
    );
  }

  @override
  List<Object?> get props => [statuses];
}
