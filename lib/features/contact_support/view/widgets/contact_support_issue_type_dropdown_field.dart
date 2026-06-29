import 'package:drip_talk/features/contact_support/domain/contact_support_issue_type.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ContactSupportIssueTypeDropdownField extends StatefulWidget {
  const ContactSupportIssueTypeDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final ContactSupportIssueType value;
  final List<ContactSupportIssueType> items;
  final String Function(ContactSupportIssueType item) itemLabelBuilder;
  final ValueChanged<ContactSupportIssueType> onChanged;
  final String? errorText;

  @override
  State<ContactSupportIssueTypeDropdownField> createState() =>
      _ContactSupportIssueTypeDropdownFieldState();
}

class _ContactSupportIssueTypeDropdownFieldState
    extends State<ContactSupportIssueTypeDropdownField> {
  final GlobalKey _fieldKey = GlobalKey();
  bool _isMenuOpen = false;

  Future<void> _openMenu() async {
    if (_isMenuOpen) {
      return;
    }

    final fieldContext = _fieldKey.currentContext;
    if (fieldContext == null) {
      return;
    }

    final fieldBox = fieldContext.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (fieldBox == null || overlayBox == null) {
      return;
    }

    final fieldOffset = fieldBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final fieldSize = fieldBox.size;
    final menuTop = fieldOffset.dy + fieldSize.height + AppSizes.s4;

    setState(() => _isMenuOpen = true);

    try {
      final selected = await showMenu<ContactSupportIssueType>(
        context: context,
        color: AppColors.pureWhite,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r15),
        ),
        position: RelativeRect.fromLTRB(
          fieldOffset.dx,
          menuTop,
          overlayBox.size.width - fieldOffset.dx - fieldSize.width,
          overlayBox.size.height - menuTop,
        ),
        constraints: BoxConstraints.tightFor(width: fieldSize.width),
        items: widget.items
            .map(
              (item) => PopupMenuItem<ContactSupportIssueType>(
                value: item,
                height: AppSizes.s48,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s14),
                child: AppText(
                  text: widget.itemLabelBuilder(item),
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureBlack,
                    fontWeight: item == widget.value
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      );

      if (!mounted || selected == null) {
        return;
      }

      widget.onChanged(selected);
    } finally {
      if (mounted) {
        setState(() => _isMenuOpen = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.errorText != null
        ? AppColors.red
        : AppColors.secondary;
    final borderWidth = _isMenuOpen ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: AppTextStyles.ts14(context, color: AppColors.pureWhite),
            children: [
              TextSpan(
                text: ' *',
                style: AppTextStyles.ts14(context, color: AppColors.red),
              ),
            ],
          ),
        ),
        const AppGap(AppSizes.s6),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              key: _fieldKey,
              onTap: _openMenu,
              borderRadius: BorderRadius.circular(AppRadius.r15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s14,
                  vertical: AppSizes.s14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(AppRadius.r15),
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: widget.itemLabelBuilder(widget.value),
                        style: AppTextStyles.ts14(
                          context,
                          color: AppColors.pureBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isMenuOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 160),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.pureBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const AppGap(AppSizes.s6),
          AppText(
            text: widget.errorText!,
            style: AppTextStyles.ts12(context, color: AppColors.red),
          ),
        ],
      ],
    );
  }
}
