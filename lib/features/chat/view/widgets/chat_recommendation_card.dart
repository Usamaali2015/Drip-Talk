import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ChatAiRecommendationCard extends StatelessWidget {
  const ChatAiRecommendationCard({super.key, required this.item});

  final AiRecommendedItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subtitle = _firstNonEmpty([item.reason, item.merchant, item.source]);
    final tags = <String>[
      if (item.source?.trim().isNotEmpty == true) item.source!.trim(),
      if (item.merchant?.trim().isNotEmpty == true) item.merchant!.trim(),
      if (item.delivery?.trim().isNotEmpty == true) item.delivery!.trim(),
    ];

    return _ChatRecommendationCardLayout(
      imageUrl: item.imageUrl,
      title: item.title ?? l10n.chatAiRecommendationFallbackTitle,
      subtitle: subtitle ?? l10n.chatAiRecommendationFallbackSubtitle,
      priceLabel: item.priceLabel,
      tags: tags,
      outlineLabel: l10n.chatBrowserAction,
      filledLabel: l10n.chatShopAction,
      accentLabel: l10n.chatAiPick,
      onOutlineTap: () => _openExternalItem(context, item),
      onFilledTap: () => _openExternalItem(context, item),
    );
  }

  Future<void> _openExternalItem(
    BuildContext context,
    AiRecommendedItem recommendation,
  ) async {
    final url = recommendation.productUrl?.trim();
    final uri = url == null || url.isEmpty ? null : Uri.tryParse(url);

    if (uri == null) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.chatProductLinkUnavailable,
        type: ToastType.error,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);

    if (launched) {
      return;
    }

    final fallbackLaunched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!fallbackLaunched && context.mounted) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.chatProductOpenFailed,
        type: ToastType.error,
      );
    }
  }
}

class ChatCatalogRecommendationCard extends StatelessWidget {
  const ChatCatalogRecommendationCard({super.key, required this.item});

  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _ChatCatalogRecommendationCardLayout(
      imageUrl: item.thumbnail,
      title: item.title ?? l10n.chatCatalogProductFallbackTitle,
      onTap: () => _openCatalogItem(context),
    );
  }

  void _openCatalogItem(BuildContext context) {
    final productId = item.id;
    if (productId != null) {
      context.pushNamed(
        AppRoutes.products,
        pathParameters: {'id': productId.toString()},
      );
      return;
    }

    final url = item.productUrl?.trim();
    final uri = url == null || url.isEmpty ? null : Uri.tryParse(url);
    if (uri == null) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.chatCatalogProductUnavailable,
        type: ToastType.error,
      );
      return;
    }

    _openCatalogExternally(context, uri);
  }

  Future<void> _openCatalogExternally(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (launched) {
      return;
    }

    final fallbackLaunched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!fallbackLaunched && context.mounted) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.chatProductOpenFailed,
        type: ToastType.error,
      );
    }
  }
}

class _ChatCatalogRecommendationCardLayout extends StatelessWidget {
  const _ChatCatalogRecommendationCardLayout({
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  final String? imageUrl;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSizes.s176,
                width: AppSizes.fitWidth,
                child: AppCachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.s14),
                child: AppText(
                  text: title,
                  variant: AppTextVariant.ts14,
                  textColor: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatRecommendationCardLayout extends StatelessWidget {
  const _ChatRecommendationCardLayout({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.tags,
    required this.outlineLabel,
    required this.filledLabel,
    required this.accentLabel,
    required this.onOutlineTap,
    required this.onFilledTap,
  });

  final String? imageUrl;
  final String title;
  final String subtitle;
  final String? priceLabel;
  final List<String> tags;
  final String outlineLabel;
  final String filledLabel;
  final String accentLabel;
  final VoidCallback onOutlineTap;
  final VoidCallback onFilledTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppSizes.s176,
            width: AppSizes.fitWidth,
            child: AppCachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.s14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionPill(label: accentLabel),
                const AppGap(AppSizes.s8),
                AppText(
                  text: title,
                  variant: AppTextVariant.ts14,
                  textColor: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  maxLines: 3,
                ),
                const AppGap(AppSizes.s4),
                AppText(
                  text: subtitle,
                  variant: AppTextVariant.ts12,
                  textColor: AppColors.pureWhite,
                  fontWeight: FontWeight.w400,
                  maxLines: 1000,
                ),
                if (priceLabel?.trim().isNotEmpty == true) ...[
                  const AppGap(AppSizes.s8),
                  AppText(
                    text: priceLabel!,
                    variant: AppTextVariant.ts16,
                    textColor: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  const AppGap(AppSizes.s10),
                  Wrap(
                    spacing: AppSizes.s8,
                    runSpacing: AppSizes.s6,
                    children: tags
                        .take(3)
                        .map((tag) => _TagChip(label: tag))
                        .toList(),
                  ),
                ],
                const AppGap(AppSizes.s12),
                Row(
                  children: [
                    Expanded(
                      child: _CardButton.outline(
                        label: outlineLabel,
                        onTap: onOutlineTap,
                      ),
                    ),
                    const AppGap(AppSizes.s12, axis: Axis.horizontal),
                    Expanded(
                      child: _CardButton.filled(
                        label: filledLabel,
                        onTap: onFilledTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPill extends StatelessWidget {
  const _SectionPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s8,
        vertical: AppSizes.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
      child: AppText(
        text: label.toUpperCase(),
        variant: AppTextVariant.ts12,
        textColor: AppColors.secondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s8,
        vertical: AppSizes.s6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
      child: AppText(
        text: label,
        variant: AppTextVariant.ts10,
        textColor: AppColors.pureWhite,
        maxLines: 1,
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton._({
    required this.label,
    required this.onTap,
    required this.isFilled,
  });

  const _CardButton.outline({
    required String label,
    required VoidCallback onTap,
  }) : this._(label: label, onTap: onTap, isFilled: false);

  const _CardButton.filled({required String label, required VoidCallback onTap})
    : this._(label: label, onTap: onTap, isFilled: true);

  final String label;
  final VoidCallback onTap;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        onTap: onTap,
        child: Ink(
          height: AppSizes.s40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: isFilled
                ? null
                : Border.all(color: AppColors.secondary.withValues(alpha: 0.7)),
            gradient: isFilled
                ? const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  )
                : null,
            color: isFilled ? null : AppColors.transparent,
          ),
          child: Center(
            child: AppText(
              text: label,
              variant: AppTextVariant.ts12,
              textColor: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    final normalized = value?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  return null;
}
