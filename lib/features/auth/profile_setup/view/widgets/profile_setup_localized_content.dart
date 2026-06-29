import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_brand_catalog.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_selection_option.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

export 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_selection_option.dart';

class ProfileSetupLocalizedContent {
  const ProfileSetupLocalizedContent._();

  static String stepLabel(ProfileSetupStep step, AppLocalizations l10n) {
    switch (step) {
      case ProfileSetupStep.basics:
        return l10n.profileSetupStepBasicsLabel;
      case ProfileSetupStep.body:
        return l10n.profileSetupStepBodyLabel;
      case ProfileSetupStep.skin:
        return l10n.profileSetupStepSkinLabel;
      case ProfileSetupStep.style:
        return l10n.profileSetupStepStyleLabel;
      case ProfileSetupStep.height:
        return l10n.profileSetupStepHeightLabel;
      case ProfileSetupStep.weight:
        return l10n.profileSetupStepWeightLabel;
      case ProfileSetupStep.brands:
        return l10n.profileSetupStepBrandsLabel;
      case ProfileSetupStep.colors:
        return l10n.profileSetupStepColorsLabel;
      case ProfileSetupStep.avoids:
        return l10n.profileSetupStepAvoidsLabel;
      case ProfileSetupStep.photo:
        return l10n.profileSetupStepPhotosLabel;
    }
  }

  static String stepTitle(ProfileSetupStep step, AppLocalizations l10n) {
    switch (step) {
      case ProfileSetupStep.basics:
        return l10n.profileSetupStepBasicsTitle;
      case ProfileSetupStep.body:
        return l10n.profileSetupStepBodyTitle;
      case ProfileSetupStep.skin:
        return l10n.profileSetupStepSkinTitle;
      case ProfileSetupStep.style:
        return l10n.profileSetupStepStyleTitle;
      case ProfileSetupStep.height:
        return l10n.profileSetupStepHeightTitle;
      case ProfileSetupStep.weight:
        return l10n.profileSetupStepWeightTitle;
      case ProfileSetupStep.brands:
        return l10n.profileSetupStepBrandsTitle;
      case ProfileSetupStep.colors:
        return l10n.profileSetupStepColorsTitle;
      case ProfileSetupStep.avoids:
        return l10n.profileSetupStepAvoidsTitle;
      case ProfileSetupStep.photo:
        return l10n.profileSetupStepPhotosTitle;
    }
  }

  static String stepSubtitle(ProfileSetupStep step, AppLocalizations l10n) {
    switch (step) {
      case ProfileSetupStep.basics:
        return l10n.profileSetupStepBasicsSubtitle;
      case ProfileSetupStep.body:
        return l10n.profileSetupStepBodySubtitle;
      case ProfileSetupStep.skin:
        return l10n.profileSetupStepSkinSubtitle;
      case ProfileSetupStep.style:
        return l10n.profileSetupStepStyleSubtitle;
      case ProfileSetupStep.height:
        return l10n.profileSetupStepHeightSubtitle;
      case ProfileSetupStep.weight:
        return l10n.profileSetupStepWeightSubtitle;
      case ProfileSetupStep.brands:
        return l10n.profileSetupStepBrandsSubtitle;
      case ProfileSetupStep.colors:
        return l10n.profileSetupStepColorsSubtitle;
      case ProfileSetupStep.avoids:
        return l10n.profileSetupStepAvoidsSubtitle;
      case ProfileSetupStep.photo:
        return l10n.profileSetupStepPhotosSubtitle;
    }
  }

  static List<ProfileSetupOption> genderOptions(AppLocalizations l10n) => [
    ProfileSetupOption(value: 'Male', label: l10n.profileSetupOptionGenderMale),
    ProfileSetupOption(
      value: 'Female',
      label: l10n.profileSetupOptionGenderFemale,
    ),
    ProfileSetupOption(
      value: 'Non-binary',
      label: l10n.profileSetupOptionGenderNonBinary,
    ),
  ];

