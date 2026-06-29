import 'package:drip_talk/features/help_center/domain/models/help_center_question.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterFaqList extends StatefulWidget {
  const HelpCenterFaqList({super.key, required this.questions});

  final List<HelpCenterQuestion> questions;

  @override
  State<HelpCenterFaqList> createState() => _HelpCenterFaqListState();
}

class _HelpCenterFaqListState extends State<HelpCenterFaqList> {
  int _expandedIndex = 0;

  @override
  void didUpdateWidget(covariant HelpCenterFaqList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questions != widget.questions) {
      _expandedIndex = widget.questions.isEmpty ? -1 : 0;
    }
  }

  void _toggleItem(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.questions.length,
        (index) => _HelpCenterFaqTile(
          question: widget.questions[index],
          isExpanded: index == _expandedIndex,
          onTap: () => _toggleItem(index),
        ),
      ),
    );
  }
}

class _HelpCenterFaqTile extends StatelessWidget {
  const _HelpCenterFaqTile({
    required this.question,
    required this.isExpanded,
    required this.onTap,
  });

  final HelpCenterQuestion question;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.s12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: question.question,
                    maxLines: 4,
                    style: AppTextStyles.ts16(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    isExpanded ? Icons.remove_rounded : Icons.add_rounded,
                    key: ValueKey<bool>(isExpanded),
                    color: AppColors.pureWhite,
                    size: AppSizes.s20,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            heightFactor: isExpanded ? 1 : 0,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s18),
              child: AppHtmlContent(
                html: question.answer,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                lineHeight: 1.45,
                textColor: AppColors.pureWhite.withValues(alpha: 0.68),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.pureWhite.withValues(alpha: 0.14),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
