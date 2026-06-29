import 'package:drip_talk/features/legal_pages/data/models/legal_page_model.dart';
import 'package:equatable/equatable.dart';

enum LegalPageStatus { initial, loading, success, failure }

class LegalPageState extends Equatable {
  const LegalPageState({
    this.status = LegalPageStatus.initial,
    this.page,
    this.errorMessage,
  });

  final LegalPageStatus status;
  final LegalPageData? page;
  final String? errorMessage;

  bool get isInitialLoading =>
      status == LegalPageStatus.loading && page == null;

  bool get isFailure => status == LegalPageStatus.failure;

  bool get isEmpty =>
      status == LegalPageStatus.success && !(page?.hasSections ?? false);

  LegalPageState copyWith({
    LegalPageStatus? status,
    LegalPageData? page,
    bool clearPage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LegalPageState(
      status: status ?? this.status,
      page: clearPage ? null : page ?? this.page,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, page, errorMessage];
}
