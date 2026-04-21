import 'dart:math' as math;

import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_attachment_thumbnail.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_recommendation_card.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

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
              if (hasAttachments && hasText) const AppGap(AppSizes.s6),
              if (hasText) _MessageBubble(message: message),
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

    return sections;
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
    final itemSize = message.attachments.length == 1
        ? math.min(MediaQuery.of(context).size.width * 0.56, AppSizes.s220)
        : AppSizes.s120;

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
