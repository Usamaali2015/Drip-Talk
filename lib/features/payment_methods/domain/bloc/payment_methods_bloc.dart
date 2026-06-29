import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/payment_methods/data/models/payment_method_model.dart';
import 'package:drip_talk/features/payment_methods/data/repository/payment_methods_repository.dart';
import 'package:drip_talk/features/payment_methods/domain/bloc/payment_methods_event.dart';
import 'package:drip_talk/features/payment_methods/domain/bloc/payment_methods_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  PaymentMethodsBloc(this._repository) : super(const PaymentMethodsState()) {
    on<LoadPaymentMethodsRequested>(_onLoadRequested);
    on<PaymentMethodSelected>(_onMethodSelected);
  }

  final PaymentMethodsRepository _repository;

  Future<void> _onLoadRequested(
    LoadPaymentMethodsRequested event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PaymentMethodsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final catalog = await _repository.getPaymentMethodsCatalog();

      emit(
        state.copyWith(
          status: PaymentMethodsStatus.success,
          wallets: catalog.digitalWallets,
          supportedPaymentTypes: catalog.supportedPaymentTypes,
          selectedMethodId: _resolveSelectedMethodId(catalog),
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PaymentMethodsStatus.failure,
          clearWallets: true,
          clearSupportedPaymentTypes: true,
          clearSelectedMethodId: true,
          errorMessage: localizedString(
            fallback: 'Unable to load payment methods.',
            select: (l10n) => l10n.paymentMethodsLoadFailed,
          ),
        ),
      );
    }
  }

  void _onMethodSelected(
    PaymentMethodSelected event,
    Emitter<PaymentMethodsState> emit,
  ) {
    final methodExists = state.wallets.any((item) => item.id == event.methodId);
    if (!methodExists || state.selectedMethodId == event.methodId) {
      return;
    }

    emit(
      state.copyWith(
        status: PaymentMethodsStatus.success,
        selectedMethodId: event.methodId,
        clearErrorMessage: true,
      ),
    );
  }

  String? _resolveSelectedMethodId(PaymentMethodsCatalog catalog) {
    final preferredMethodId = catalog.preferredMethodId;
    if (preferredMethodId != null) {
      for (final wallet in catalog.digitalWallets) {
        if (wallet.id == preferredMethodId) {
          return preferredMethodId;
        }
      }
    }

    return catalog.digitalWallets.isEmpty
        ? null
        : catalog.digitalWallets.first.id;
  }
}
