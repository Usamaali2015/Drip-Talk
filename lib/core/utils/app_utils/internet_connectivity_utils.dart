import 'utils_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectivity {
  InternetConnectivity._();

  static final InternetConnectivity instance = InternetConnectivity._();

  final InternetConnectionChecker _checker = InternetConnectionChecker.instance;

  StreamSubscription<InternetConnectionStatus>? _subscription;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ///* ================= INIT ================= *///
  Future<void> initialize(BuildContext context) async {
    _subscription?.cancel();

    final hasConnection = await _checker.hasConnection;
    _isConnected = hasConnection;

    if (!hasConnection && context.mounted) {
      _handleStatusChange(context, false);
    }

    // Listen to real internet changes
    _subscription = _checker.onStatusChange.listen((
      InternetConnectionStatus status,
    ) {
      final connected = status == InternetConnectionStatus.connected;

      if (connected != _isConnected && context.mounted) {
        _isConnected = connected;
        _handleStatusChange(context, connected);
      }
    });
  }

  ///* ================= CHECK ONCE ================= *///
  Future<bool> checkConnection() async {
    return _checker.hasConnection;
  }

  ///* ================= HANDLE UI ================= *///
  void _handleStatusChange(BuildContext context, bool connected) {
    if (!context.mounted) return;

    if (!connected) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.noInternet,
        type: ToastType.error,
      );
    } else {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.backOnline,
        type: ToastType.success,
      );
    }
  }

  ///* ================= DISPOSE ================= *///
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