  static List<ProfileSetupBodyTypeOption> bodyTypeOptions(
    AppLocalizations l10n,
  ) => [
    ProfileSetupBodyTypeOption(
      value: 'Slim',
      label: l10n.profileSetupOptionBodyTypeSlim,
      description: l10n.profileSetupOptionBodyTypeSlimDescription,
      assetPath: Assets.slim,
    ),
    ProfileSetupBodyTypeOption(
      value: 'Athletic',
      label: l10n.profileSetupOptionBodyTypeAthletic,
      description: l10n.profileSetupOptionBodyTypeAthleticDescription,
      assetPath: Assets.athletic,
    ),
    ProfileSetupBodyTypeOption(
      value: 'Regular',
      label: l10n.profileSetupOptionBodyTypeAverage,
      description: l10n.profileSetupOptionBodyTypeAverageDescription,
      assetPath: Assets.average,
    ),
    ProfileSetupBodyTypeOption(
      value: 'Curvy',
      label: l10n.profileSetupOptionBodyTypeCurvy,
      description: l10n.profileSetupOptionBodyTypeCurvyDescription,
      assetPath: Assets.curvy,
    ),
    ProfileSetupBodyTypeOption(
      value: 'Plus Size',
      label: l10n.profileSetupOptionBodyTypePlus,
      description: l10n.profileSetupOptionBodyTypePlusDescription,
      assetPath: Assets.plus,
    ),
    ProfileSetupBodyTypeOption(
      value: 'Muscular',
      label: l10n.profileSetupOptionBodyTypeMuscular,
      description: l10n.profileSetupOptionBodyTypeMuscularDescription,
      assetPath: Assets.muscular,
    ),
  ];

  static List<ProfileSetupSkinToneOption> skinToneOptions(
    AppLocalizations l10n,
  ) => [
    ProfileSetupSkinToneOption(
      value: 'Porcelain',
      label: l10n.profileSetupOptionSkinTonePorcelain,
      description: l10n.profileSetupOptionSkinTonePorcelainDescription,
      color: const Color(0xFFF6DFC8),
    ),
    ProfileSetupSkinToneOption(
      value: 'Ivory',
      label: l10n.profileSetupOptionSkinToneIvory,
      description: l10n.profileSetupOptionSkinToneIvoryDescription,
      color: const Color(0xFFF1CEA7),
    ),
    ProfileSetupSkinToneOption(
      value: 'Light',
      label: l10n.profileSetupOptionSkinToneLight,
      description: l10n.profileSetupOptionSkinToneLightDescription,
      color: const Color(0xFFE1B180),
    ),
    ProfileSetupSkinToneOption(
      value: 'Beige',
      label: l10n.profileSetupOptionSkinToneBeige,
      description: l10n.profileSetupOptionSkinToneBeigeDescription,
      color: const Color(0xFFC99062),
    ),
    ProfileSetupSkinToneOption(
      value: 'Honey',
      label: l10n.profileSetupOptionSkinToneHoney,
      description: l10n.profileSetupOptionSkinToneHoneyDescription,
      color: const Color(0xFFB77945),
    ),
    ProfileSetupSkinToneOption(
      value: 'Caramel',
      label: l10n.profileSetupOptionSkinToneCaramel,
      description: l10n.profileSetupOptionSkinToneCaramelDescription,
      color: const Color(0xFF9C6234),
    ),
    ProfileSetupSkinToneOption(
      value: 'Mahogany',
      label: l10n.profileSetupOptionSkinToneMahogany,
      description: l10n.profileSetupOptionSkinToneMahoganyDescription,
      color: const Color(0xFF764123),
    ),
    ProfileSetupSkinToneOption(
      value: 'Espresso',
      label: l10n.profileSetupOptionSkinToneEspresso,
      description: l10n.profileSetupOptionSkinToneEspressoDescription,
      color: const Color(0xFF4E2A19),
    ),
  ];

