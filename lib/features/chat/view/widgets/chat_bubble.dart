import 'dart:math' as math;

import 'package:drip_talk/features/chat/data/ai_response_chat_model.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/domain/chat_bloc.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_attachment_thumbnail.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_recommendation_card.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isBot = message.type == MessageType.bot;
    final hasRecommendations = message.hasRecommendations;
    final isIntroCard = message.isIntroCard;
    final hasAttachments = message.hasAttachments;
    final hasText = message.hasText;
    final shouldShowGenerationCard = _shouldShowGenerationCard;

    return RepaintBoundary(
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSizes.s6),
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width *
                (isIntroCard ? 0.92 : (isBot ? 0.88 : 0.75)),
          ),
          child: Column(
            crossAxisAlignment: isBot
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              if (hasAttachments) _MessageAttachments(message: message),
              if (hasAttachments && (hasText || shouldShowGenerationCard))
                const AppGap(AppSizes.s6),
              if (shouldShowGenerationCard) ...[
                _GenerationStatusCard(message: message),
                if (hasText) const AppGap(AppSizes.s6),
              ],
              if (hasText) ...[
                _MessageBubble(message: message),
                if (message.isError && message.hasRetryRequest) ...[
                  const AppGap(AppSizes.s6),
                  _RetryActionButton(message: message),
                ],
              ],
              if (hasRecommendations) ...[
                const AppGap(AppSizes.s6),
                ..._buildRecommendationSections(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecommendationSections(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final response = message.response;
    if (response == null) {
      return const <Widget>[];
    }

    final sections = <Widget>[];

    if (response.hasAiRecommendations) {
      sections.add(
        _SectionLabel(label: l10n.chatAiPicks, color: AppColors.secondary),
      );
      sections.addAll(
        response.aiRecommendedItems.map(
          (item) => ChatAiRecommendationCard(item: item),
        ),
      );
    }

    if (response.hasCatalogRecommendations) {
      if (sections.isNotEmpty) {
        sections.add(const AppGap(AppSizes.s6));
      }
      sections.add(
        _SectionLabel(label: l10n.chatCatalogMatches, color: AppColors.cyan),
      );
      sections.addAll(
        response.catalogRecommendationItems.map(
          (item) => ChatCatalogRecommendationCard(item: item),
        ),
      );
    }

    if (response.hasOutfits) {
      if (sections.isNotEmpty) {
        sections.add(const AppGap(AppSizes.s6));
      }
      sections.add(
        const _SectionLabel(
          label: 'Suggested outfits',
          color: AppColors.primary,
        ),
      );
      sections.addAll(
        response.outfits.map((outfit) => _OutfitCard(outfit: outfit)),
      );
    }

    return sections;
  }

  bool get _shouldShowGenerationCard {
    final generation = message.generation;
    if (message.type != MessageType.bot || generation == null) {
      return false;
    }

    return generation.isFailed ||
        !generation.isCompleted ||
        !message.hasAttachments;
  }
}

class _RetryActionButton extends StatelessWidget {
  const _RetryActionButton({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextButton.icon(
      onPressed: () => context.read<ChatBloc>().add(
        RetryFailedMessageRequested(message: message),
      ),
      icon: const Icon(
        Icons.refresh_rounded,
        size: AppSizes.s16,
        color: AppColors.secondary,
      ),
      label: AppText(
        text: l10n.retry,
        variant: AppTextVariant.ts12,
        textColor: AppColors.secondary,
        fontWeight: FontWeight.w700,
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s12,
          vertical: AppSizes.s8,
        ),
        backgroundColor: AppColors.lightBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
          side: BorderSide(color: AppColors.secondary.withValues(alpha: 0.45)),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isBot = message.type == MessageType.bot;
    final isError = message.isError;
    final isIntroCard = message.isIntroCard;
    final resolvedText = _resolveMessageText(context);

    if (isIntroCard) {
      return _IntroMessageCard(message: message);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s12,
      ),
      decoration: BoxDecoration(
        color: isBot ? AppColors.lightBg : null,
        gradient: isBot
            ? null
            : const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isBot ? AppRadius.r6 : AppRadius.r16),
          topRight: const Radius.circular(AppRadius.r16),
          bottomLeft: const Radius.circular(AppRadius.r16),
          bottomRight: Radius.circular(isBot ? AppRadius.r16 : AppRadius.r6),
        ),
        border: isBot
            ? Border.all(
                color: isError
                    ? AppColors.materialRedAccent.withValues(alpha: 0.5)
                    : AppColors.secondary.withValues(alpha: 0.5),
              )
            : null,
      ),
      child: AppText(
        text: resolvedText,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1000,
      ),
    );
  }

  String _resolveMessageText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textKey = message.textKey;
    if (textKey == null) {
      return message.text;
    }

    switch (textKey) {
      case ChatMessageTextKey.historyFallback:
        return l10n.chatHistoryFallbackMessage;
      case ChatMessageTextKey.assistantSummaryAiAndCatalog:
        return l10n.chatAssistantSummaryAiAndCatalog(
          message.aiCount ?? 0,
          message.catalogCount ?? 0,
        );
      case ChatMessageTextKey.assistantSummaryAiOnly:
        return l10n.chatAssistantSummaryAiOnly(message.aiCount ?? 0);
      case ChatMessageTextKey.assistantSummaryCatalogOnly:
        return l10n.chatAssistantSummaryCatalogOnly(message.catalogCount ?? 0);
      case ChatMessageTextKey.assistantSummaryGeneric:
        return l10n.chatAssistantSummaryGeneric;
      case ChatMessageTextKey.genericError:
        return l10n.chatGenericErrorMessage;
    }
  }
}

