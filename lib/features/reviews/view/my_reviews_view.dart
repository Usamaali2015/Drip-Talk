import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/reviews/barrels/reviews_barrels.dart';
import 'package:drip_talk/features/shop/barrels/shop_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
part 'widgets/my_reviews_view_widgets.dart';

class MyReviewsView extends StatelessWidget {
  const MyReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<MyReviewsBloc, MyReviewsState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage &&
          current.feedbackMessage != null,
      listener: (context, state) {
        final message = state.feedbackMessage?.trim();
        if (message == null || message.isEmpty) {
          return;
        }

        ToastUtils.show(
          context,
          message,
          type: state.feedbackType == MyReviewsFeedbackType.error
              ? ToastType.error
              : ToastType.success,
        );
      },
      builder: (context, state) {
        final bottomNav = state.hasPagination
            ? _ReviewsPaginationBar(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                onPageSelected: (page) => context.read<MyReviewsBloc>().add(
                  ChangeMyReviewsPageRequested(page),
                ),
              )
            : null;

        return AppResponsivePageLayout(
          mobileMaxWidth: 430,
          tabletMaxWidth: 720,
          tabletLargeMaxWidth: 860,
          desktopMaxWidth: 980,
          showBottomNav: state.hasPagination,
          bottomNav: bottomNav,
          headerBuilder: (context, _) => AppPageHeader(
            title: l10n.myReviews,
            subtitle: l10n.reviewsManageSubtitle,
            onBack: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
                return;
              }

              context.goNamed(AppRoutes.profiles);
            },
          ),
          bodyBuilder: (context, _) {
            if (state.isInitialLoading) {
              return const ReviewLoadingView();
            }

            return RefreshIndicator(
              color: AppColors.secondary,
              backgroundColor: AppColors.lightBg,
              onRefresh: () async {
                context.read<MyReviewsBloc>().add(
                  LoadMyReviewsRequested(
                    page: state.currentPage,
                    perPage: state.perPage,
                    showLoader: false,
                  ),
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      0,
                      AppSizes.s14,
                      0,
                      0,
                    ),
                    sliver: SliverList.list(
                      children: [
                        _ReviewsStats(summary: state.summary),
                        const AppGap(AppSizes.s18),
                        _ReviewFilterRow(
                          activeFilter: state.activeFilter,
                          onChanged: (filter) => context
                              .read<MyReviewsBloc>()
                              .add(MyReviewsFilterChanged(filter)),
                        ),
                        if (state.isRefreshing) ...[
                          const AppGap(AppSizes.s12),
                          const _ReviewsRefreshingIndicator(),
                        ],
                        const AppGap(AppSizes.s16),
                      ],
                    ),
                  ),
                  if (state.loadStatus == MyReviewsLoadStatus.failure &&
                      state.reviews.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        state.hasPagination ? AppSizes.s120 : AppSizes.s24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: ErrorRetryWidget(
                          message: state.errorMessage ?? l10n.reviewsLoadFailed,
                          onRetry: () {
                            context.read<MyReviewsBloc>().add(
                              LoadMyReviewsRequested(
                                page: state.currentPage,
                                perPage: state.perPage,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else if (state.filteredReviews.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        state.hasPagination ? AppSizes.s120 : AppSizes.s24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _EmptyReviewsState(
                          hasFilter: state.activeFilter != ReviewFilter.all,
                          onResetFilter: () => context.read<MyReviewsBloc>().add(
                            const MyReviewsFilterChanged(ReviewFilter.all),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        state.hasPagination ? AppSizes.s120 : AppSizes.s24,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index.isOdd) {
                              return const AppGap(AppSizes.s16);
                            }

                            final review = state.filteredReviews[index ~/ 2];
                            return ReviewCard(
                              review: review,
                              isUpdating: state.isUpdatingFor(review),
                              isDeleting: state.isDeletingFor(review),
                              onWritePressed: null,
                              onEditPressed: state.isBusy || !review.canEditReview
                                  ? null
                                  : () => _openEditReview(context, review),
                              onDeletePressed:
                                  state.isBusy || !review.canDeleteReview
                                  ? null
                                  : () => _confirmDeleteReview(context, review),
                            );
                          },
                          childCount: state.filteredReviews.isEmpty
                              ? 0
                              : (state.filteredReviews.length * 2) - 1,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openEditReview(
    BuildContext context,
    MyReviewItemData review,
  ) async {
    final request = await ReviewFormSheet.show(
      context,
      review: review,
      mode: ReviewFormMode.edit,
    );

    if (!context.mounted || request == null || review.reviewId == null) {
      return;
    }

    context.read<MyReviewsBloc>().add(
      UpdateMyReviewRequested(reviewId: review.reviewId!, request: request),
    );
  }

  Future<void> _confirmDeleteReview(
    BuildContext context,
    MyReviewItemData review,
  ) async {
    final shouldDelete = await DeleteReviewSheet.show(context, review: review);

    if (!context.mounted || shouldDelete != true || review.reviewId == null) {
      return;
    }

    context.read<MyReviewsBloc>().add(
      DeleteMyReviewRequested(review.reviewId!),
    );
  }
}