  static List<ProfileSetupOption> styleOptions(AppLocalizations l10n) => [
    ProfileSetupOption(
      value: 'Formal',
      label: l10n.profileSetupOptionStyleFormal,
    ),
    ProfileSetupOption(
      value: 'Streetwear',
      label: l10n.profileSetupOptionStyleStreetwear,
    ),
    ProfileSetupOption(
      value: 'Casual',
      label: l10n.profileSetupOptionStyleCasual,
    ),
    ProfileSetupOption(
      value: 'Luxury',
      label: l10n.profileSetupOptionStyleLuxury,
    ),
    ProfileSetupOption(
      value: 'Vintage',
      label: l10n.profileSetupOptionStyleVintage,
    ),
    ProfileSetupOption(
      value: 'Sporty',
      label: l10n.profileSetupOptionStyleSporty,
    ),
    ProfileSetupOption(
      value: 'Bohemian',
      label: l10n.profileSetupOptionStyleBohemian,
    ),
    ProfileSetupOption(
      value: 'Minimalist',
      label: l10n.profileSetupOptionStyleMinimalist,
    ),
  ];

  static List<ProfileSetupOption> avoidStyleOptions(AppLocalizations l10n) => [
    ProfileSetupOption(
      value: 'Formal',
      label: l10n.profileSetupOptionAvoidStyleFormal,
    ),
    ProfileSetupOption(
      value: 'Streetwears',
      label: l10n.profileSetupOptionAvoidStyleStreetwears,
    ),
    ProfileSetupOption(
      value: 'Casual',
      label: l10n.profileSetupOptionAvoidStyleCasual,
    ),
    ProfileSetupOption(
      value: 'Luxury',
      label: l10n.profileSetupOptionAvoidStyleLuxury,
    ),
    ProfileSetupOption(
      value: 'Vintage',
      label: l10n.profileSetupOptionAvoidStyleVintage,
    ),
    ProfileSetupOption(
      value: 'Sporty',
      label: l10n.profileSetupOptionAvoidStyleSporty,
    ),
    ProfileSetupOption(
      value: 'Minimalist',
      label: l10n.profileSetupOptionAvoidStyleMinimalist,
    ),
    ProfileSetupOption(
      value: 'Romantic',
      label: l10n.profileSetupOptionAvoidStyleRomantic,
    ),
    ProfileSetupOption(
      value: 'Gothic',
      label: l10n.profileSetupOptionAvoidStyleGothic,
    ),
    ProfileSetupOption(
      value: 'Bohemian',
      label: l10n.profileSetupOptionAvoidStyleBohemian,
    ),
    ProfileSetupOption(
      value: 'Maximalist',
      label: l10n.profileSetupOptionAvoidStyleMaximalist,
    ),
    ProfileSetupOption(
      value: 'Cottagecore',
      label: l10n.profileSetupOptionAvoidStyleCottagecore,
    ),
    ProfileSetupOption(
      value: 'Athleisure',
      label: l10n.profileSetupOptionAvoidStyleAthleisure,
    ),
    ProfileSetupOption(
      value: 'Preppy',
      label: l10n.profileSetupOptionAvoidStylePreppy,
    ),
    ProfileSetupOption(
      value: 'Beach',
      label: l10n.profileSetupOptionAvoidStyleBeach,
    ),
    ProfileSetupOption(
      value: 'Grunge',
      label: l10n.profileSetupOptionAvoidStyleGrunge,
    ),
    ProfileSetupOption(
      value: 'Soft Girl',
      label: l10n.profileSetupOptionAvoidStyleSoftGirl,
    ),
  ];

  static List<ProfileSetupOption> brandOptions(AppLocalizations _) =>
      ProfileSetupBrandCatalog.allBrands
          .map((brand) => ProfileSetupOption(value: brand, label: brand))
          .toList(growable: false);

  static List<ProfileSetupOption> featuredBrandOptions(AppLocalizations l10n) =>
      brandOptions(
        l10n,
      ).take(ProfileSetupBrandCatalog.featuredLimit).toList(growable: false);

  static List<ProfileSetupOption> countryOptions(AppLocalizations l10n) => [
    ProfileSetupOption(
      value: 'Pakistan',
      label: l10n.profileSetupOptionCountryPakistan,
    ),
    ProfileSetupOption(
      value: 'United States',
      label: l10n.profileSetupOptionCountryUnitedStates,
    ),
    ProfileSetupOption(
      value: 'United Kingdom',
      label: l10n.profileSetupOptionCountryUnitedKingdom,
    ),
    ProfileSetupOption(
      value: 'United Arab Emirates',
      label: l10n.profileSetupOptionCountryUnitedArabEmirates,
    ),
    ProfileSetupOption(
      value: 'Canada',
      label: l10n.profileSetupOptionCountryCanada,
    ),
  ];

