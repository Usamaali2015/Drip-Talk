import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/auth/barrels/biometric_barrels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mobile_login_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.initialMessage});

  final String? initialMessage;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _didShowInitialMessage = false;

  @override
  void initState() {
    super.initState();
    _showInitialMessageIfNeeded();
  }

  @override
  void didUpdateWidget(covariant LoginView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMessage != widget.initialMessage) {
      _didShowInitialMessage = false;
      _showInitialMessageIfNeeded();
    }
  }

  void _showInitialMessageIfNeeded() {
    final message = widget.initialMessage?.trim();
    if (_didShowInitialMessage || message == null || message.isEmpty) {
      return;
    }

    _didShowInitialMessage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ToastUtils.show(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricAuthBloc>(
      create: (_) =>
          getIt<BiometricAuthBloc>()
            ..add(const InitializeBiometricAuthRequested()),
      child: AppResponsivePageLayout(
        showHeaderDivider: false,
        useSafeArea: false,
        mobileMaxWidth: 430,
        tabletMaxWidth: 520,
        tabletLargeMaxWidth: 560,
        desktopMaxWidth: 600,
        pageBuilder: (context, _) => const MobileLoginView(),
      ),
    );
  }
}