class _MessageAttachments extends StatelessWidget {
  const _MessageAttachments({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isBot = message.type == MessageType.bot;
    final maxBubbleWidth =
        MediaQuery.of(context).size.width * (isBot ? 0.88 : 0.75);
    final attachmentsCount = message.attachments.length;
    final itemSize = switch (attachmentsCount) {
      1 => math.min(maxBubbleWidth, AppSizes.s220.toDouble()),
      2 => math.min((maxBubbleWidth - AppSizes.s8) / 2, 156.0),
      _ => math.min((maxBubbleWidth - AppSizes.s8) / 2, 132.0),
    };

    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      alignment: isBot ? WrapAlignment.start : WrapAlignment.end,
      children: message.attachments
          .map(
            (attachment) =>
                ChatAttachmentThumbnail(attachment: attachment, size: itemSize),
          )
          .toList(),
    );
  }
}

class _GenerationStatusCard extends StatelessWidget {
  const _GenerationStatusCard({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final generation = message.generation;
    if (generation == null) {
      return const SizedBox.shrink();
    }

    final progress = generation.progress?.clamp(0, 100);
    final isFailed = generation.isFailed;
    final isCompleted = generation.isCompleted;
    final accentColor = isFailed
        ? AppColors.materialRedAccent
        : isCompleted
        ? AppColors.cyan
        : AppColors.secondary;
    final title = isFailed
        ? 'Generation failed'
        : isCompleted
        ? 'Generation complete'
        : 'Generating images';
    final subtitle = isFailed
        ? (generation.errorMessage ?? 'The image render did not finish.')
        : isCompleted
        ? (message.hasAttachments
              ? 'Your latest generated results are ready below.'
              : 'Generation finished without a preview image yet.')
        : progress != null
        ? '$progress% complete'
        : 'Preparing realtime image updates.';

    return Container(
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFailed
                    ? Icons.error_outline_rounded
                    : isCompleted
                    ? Icons.check_circle_outline_rounded
                    : Icons.auto_awesome_rounded,
                size: AppSizes.s18,
                color: accentColor,
              ),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              Expanded(
                child: AppText(
                  text: title,
                  variant: AppTextVariant.ts14,
                  textColor: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (progress != null && !isFailed)
                AppText(
                  text: '$progress%',
                  variant: AppTextVariant.ts12,
                  textColor: accentColor,
                  fontWeight: FontWeight.w700,
                ),
            ],
          ),
          const AppGap(AppSizes.s8),
          AppText(
            text: subtitle,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.78),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 4,
          ),
          if (!isFailed && !isCompleted) ...[
            const AppGap(AppSizes.s12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              child: LinearProgressIndicator(
                value: progress == null ? null : progress / 100,
                minHeight: AppSizes.s6,
                backgroundColor: AppColors.pureWhite.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.outfit});

  final ChatOutfit outfit;

  @override
  Widget build(BuildContext context) {
    final itemLabels = outfit.items
        .map(_resolveItemLabel)
        .where((value) => value.trim().isNotEmpty)
        .toList(growable: false);

    return Container(
      margin: const EdgeInsets.only(top: AppSizes.s6),
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (outfit.title?.trim().isNotEmpty == true)
            AppText(
              text: outfit.title!,
              variant: AppTextVariant.ts14,
              textColor: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          if (itemLabels.isNotEmpty) ...[
            if (outfit.title?.trim().isNotEmpty == true)
              const AppGap(AppSizes.s8),
            Wrap(
              spacing: AppSizes.s8,
              runSpacing: AppSizes.s8,
              children: itemLabels
                  .map(
                    (label) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s10,
                        vertical: AppSizes.s6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                      ),
                      child: AppText(
                        text: label,
                        variant: AppTextVariant.ts12,
                        textColor: AppColors.pureWhite.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (outfit.styleNotes?.trim().isNotEmpty == true) ...[
            const AppGap(AppSizes.s10),
            AppText(
              text: outfit.styleNotes!,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.72),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 5,
            ),
          ],
        ],
      ),
    );
  }

  String _resolveItemLabel(ChatOutfitItem item) {
    final name = item.name?.trim();
    final type = item.type?.trim();
    final style = item.style?.trim();
    final color = item.color?.trim();

    if (name != null && name.isNotEmpty) {
      if (type != null &&
          type.isNotEmpty &&
          type.toLowerCase() != name.toLowerCase()) {
        return '$name - $type';
      }
      return name;
    }

    return type ?? style ?? color ?? 'Item';
  }
}

class _IntroMessageCard extends StatelessWidget {
  const _IntroMessageCard({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GradientBorder(
      colors: const [AppColors.primary, AppColors.secondary, AppColors.cyan],
      backgroundColor: AppColors.chatBubbleBackground,
      borderRadius: AppRadius.r30,
      borderWidth: 1.2,
      enableShadow: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s20,
        vertical: AppSizes.s24,
      ),
      child: Column(
        children: [
          AppText(
            text: l10n.chatIntroTitle,
            textAlign: TextAlign.center,
            variant: AppTextVariant.ts20,
            textColor: AppColors.secondary,
            fontWeight: FontWeight.w800,
            maxLines: 2,
          ),
          const AppGap(AppSizes.s10),
          AppText(
            text: l10n.chatIntroMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts15(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w400,
            ).copyWith(height: 1.45),
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s8, left: AppSizes.s4),
      child: Row(
        children: [
          Container(
            width: AppSizes.s6,
            height: AppSizes.s6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
          AppText(
            text: label,
            variant: AppTextVariant.ts12,
            textColor: AppColors.pureWhite.withValues(alpha: 0.82),
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
