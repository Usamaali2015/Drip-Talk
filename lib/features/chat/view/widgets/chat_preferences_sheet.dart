import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:flutter/material.dart';

class ChatPreferencesSheet extends StatefulWidget {
  const ChatPreferencesSheet({super.key, required this.initialPreferences});

  final AiChatUserPreferences initialPreferences;

  static Future<AiChatUserPreferences?> show(
    BuildContext context, {
    required AiChatUserPreferences initialPreferences,
  }) {
    return showModalBottomSheet<AiChatUserPreferences>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ChatPreferencesSheet(initialPreferences: initialPreferences),
    );
  }

  @override
  State<ChatPreferencesSheet> createState() => _ChatPreferencesSheetState();
}

class _ChatPreferencesSheetState extends State<ChatPreferencesSheet> {
  static const int _minBudget = 100;
  static const int _maxBudget = 20000;

  late int _stepIndex;
  late String? _selectedGender;
  late String? _selectedOccasion;
  late String? _selectedSeason;
  late double _budget;

  @override
  void initState() {
    super.initState();
    _stepIndex = 0;
    _selectedGender = widget.initialPreferences.gender;
    _selectedOccasion = widget.initialPreferences.occasion;
    _selectedSeason = widget.initialPreferences.season;
    _budget = (widget.initialPreferences.maxBudget ?? 500).toDouble().clamp(
      _minBudget.toDouble(),
      _maxBudget.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.86),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.r30),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.s20,
                  AppSizes.s8,
                  AppSizes.s20,
                  mediaQuery.padding.bottom + AppSizes.s20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppSizes.s56,
                        height: AppSizes.s4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(
                            AppRadius.circular,
                          ),
                        ),
                      ),
                    ),
                    const AppGap(AppSizes.s20),
                    _Header(stepIndex: _stepIndex),
                    const AppGap(AppSizes.s18),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: switch (_stepIndex) {
                        0 => _SelectionStep(
                          key: const ValueKey<int>(0),
                          options: _genderOptions,
                          selectedValue: _selectedGender,
                          onSelected: (value) =>
                              setState(() => _selectedGender = value),
                        ),
                        1 => _SelectionStep(
                          key: const ValueKey<int>(1),
                          options: _occasionOptions,
                          selectedValue: _selectedOccasion,
                          onSelected: (value) =>
                              setState(() => _selectedOccasion = value),
                        ),
                        2 => _SelectionStep(
                          key: const ValueKey<int>(2),
                          options: _seasonOptions,
                          selectedValue: _selectedSeason,
                          onSelected: (value) =>
                              setState(() => _selectedSeason = value),
                        ),
                        _ => _BudgetStep(
                          key: const ValueKey<int>(3),
                          budget: _budget,
                          minBudget: _minBudget,
                          maxBudget: _maxBudget,
                          onChanged: (value) => setState(() => _budget = value),
                        ),
                      },
                    ),
                    const AppGap(AppSizes.s16),
                    _FooterActions(
                      stepIndex: _stepIndex,
                      canContinue: _canContinueCurrentStep,
                      onSkip: _handleSkip,
                      onContinue: _handleContinue,
                      onSubmit: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _canContinueCurrentStep {
    switch (_stepIndex) {
      case 0:
        return _selectedGender != null;
      case 1:
        return _selectedOccasion != null;
      case 2:
        return _selectedSeason != null;
      default:
        return true;
    }
  }

  void _handleSkip() {
    if (_stepIndex >= 3) {
      return;
    }

    setState(() {
      if (_stepIndex == 0) {
        _selectedGender = null;
      } else if (_stepIndex == 1) {
        _selectedOccasion = null;
      } else if (_stepIndex == 2) {
        _selectedSeason = null;
      }
      _stepIndex += 1;
    });
  }

  void _handleContinue() {
    if (_stepIndex >= 3 || !_canContinueCurrentStep) {
      return;
    }

    setState(() => _stepIndex += 1);
  }

  void _handleSubmit() {
    Navigator.of(context).pop(
      AiChatUserPreferences(
        gender: _selectedGender,
        occasion: _selectedOccasion,
        season: _selectedSeason,
        maxBudget: _budget.round(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final title = switch (stepIndex) {
      0 => "What's your gender?",
      1 => "What's the occasion?",
      2 => 'Current season?',
      _ => 'Your budget range?',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'STEP ${stepIndex + 1} OF 4',
          variant: AppTextVariant.ts14,
          textColor: Colors.white.withValues(alpha: 0.85),
          fontWeight: FontWeight.w500,
        ),
        const AppGap(AppSizes.s6),
        AppText(
          text: title,
          variant: AppTextVariant.ts24,
          textColor: AppColors.secondary,
          fontWeight: FontWeight.w700,
        ),
        const AppGap(AppSizes.s18),
        Row(
          children: List<Widget>.generate(
            4,
            (index) => Expanded(
              child: Container(
                height: AppSizes.s4,
                margin: EdgeInsets.only(right: index == 3 ? 0 : AppSizes.s6),
                decoration: BoxDecoration(
                  color: index <= stepIndex
                      ? AppColors.secondary
                      : Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
            ),
          ),
        ),
        const AppGap(AppSizes.s12),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
      ],
    );
  }
}

class _SelectionStep extends StatelessWidget {
  const _SelectionStep({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<_PreferenceOption> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSizes.s18),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.s12,
        mainAxisSpacing: AppSizes.s14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = option.value == selectedValue;

        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r16),
          onTap: () => onSelected(option.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : _unselectedTileColor,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondary
                    : AppColors.secondary.withValues(alpha: 0.7),
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssetImage(
                  assetPath: option.iconPath,
                  width: AppSizes.s24,
                  height: AppSizes.s24,
                ),
                const AppGap(AppSizes.s10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8),
                  child: AppText(
                    text: option.label,
                    textAlign: TextAlign.center,
                    variant: AppTextVariant.ts16,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const Color _unselectedTileColor = Color(0xFF473966);

class _BudgetStep extends StatelessWidget {
  const _BudgetStep({
    super.key,
    required this.budget,
    required this.minBudget,
    required this.maxBudget,
    required this.onChanged,
  });

  final double budget;
  final int minBudget;
  final int maxBudget;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText(
                text: 'Min: \$$minBudget',
                variant: AppTextVariant.ts12,
                textColor: Colors.white.withValues(alpha: 0.72),
              ),
              const Spacer(),
              AppText(
                text: '\$${budget.round()}',
                variant: AppTextVariant.ts24,
                textColor: AppColors.secondary,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),
          const AppGap(AppSizes.s20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: AppSizes.s6,
              activeTrackColor: Colors.white.withValues(alpha: 0.22),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: AppSizes.s10,
              ),
              overlayColor: AppColors.secondary.withValues(alpha: 0.14),
            ),
            child: Slider(
              value: budget,
              min: minBudget.toDouble(),
              max: maxBudget.toDouble(),
              onChanged: onChanged,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppText(
              text: 'Max: \$$maxBudget',
              variant: AppTextVariant.ts12,
              textColor: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.stepIndex,
    required this.canContinue,
    required this.onSkip,
    required this.onContinue,
    required this.onSubmit,
  });

  final int stepIndex;
  final bool canContinue;
  final VoidCallback onSkip;
  final VoidCallback onContinue;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (stepIndex == 3) {
      return AppButton(
        text: 'Find my style',
        onPressed: onSubmit,
        gradientColors: const [AppColors.secondary, AppColors.primary],
        borderRadius: AppRadius.r16,
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Skip',
            onPressed: onSkip,
            backgroundColor: AppColors.transparent,
            borderColor: AppColors.secondary.withValues(alpha: 0.45),
            textColor: Colors.white.withValues(alpha: 0.88),
            borderRadius: AppRadius.r16,
          ),
        ),
        const AppGap(AppSizes.s12, axis: Axis.horizontal),
        Expanded(
          flex: 2,
          child: Opacity(
            opacity: canContinue ? 1 : 0.55,
            child: AppButton(
              text: 'Continue',
              onPressed: canContinue ? onContinue : null,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              borderRadius: AppRadius.r16,
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceOption {
  const _PreferenceOption({
    required this.label,
    required this.value,
    required this.iconPath,
  });

  final String label;
  final String value;
  final String iconPath;
}

const List<_PreferenceOption> _genderOptions = <_PreferenceOption>[
  _PreferenceOption(
    label: 'Male',
    value: 'male',
    iconPath: 'assets/icons/male.svg',
  ),
  _PreferenceOption(
    label: 'Female',
    value: 'female',
    iconPath: 'assets/icons/female.svg',
  ),
  _PreferenceOption(
    label: 'Non-binary',
    value: 'non_binary',
    iconPath: 'assets/icons/nonbinary.svg',
  ),
  _PreferenceOption(
    label: 'Prefer not to say',
    value: 'prefer_not_to_say',
    iconPath: 'assets/icons/stars.svg',
  ),
];

const List<_PreferenceOption> _occasionOptions = <_PreferenceOption>[
  _PreferenceOption(
    label: 'Office / Work',
    value: 'office',
    iconPath: 'assets/icons/briefcase.svg',
  ),
  _PreferenceOption(
    label: 'Party / Night Out',
    value: 'party',
    iconPath: 'assets/icons/partypoper.svg',
  ),
  _PreferenceOption(
    label: 'Casual Day',
    value: 'casual',
    iconPath: 'assets/icons/hanger.svg',
  ),
  _PreferenceOption(
    label: 'Sports / Active',
    value: 'sports',
    iconPath: 'assets/icons/fast.svg',
  ),
  _PreferenceOption(
    label: 'Wedding / Formal',
    value: 'wedding',
    iconPath: 'assets/icons/wedding.svg',
  ),
  _PreferenceOption(
    label: 'Date Night',
    value: 'date_night',
    iconPath: 'assets/icons/fav.svg',
  ),
];

const List<_PreferenceOption> _seasonOptions = <_PreferenceOption>[
  _PreferenceOption(
    label: 'Spring',
    value: 'spring',
    iconPath: 'assets/icons/lotus.svg',
  ),
  _PreferenceOption(
    label: 'Summer',
    value: 'summer',
    iconPath: 'assets/icons/sun.svg',
  ),
  _PreferenceOption(
    label: 'Autumn',
    value: 'autumn',
    iconPath: 'assets/icons/leaf.svg',
  ),
  _PreferenceOption(
    label: 'Winter',
    value: 'winter',
    iconPath: 'assets/icons/snowfalk.svg',
  ),
];
