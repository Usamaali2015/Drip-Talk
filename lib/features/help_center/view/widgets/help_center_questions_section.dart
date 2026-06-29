import 'package:drip_talk/features/help_center/domain/models/help_center_question.dart';
import 'package:drip_talk/features/help_center/view/widgets/help_center_faq_list.dart';
import 'package:drip_talk/features/help_center/view/widgets/help_center_message_card.dart';
import 'package:drip_talk/features/help_center/view/widgets/help_center_popular_questions_heading.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterQuestionsSection extends StatelessWidget {
  const HelpCenterQuestionsSection({
    super.key,
    required this.title,
    required this.questions,
    required this.emptyMessage,
    this.boxed = false,
  });

  final String title;
  final List<HelpCenterQuestion> questions;
  final String emptyMessage;
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HelpCenterPopularQuestionsHeading(title: title),
        const AppGap(AppSizes.s12),
        if (questions.isEmpty)
          HelpCenterMessageCard(message: emptyMessage)
        else
          HelpCenterFaqList(questions: questions),
      ],
    );

    if (!boxed) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.sectionCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.24)),
      ),
      child: content,
    );
  }
}
