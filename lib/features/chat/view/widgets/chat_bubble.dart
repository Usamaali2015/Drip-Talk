import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/chat/data/models/chat_message.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_recommendation_card.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isBot = message.type == MessageType.bot;
    final hasRecommendations = message.hasRecommendations;
    final isIntroCard = message.isIntroCard;

    return Align(
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
            _MessageBubble(message: message),
            if (hasRecommendations) ...[
              const AppGap(AppSizes.s6),
              ..._buildRecommendationSections(),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecommendationSections() {
    final response = message.response;
    if (response == null) {
      return const <Widget>[];
    }

    final sections = <Widget>[];

    if (response.hasAiRecommendations) {
      sections.add(
        const _SectionLabel(label: 'AI Picks', color: AppColors.secondary),
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
        const _SectionLabel(label: 'Catalog Matches', color: AppColors.cyan),
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
                    ? Colors.redAccent.withValues(alpha: 0.5)
                    : AppColors.secondary.withValues(alpha: 0.5),
              )
            : null,
      ),
      child: AppText(
        text: message.text,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.white,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1000,
      ),
    );
  }
}

class _IntroMessageCard extends StatelessWidget {
  const _IntroMessageCard({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return GradientBorder(
      colors: const [AppColors.primary, AppColors.secondary, AppColors.cyan],
      backgroundColor: const Color(0xFF2A2346),
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
            text: message.title ?? '',
            textAlign: TextAlign.center,
            variant: AppTextVariant.ts20,
            textColor: AppColors.secondary,
            fontWeight: FontWeight.w800,
            maxLines: 2,
          ),
          const AppGap(AppSizes.s10),
          AppText(
            text: message.text,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts15(
              context,
              color: AppColors.white,
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
            textColor: Colors.white.withValues(alpha: 0.82),
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
