import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/l10n/app_localizations.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final String? labelText;
  final bool isRequired;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final bool obscureText;
  final bool enabled;
  final int maxLines;

  final bool isPhone;
  final String? countryDialCode;
  final ValueChanged<CountryCode>? onCountryChanged;

  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final double? borderRadius;
  final String? errorText;

  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.initialValue,
    this.labelText,
    this.isRequired = false,
    this.focusNode,
    this.nextFocus,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.isPhone = false,
    this.countryDialCode,
    this.onCountryChanged,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  TextEditingController? _internalController;
  bool _obscure = true;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null) {
      _internalController ??= TextEditingController(
        text: widget.initialValue ?? '',
      );

      final nextValue = widget.initialValue ?? '';
      if (_internalController!.text != nextValue) {
        _internalController!.value = TextEditingValue(
          text: nextValue,
          selection: TextSelection.collapsed(offset: nextValue.length),
        );
      }
      return;
    }

    if (oldWidget.controller == null) {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasFocus = _focusNode.hasFocus;
    final fieldTextColor = widget.textColor ?? colorScheme.onSurface;
    final fieldHintColor = widget.hintColor ?? colorScheme.onSurfaceVariant;
    final fieldFillColor = widget.fillColor ?? colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        if (widget.labelText != null) ...[
          RichText(
            text: TextSpan(
              text: widget.labelText!,
              style: AppTextStyles.ts14(
                context,
                color: hasFocus ? AppColors.pureWhite : AppColors.pureWhite,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.ts14(
                      context,
                      color: colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s6),
        ],

        /// TEXT FIELD
        TextField(
          controller: _effectiveController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          obscureText: widget.obscureText ? _obscure : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          style: AppTextStyles.ts14(context, color: fieldTextColor),

          inputFormatters: widget.isPhone
              ? [FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
              : null,

          onTapOutside: (_) => FocusScope.of(context).unfocus(),

          onChanged: widget.onChanged,

          onSubmitted: (value) {
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            } else {
              widget.onSubmitted?.call(value);
            }
          },

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.ts14(context, color: fieldHintColor),
            errorText: widget.errorText,
            errorStyle: AppTextStyles.ts12(context, color: AppColors.red),

            filled: true,
            fillColor: fieldFillColor,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s12,
              vertical: AppSizes.s14,
            ),

            prefixIcon: widget.isPhone
                ? _countryPicker(context)
                : widget.prefixWidget ??
                      (widget.prefixIcon != null
                          ? Icon(widget.prefixIcon, color: fieldHintColor)
                          : null),

            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: fieldHintColor.withValues(alpha: 0.7),
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : widget.suffixWidget,
            suffixIconConstraints: widget.suffixWidget == null
                ? null
                : const BoxConstraints.tightFor(
                    width: AppSizes.s40,
                    height: AppSizes.s44,
                  ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
              borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
              borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
              borderSide: BorderSide(color: AppColors.secondary, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  /// COUNTRY PICKER (PHONE FIELD)
  Widget _countryPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(AppRadius.r16);

    return SizedBox(
      width: AppSizes.s100,
      child: Row(
        children: [
          CountryCodePicker(
            key: ValueKey(widget.countryDialCode ?? ''),
            onChanged: widget.onCountryChanged,
            initialSelection: widget.countryDialCode,
            padding: EdgeInsets.zero,
            pickerStyle: PickerStyle.bottomSheet,
            barrierColor: AppColors.pureBlack.withValues(alpha: 0.55),
            dialogBackgroundColor: AppColors.lightBg,
            boxDecoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.r28),
              ),
              border: Border(
                top: BorderSide(width: 4, color: AppColors.secondary),
              ),
            ),
            dialogTextStyle: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite,
            ),
            searchStyle: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite,
            ),
            searchDecoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchCountryHint,
              hintStyle: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.55),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.pureWhite.withValues(alpha: 0.8),
              ),
              filled: true,
              fillColor: AppColors.darkBg2,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s14,
                vertical: AppSizes.s14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: AppColors.secondary.withValues(alpha: 0.24),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: AppColors.secondary,
                  width: 1.2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: AppColors.secondary.withValues(alpha: 0.24),
                ),
              ),
            ),
            closeIcon: const Icon(
              Icons.close_rounded,
              color: AppColors.pureWhite,
            ),
            builder: (selectedCountry) {
              final dialCode = selectedCountry?.dialCode ?? '+1';
              final flagUri = selectedCountry?.flagUri;
              return Padding(
                padding: const EdgeInsets.only(left: AppSizes.s12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (flagUri != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r4),
                        child: Image.asset(
                          flagUri,
                          package: 'country_code_picker',
                          width: AppSizes.s24,
                          height: AppSizes.s16,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSizes.s8),
                    ],
                    Text(
                      dialCode,
                      style: AppTextStyles.ts14(
                        context,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSizes.s4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.secondary.withValues(alpha: 0.9),
                      size: AppSizes.s18,
                    ),
                  ],
                ),
              );
            },
            textStyle: AppTextStyles.ts14(
              context,
              color: colorScheme.onSurface,
            ),
          ),
          Container(height: 20, width: 1, color: colorScheme.outlineVariant),
        ],
      ),
    );
  }
}
