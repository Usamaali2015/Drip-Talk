import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
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

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final double? borderRadius;

  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
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
    this.onChanged,
    this.onSubmitted,
    this.borderRadius,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasFocus = _focusNode.hasFocus;

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
                color:hasFocus ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.ts14(context, color:colorScheme.error),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s6),
        ],

        /// TEXT FIELD
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          obscureText: widget.obscureText ? _obscure : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          style: AppTextStyles.ts14(context, color:colorScheme.onSurface),

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
            hintStyle: AppTextStyles.ts14(
              context,
              color:colorScheme.onSurfaceVariant,
            ),

            filled: true,
            fillColor: colorScheme.surface,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s12,
              vertical: AppSizes.s14,
            ),

            prefixIcon: widget.isPhone
                ? _countryPicker(context)
                : widget.prefixWidget ??
                      (widget.prefixIcon != null
                          ? Icon(
                              widget.prefixIcon,
                              color: colorScheme.onSurfaceVariant,
                            )
                          : null),

            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,

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

    return SizedBox(
      width: AppSizes.s100,
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: widget.onCountryChanged,
            initialSelection: widget.countryDialCode,
            padding: EdgeInsets.zero,
            textStyle: AppTextStyles.ts14(context, color:colorScheme.onSurface),
          ),
          Container(height: 20, width: 1, color: colorScheme.outlineVariant),
        ],
      ),
    );
  }
}
