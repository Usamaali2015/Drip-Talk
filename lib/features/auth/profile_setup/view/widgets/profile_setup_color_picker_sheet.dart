import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_shared_widgets.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileSetupColorPickerSheet extends StatefulWidget {
  const ProfileSetupColorPickerSheet({
    super.key,
    required this.title,
    required this.selectedValues,
    required this.onApplied,
  });

  final String title;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onApplied;

  @override
  State<ProfileSetupColorPickerSheet> createState() =>
      _ProfileSetupColorPickerSheetState();
}

class _ProfileSetupColorPickerSheetState
    extends State<ProfileSetupColorPickerSheet> {
  static const Color _defaultPickerColor = Colors.pink;

  late List<Color> _selectedColors;
  late Color _pickerColor;
  bool _didInitialize = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialize) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    _selectedColors = ProfileSetupLocalizedContent.colorsFromValues(
      l10n,
      widget.selectedValues,
    ).map(ProfileSetupLocalizedContent.normalizeColor).toList(growable: true);
    _pickerColor = _defaultPickerColor;
    _didInitialize = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentColorLabel = ProfileSetupLocalizedContent.colorLabelFromColor(
      l10n,
      _pickerColor,
    );
    final isCurrentColorSelected = _containsColor(_pickerColor);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1747), Color(0xFF1A1230)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
            const AppGap(AppSizes.s18),
            ProfileSetupSheetHeader(title: widget.title),
            const AppGap(AppSizes.s8),
            AppText(
              text: l10n.profileSetupPickColorsAction,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.68),
                fontWeight: FontWeight.w500,
              ),
            ),
            const AppGap(AppSizes.s18),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.s14),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.r24),
                        border: Border.all(
                          color: AppColors.pureWhite.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: AppColors.lightBg,
                          cardColor: AppColors.lightBg,
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.secondary,
                            secondary: AppColors.primary,
                            surface: AppColors.lightBg,
                            onSurface: AppColors.pureWhite,
                          ),
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: AppColors.pureWhite,
                            displayColor: AppColors.pureWhite,
                          ),
                          iconTheme: const IconThemeData(
                            color: AppColors.pureWhite,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: AppColors.pureWhite.withValues(
                              alpha: 0.06,
                            ),
                            hintStyle: AppTextStyles.ts12(
                              context,
                              color: AppColors.pureWhite.withValues(alpha: 0.6),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r16,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.pureWhite.withValues(
                                  alpha: 0.14,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r16,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r16,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.pureWhite.withValues(
                                  alpha: 0.14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: ColorPicker(
                          color: _pickerColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              _pickerColor =
                                  ProfileSetupLocalizedContent.normalizeColor(
                                    color,
                                  );
                            });
                          },
                          width: 34,
                          height: 34,
                          spacing: 10,
                          runSpacing: 10,
                          borderRadius: 18,
                          wheelDiameter: 180,
                          enableShadesSelection: false,
                          enableOpacity: false,
                          showColorName: true,
                          showColorCode: false,
                          colorCodeHasColor: true,
                          selectedPickerTypeColor: AppColors.primary,
                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.primary: true,
                            ColorPickerType.wheel: true,
                          },
                          pickerTypeLabels: const <ColorPickerType, String>{
                            ColorPickerType.primary: 'Primary',
                            ColorPickerType.wheel: 'Wheel',
                          },
                          pickerTypeTextStyle: AppTextStyles.ts12(
                            context,
                            color: AppColors.pureWhite.withValues(alpha: 0.86),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const AppGap(AppSizes.s16),
                    _SelectedColorActionTile(
                      color: _pickerColor,
                      label: currentColorLabel,
                      selected: isCurrentColorSelected,
                      onTap: () => _toggleColor(_pickerColor),
                    ),
                    if (!isCurrentColorSelected) ...[
                      const AppGap(AppSizes.s8),
                      AppText(
                        text: l10n.profileSetupColorAddHint,
                        style: AppTextStyles.ts12(
                          context,
                          color: AppColors.pureWhite.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (_selectedColors.isNotEmpty) ...[
                      const AppGap(AppSizes.s16),
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: l10n.profileSetupSelectedCountLabel(
                                _selectedColors.length,
                              ),
                              style: AppTextStyles.ts14(
                                context,
                                color: AppColors.pureWhite.withValues(
                                  alpha: 0.82,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearSelectedColors,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.s12,
                                vertical: AppSizes.s8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.circular,
                                ),
                                border: Border.all(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: AppText(
                                text: l10n.profileSetupClearAllAction,
                                style: AppTextStyles.ts12(
                                  context,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const AppGap(AppSizes.s12),
                      Wrap(
                        spacing: AppSizes.s10,
                        runSpacing: AppSizes.s10,
                        children: _selectedColors
                            .map(
                              (color) => _SelectedColorChip(
                                color: color,
                                label:
                                    ProfileSetupLocalizedContent.colorLabelFromColor(
                                      l10n,
                                      color,
                                    ),
                                onRemoved: () => _toggleColor(color),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const AppGap(AppSizes.s16),
            AppButton(
              text: l10n.profileSetupApplyAction,
              width: double.infinity,
              borderRadius: AppRadius.circular,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              onPressed: () {
                widget.onApplied(
                  _selectedColors
                      .map(ProfileSetupLocalizedContent.colorValueFromColor)
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _containsColor(Color color) {
    final normalizedColor = ProfileSetupLocalizedContent.normalizeColor(color);
    return _selectedColors.any(
      (selectedColor) => selectedColor.toARGB32() == normalizedColor.toARGB32(),
    );
  }

  void _toggleColor(Color color) {
    final normalizedColor = ProfileSetupLocalizedContent.normalizeColor(color);
    setState(() {
      if (_containsColor(normalizedColor)) {
        _selectedColors = _selectedColors
            .where(
              (selectedColor) =>
                  selectedColor.toARGB32() != normalizedColor.toARGB32(),
            )
            .toList(growable: true);
        return;
      }

      _selectedColors = [..._selectedColors, normalizedColor];
    });
  }

  void _clearSelectedColors() {
    setState(() {
      _selectedColors = <Color>[];
    });
  }
}

class _SelectedColorActionTile extends StatelessWidget {
  const _SelectedColorActionTile({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s14,
          vertical: AppSizes.s12,
        ),
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : AppColors.pureWhite.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            _ColorSwatch(color: color, size: 28),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: AppText(
                text: label,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.secondary, AppColors.primary],
                      )
                    : null,
                border: Border.all(
                  color: selected
                      ? AppColors.transparent
                      : AppColors.pureWhite.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                selected ? Icons.remove_rounded : Icons.add_rounded,
                color: AppColors.pureWhite,
                size: AppSizes.s18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedColorChip extends StatelessWidget {
  const _SelectedColorChip({
    required this.color,
    required this.label,
    required this.onRemoved,
  });

  final Color color;
  final String label;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: color.withValues(alpha: 0.72)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ColorSwatch(color: color, size: 20),
          const SizedBox(width: AppSizes.s8),
          AppText(
            text: label,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSizes.s6),
          GestureDetector(
            onTap: onRemoved,
            child: Icon(
              Icons.close_rounded,
              color: AppColors.pureWhite.withValues(alpha: 0.9),
              size: AppSizes.s16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: AppColors.pureWhite.withValues(alpha: 0.78),
          width: 1.2,
        ),
      ),
    );
  }
}
