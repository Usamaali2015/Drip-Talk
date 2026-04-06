import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';

import 'login_barrels.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    this.initialMessage,
  });

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
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: const MobileLoginView(),
        tablet: const TabletLoginView(),
        tabletLarge: const TabletLoginView(),
        desktop: const DesktopLoginView(),
      ),
    );
  }
}
