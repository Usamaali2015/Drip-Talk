part of '../payment_methods_view.dart';

class _WalletMethodsSection extends StatelessWidget {
  const _WalletMethodsSection({
    required this.heading,
    required this.methods,
    required this.titleResolver,
    required this.descriptionResolver,
    required this.actionResolver,
    required this.badgeResolver,
    required this.selectedMethodId,
    required this.onSelected,
  });

  final String heading;
  final List<PaymentMethodModel> methods;
  final String Function(PaymentMethodType type) titleResolver;
  final String Function(PaymentMethodType type) descriptionResolver;
  final String Function(PaymentMethodType type) actionResolver;
  final String Function(PaymentMethodBadgeType type) badgeResolver;
  final String? selectedMethodId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PaymentMethodsSectionHeading(
          text: heading,
          style: AppTextStyles.ts24(context, fontWeight: FontWeight.w800),
        ),
        const AppGap(AppSizes.s20),
        ...methods.map((method) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s24),
            child: PaymentMethodCard(
              title: titleResolver(method.type),
              description: descriptionResolver(method.type),
              actionLabel: actionResolver(method.type),
              badgeLabel: badgeResolver(method.badgeType),
              assetPath: method.assetPath,
              isSelected: selectedMethodId == method.id,
              onTap: () => onSelected(method.id),
              onPrimaryAction: () => onSelected(method.id),
            ),
          );
        }),
      ],
    );
  }
}

class _SupportedMethodsList extends StatelessWidget {
  const _SupportedMethodsList({
    required this.heading,
    required this.paymentTypes,
    required this.emptyMessage,
    required this.labelResolver,
  });

  final String heading;
  final List<SupportedPaymentType> paymentTypes;
  final String emptyMessage;
  final String Function(SupportedPaymentType type) labelResolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PaymentMethodsSectionHeading(
          text: heading,
          style: AppTextStyles.ts20(context, fontWeight: FontWeight.w800),
        ),
        const AppGap(AppSizes.s16),
        if (paymentTypes.isEmpty)
          _PaymentMethodsMessageCard(message: emptyMessage)
        else
          ...paymentTypes.map((paymentType) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: SupportedPaymentChip(label: labelResolver(paymentType)),
            );
          }),
      ],
    );
  }
}

class _PaymentMethodsSectionHeading extends StatelessWidget {
  const _PaymentMethodsSectionHeading({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return AppText(text: text, style: style, gradient: AppColors.textGradient);
  }
}

class _SupportedMethodsPanel extends StatelessWidget {
  const _SupportedMethodsPanel({
    required this.heading,
    required this.paymentTypes,
    required this.emptyMessage,
    required this.labelResolver,
  });

  final String heading;
  final List<SupportedPaymentType> paymentTypes;
  final String emptyMessage;
  final String Function(SupportedPaymentType type) labelResolver;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.paymentPanelBackground,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.24)),
      ),
      child: _SupportedMethodsList(
        heading: heading,
        paymentTypes: paymentTypes,
        emptyMessage: emptyMessage,
        labelResolver: labelResolver,
      ),
    );
  }
}

class _PaymentMethodsLoadingState extends StatelessWidget {
  const _PaymentMethodsLoadingState({
    required this.isWideLayout,
    required this.sectionGap,
  });

  final bool isWideLayout;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightBg.withValues(alpha: 0.88),
      highlightColor: AppColors.primary.withValues(alpha: 0.28),
      child: isWideLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      _PaymentMethodsLoadingCard(),
                      AppGap(AppSizes.s24),
                      _PaymentMethodsLoadingCard(),
                    ],
                  ),
                ),
                AppGap(sectionGap, axis: Axis.horizontal),
                const Expanded(flex: 4, child: _LoadingPanel()),
              ],
            )
          : const Column(
              children: [
                _PaymentMethodsLoadingCard(),
                AppGap(AppSizes.s24),
                _PaymentMethodsLoadingCard(),
                AppGap(AppSizes.s28),
                _LoadingBar(),
              ],
            ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      child: const Column(
        children: [
          _LoadingBar(),
          AppGap(AppSizes.s16),
          _LoadingBar(),
          AppGap(AppSizes.s16),
          _LoadingBar(),
        ],
      ),
    );
  }
}

class _PaymentMethodsLoadingCard extends StatelessWidget {
  const _PaymentMethodsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.s56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.r15),
      ),
    );
  }
}

class _PaymentMethodsMessageCard extends StatelessWidget {
  const _PaymentMethodsMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.paymentPanelBackground,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.7)),
      ),
      child: AppText(
        text: message,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.92),
        ).copyWith(height: 1.45),
      ),
    );
  }
}
