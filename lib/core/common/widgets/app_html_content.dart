import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AppHtmlContent extends StatefulWidget {
  const AppHtmlContent({
    super.key,
    required this.html,
    this.textColor = AppColors.pureWhite,
    this.linkColor = AppColors.cyan,
    this.fadeColor = AppColors.lightBg,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    this.lineHeight = 1.5,
    this.enableReadMore = false,
    this.collapsedHeight = 140,
    this.readMoreThreshold = 220,
    this.readMoreText = 'See more',
    this.readLessText = 'See less',
    this.styleOverrides,
  });

  final String html;
  final Color textColor;
  final Color linkColor;
  final Color fadeColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double lineHeight;
  final bool enableReadMore;
  final double collapsedHeight;
  final int readMoreThreshold;
  final String readMoreText;
  final String readLessText;
  final Map<String, Style>? styleOverrides;

  @override
  State<AppHtmlContent> createState() => _AppHtmlContentState();
}

class _AppHtmlContentState extends State<AppHtmlContent> {
  bool _isExpanded = false;
  late String _plainText;

  @override
  void initState() {
    super.initState();
    _plainText = _extractPlainText(widget.html);
  }

  @override
  void didUpdateWidget(covariant AppHtmlContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html) {
      _plainText = _extractPlainText(widget.html);
      _isExpanded = false;
    }
  }

  bool get _shouldShowReadMore {
    return widget.enableReadMore &&
        _plainText.length > widget.readMoreThreshold;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.html.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    if (!_shouldShowReadMore) {
      return _buildHtml();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOut,
          firstCurve: Curves.easeInOut,
          secondCurve: Curves.easeInOut,
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: widget.collapsedHeight,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: _buildHtml(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          widget.fadeColor.withValues(alpha: 0),
                          widget.fadeColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          secondChild: _buildHtml(),
        ),
        const AppGap(AppSizes.s8),
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: AppText(
            text: _isExpanded ? widget.readLessText : widget.readMoreText,
            variant: AppTextVariant.ts14,
            fontWeight: FontWeight.w700,
            textColor: widget.linkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHtml() {
    return Html(data: widget.html, style: _buildStyles());
  }

  Map<String, Style> _buildStyles() {
    final styles = <String, Style>{
      'html': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      'body': Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: widget.textColor,
        fontSize: FontSize(widget.fontSize),
        fontWeight: widget.fontWeight,
        lineHeight: LineHeight.number(widget.lineHeight),
      ),
      'p': Style(margin: Margins.only(bottom: 10), padding: HtmlPaddings.zero),
      'ul': Style(
        margin: Margins.only(bottom: 10, left: 18),
        padding: HtmlPaddings.zero,
      ),
      'ol': Style(
        margin: Margins.only(bottom: 10, left: 18),
        padding: HtmlPaddings.zero,
      ),
      'li': Style(
        color: widget.textColor,
        lineHeight: LineHeight.number(widget.lineHeight),
      ),
      'strong': Style(color: widget.textColor, fontWeight: FontWeight.w700),
      'b': Style(color: widget.textColor, fontWeight: FontWeight.w700),
      'span': Style(color: widget.textColor),
      'div': Style(color: widget.textColor),
      'a': Style(
        color: widget.linkColor,
        textDecoration: TextDecoration.underline,
      ),
    };

    if (widget.styleOverrides != null) {
      styles.addAll(widget.styleOverrides!);
    }

    return styles;
  }

  String _extractPlainText(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
