import 'package:flutter/material.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/core/services/storage/storage_keys.dart';

class AuthGuard {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isProfileSetupRequired = ValueNotifier<bool>(
    false,
  );
  static final ValueNotifier<bool> isRecommendationsFlowRequired =
      ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    final token = await SecureStorage.instance.getAuthToken();
    final hasAuthenticatedSession = token != null && token.isNotEmpty;
    final profileSetupRequired = hasAuthenticatedSession
        ? await SecureStorage.instance.readBool(
            StorageKeys.profileSetupRequired,
          )
        : false;
    final recommendationsFlowRequired =
        hasAuthenticatedSession && !profileSetupRequired
        ? await SecureStorage.instance.readBool(
            StorageKeys.recommendationsFlowRequired,
          )
        : false;

    isProfileSetupRequired.value = profileSetupRequired;
    isRecommendationsFlowRequired.value = recommendationsFlowRequired;
    isLoggedIn.value = hasAuthenticatedSession;
  }

  static void login({
    bool? profileSetupRequired,
    bool? recommendationsFlowRequired,
  }) {
    if (profileSetupRequired != null) {
      isProfileSetupRequired.value = profileSetupRequired;
    }
    if (recommendationsFlowRequired != null) {
      isRecommendationsFlowRequired.value = recommendationsFlowRequired;
    }
    isLoggedIn.value = true;
  }

  static void completeProfileSetup() {
    isProfileSetupRequired.value = false;
  }

  static void requireRecommendationsFlow() {
    isRecommendationsFlowRequired.value = true;
  }

  static void completeRecommendationsFlow() {
    isRecommendationsFlowRequired.value = false;
  }

  static void logout() {
    isProfileSetupRequired.value = false;
    isRecommendationsFlowRequired.value = false;
    isLoggedIn.value = false;
  }
}
