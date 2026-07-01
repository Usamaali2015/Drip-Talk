import 'dart:io';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/app_dialog_box.dart';
import 'package:drip_talk/features/permission/domain/bloc/permission_bloc.dart';
import 'package:drip_talk/features/permission/domain/bloc/permission_event.dart';
import 'package:drip_talk/features/permission/view/widgets/prominent_disclosure_dialog.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionGuard {
  PermissionGuard._();

  static int getAndroidSdk() {
    if (!Platform.isAndroid) return 0;
    final match = RegExp(r'(?:API|SDK)\s*(\d+)', caseSensitive: false)
        .firstMatch(Platform.operatingSystemVersion);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '') ?? 0;
    }
    return 0;
  }

  static Future<bool> request(
    BuildContext context,
    Permission permission, {
    IconData? icon,
    String? title,
    String? dataCollected,
    String? purpose,
    String? usage,
    String? storageInfo,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<PermissionBloc>();

    // 1. Check current status
    bloc.add(CheckPermissionEvent(permission));

    // Wait brief moment for the state to register
    await Future.delayed(const Duration(milliseconds: 50));

    PermissionStatus status = await permission.status;

    // 2. If already granted/limited, proceed
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // 3. If not granted, we must show Prominent Disclosure
    final resolvedIcon = icon ??
        (permission == Permission.camera
            ? Icons.camera_alt_rounded
            : Icons.photo_library_rounded);

    final resolvedTitle = title ??
        (permission == Permission.camera
            ? l10n.permissionCameraTitle
            : l10n.permissionStorageTitle);

    final resolvedData = dataCollected ??
        (permission == Permission.camera
            ? l10n.permissionCameraDataCollected
            : l10n.permissionStorageDataCollected);

    final resolvedPurpose = purpose ??
        (permission == Permission.camera
            ? l10n.permissionCameraPurpose
            : l10n.permissionStoragePurpose);

    final resolvedUsage = usage ??
        (permission == Permission.camera
            ? l10n.permissionCameraUsage
            : l10n.permissionStorageUsage);

    final resolvedStorage = storageInfo ??
        (permission == Permission.camera
            ? l10n.permissionCameraStorage
            : l10n.permissionStorageStorage);

    bool userAcceptedDisclosure = false;

    // Show custom dialog
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return ProminentDisclosureDialog(
            icon: resolvedIcon,
            title: resolvedTitle,
            dataCollected: resolvedData,
            purpose: resolvedPurpose,
            usage: resolvedUsage,
            storageInfo: resolvedStorage,
            onAccept: () {
              userAcceptedDisclosure = true;
              Navigator.of(dialogContext).pop();
            },
            onDeny: () {
              userAcceptedDisclosure = false;
              Navigator.of(dialogContext).pop();
            },
          );
        },
      );
    }

    if (!userAcceptedDisclosure) {
      return false;
    }

    // 4. Request Native Permission
    bloc.add(RequestPermissionEvent(permission));

    // Wait for the request to complete
    status = await permission.request();

    if (status.isGranted || status.isLimited) {
      return true;
    }

    // 5. If permanently denied, show redirection to settings
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) {
            return AppDialog(
              title: l10n.permissionSettingsTitle,
              description: l10n.permissionSettingsMessage,
              primaryButtonText: l10n.permissionSettingsOpen,
              onPrimaryPressed: () async {
                await openAppSettings();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              secondaryButtonText: l10n.cancel,
              onSecondaryPressed: () => Navigator.of(dialogContext).pop(),
              icon: Icons.settings_rounded,
              iconColor: AppColors.primary,
            );
          },
        );
      }
    }

    return false;
  }
}