  static List<ProfileSetupOption> cityOptions(
    AppLocalizations l10n,
    String countryValue,
  ) {
    switch (countryValue) {
      case 'Pakistan':
        return [
          ProfileSetupOption(
            value: 'Lahore',
            label: l10n.profileSetupOptionCityLahore,
          ),
          ProfileSetupOption(
            value: 'Karachi',
            label: l10n.profileSetupOptionCityKarachi,
          ),
          ProfileSetupOption(
            value: 'Islamabad',
            label: l10n.profileSetupOptionCityIslamabad,
          ),
          ProfileSetupOption(
            value: 'Rawalpindi',
            label: l10n.profileSetupOptionCityRawalpindi,
          ),
        ];
      case 'United States':
        return [
          ProfileSetupOption(
            value: 'New York',
            label: l10n.profileSetupOptionCityNewYork,
          ),
          ProfileSetupOption(
            value: 'Los Angeles',
            label: l10n.profileSetupOptionCityLosAngeles,
          ),
          ProfileSetupOption(
            value: 'Chicago',
            label: l10n.profileSetupOptionCityChicago,
          ),
          ProfileSetupOption(
            value: 'Houston',
            label: l10n.profileSetupOptionCityHouston,
          ),
        ];
      case 'United Kingdom':
        return [
          ProfileSetupOption(
            value: 'London',
            label: l10n.profileSetupOptionCityLondon,
          ),
          ProfileSetupOption(
            value: 'Manchester',
            label: l10n.profileSetupOptionCityManchester,
          ),
          ProfileSetupOption(
            value: 'Birmingham',
            label: l10n.profileSetupOptionCityBirmingham,
          ),
          ProfileSetupOption(
            value: 'Leeds',
            label: l10n.profileSetupOptionCityLeeds,
          ),
        ];
      case 'United Arab Emirates':
        return [
          ProfileSetupOption(
            value: 'Dubai',
            label: l10n.profileSetupOptionCityDubai,
          ),
          ProfileSetupOption(
            value: 'Abu Dhabi',
            label: l10n.profileSetupOptionCityAbuDhabi,
          ),
          ProfileSetupOption(
            value: 'Sharjah',
            label: l10n.profileSetupOptionCitySharjah,
          ),
          ProfileSetupOption(
            value: 'Ajman',
            label: l10n.profileSetupOptionCityAjman,
          ),
        ];
      case 'Canada':
        return [
          ProfileSetupOption(
            value: 'Toronto',
            label: l10n.profileSetupOptionCityToronto,
          ),
          ProfileSetupOption(
            value: 'Vancouver',
            label: l10n.profileSetupOptionCityVancouver,
          ),
          ProfileSetupOption(
            value: 'Montreal',
            label: l10n.profileSetupOptionCityMontreal,
          ),
          ProfileSetupOption(
            value: 'Calgary',
            label: l10n.profileSetupOptionCityCalgary,
          ),
        ];
      default:
        return const [];
    }
  }

  static List<ProfileSetupColorOption> colorOptions(AppLocalizations l10n) => [
    ProfileSetupColorOption(
      value: 'Blue',
      label: l10n.profileSetupOptionColorBlue,
      color: const Color(0xFF57C6F8),
    ),
    ProfileSetupColorOption(
      value: 'Red',
      label: l10n.profileSetupOptionColorRed,
      color: const Color(0xFFFF5C74),
    ),
    ProfileSetupColorOption(
      value: 'Black',
      label: l10n.profileSetupOptionColorBlack,
      color: const Color(0xFF1B1627),
    ),
    ProfileSetupColorOption(
      value: 'White',
      label: l10n.profileSetupOptionColorWhite,
      color: AppColors.pureWhite,
    ),
    ProfileSetupColorOption(
      value: 'Green',
      label: l10n.profileSetupOptionColorGreen,
      color: const Color(0xFF7ED300),
    ),
    ProfileSetupColorOption(
      value: 'Wine',
      label: l10n.profileSetupOptionColorWine,
      color: const Color(0xFF8E3E47),
    ),
    ProfileSetupColorOption(
      value: 'Navy',
      label: l10n.profileSetupOptionColorNavy,
      color: const Color(0xFF1F295D),
    ),
    ProfileSetupColorOption(
      value: 'Beige',
      label: l10n.profileSetupOptionColorBeige,
      color: const Color(0xFFF2E5C8),
    ),
    ProfileSetupColorOption(
      value: 'Brown',
      label: l10n.profileSetupOptionColorBrown,
      color: const Color(0xFF8C5A4B),
    ),
    ProfileSetupColorOption(
      value: 'Gray',
      label: l10n.profileSetupOptionColorGray,
      color: const Color(0xFF8C96B2),
    ),
    ProfileSetupColorOption(
      value: 'Purple',
      label: l10n.profileSetupOptionColorPurple,
      color: const Color(0xFF8C63FF),
    ),
  ];

  static List<ProfileSetupColorOption> selectedColorOptions(
    AppLocalizations l10n,
    List<String> selectedValues,
  ) {
    final resolvedOptions = <ProfileSetupColorOption>[];
    final seenValues = <String>{};
    for (final selectedValue in selectedValues) {
      final option = colorOptionFromValue(l10n, selectedValue);
      if (option == null) {
        continue;
      }

      final normalizedValue = option.value.trim().toUpperCase();
      if (!seenValues.add(normalizedValue)) {
        continue;
      }

      resolvedOptions.add(option);
    }
    return resolvedOptions;
  }

  static List<Color> colorsFromValues(
    AppLocalizations l10n,
    List<String> selectedValues,
  ) {
    return selectedColorOptions(
      l10n,
      selectedValues,
    ).map((option) => option.color).toList(growable: false);
  }

  static ProfileSetupColorOption? colorOptionFromValue(
    AppLocalizations l10n,
    String? value,
  ) {
    final normalizedValue = value?.trim();
    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }

    for (final option in colorOptions(l10n)) {
      if (matchesValue(option.value, normalizedValue)) {
        return option;
      }
    }

    final parsedColor = tryParseColorValue(normalizedValue);
    if (parsedColor == null) {
      return null;
    }

    final formattedValue = colorValueFromColor(parsedColor);
    return ProfileSetupColorOption(
      value: formattedValue,
      label: colorLabelFromColor(l10n, parsedColor),
      color: parsedColor,
    );
  }

  static Color? tryParseColorValue(String? value) {
    final normalizedValue = value?.trim();
    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }

    final hexValue = normalizedValue
        .replaceFirst('#', '')
        .replaceFirst(RegExp(r'^0x', caseSensitive: false), '');

    if (RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hexValue)) {
      return Color(int.parse('FF$hexValue', radix: 16));
    }

    if (RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(hexValue)) {
      return Color(int.parse(hexValue, radix: 16));
    }

    return null;
  }

  static Color normalizeColor(Color color) {
    return Color(color.toARGB32() | 0xFF000000);
  }

  static String colorValueFromColor(Color color) {
    final normalizedColor = normalizeColor(color);
    final hexValue = (normalizedColor.toARGB32() & 0x00FFFFFF)
        .toRadixString(16)
        .padLeft(6, '0')
        .toUpperCase();
    return '#$hexValue';
  }

  static String colorLabelFromColor(AppLocalizations l10n, Color color) {
    final normalizedColor = normalizeColor(color);

    for (final option in colorOptions(l10n)) {
      final optionColor = normalizeColor(option.color);
      if (optionColor.toARGB32() == normalizedColor.toARGB32()) {
        return option.label;
      }
    }

    return ColorTools.nameThatColor(normalizedColor);
  }

  static String? resolveLabel(
    List<ProfileSetupOption> options,
    String? selectedValue,
  ) {
    if (selectedValue == null || selectedValue.trim().isEmpty) {
      return null;
    }

    for (final option in options) {
      if (matchesValue(option.value, selectedValue)) {
        return option.label;
      }
    }

    return selectedValue;
  }

  static bool matchesValue(String? left, String? right) {
    if (left == null || right == null) {
      return false;
    }

    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }

  static bool containsValue(List<String> values, String selectedValue) {
    for (final value in values) {
      if (matchesValue(value, selectedValue)) {
        return true;
      }
    }

    return false;
  }
}
