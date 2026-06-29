import 'dart:io';

import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

enum ProfileSetupStep {
  basics,
  body,
  skin,
  style,
  height,
  weight,
  brands,
  colors,
  avoids,
  photo,
}

enum ProfileSetupHeightUnit { centimeters, feetInches }

enum ProfileSetupWeightUnit { kilograms, pounds }

extension ProfileSetupStepX on ProfileSetupStep {
  int get index => ProfileSetupStep.values.indexOf(this);

  bool get isLast => this == ProfileSetupStep.photo;

  ProfileSetupStep get next {
    final nextIndex = index + 1;
    if (nextIndex >= ProfileSetupStep.values.length) {
      return this;
    }

    return ProfileSetupStep.values[nextIndex];
  }

  ProfileSetupStep get previous {
    final previousIndex = index - 1;
    if (previousIndex < 0) {
      return this;
    }

    return ProfileSetupStep.values[previousIndex];
  }
}

class ProfileSetupFormData extends Equatable {
  const ProfileSetupFormData({
    this.name = '',
    this.phone = '',
    this.gender,
    this.dateOfBirth,
    this.country = '',
    this.city = '',
    this.bodyType,
    this.skinTone,
    this.stylePreferences = const [],
    this.budgetMin = '',
    this.budgetMax = '',
    this.favoriteColors = const [],
    this.preferredBrands = const [],
    this.height = '',
    this.heightUnit = ProfileSetupHeightUnit.feetInches,
    this.heightCm = '',
    this.heightFeet = '',
    this.heightInches = '',
    this.weight = '',
    this.weightUnit = ProfileSetupWeightUnit.kilograms,
    this.favoriteCelebrities = '',
    this.avoidStyles = '',
    this.replaceWardrobe = false,
    this.wardrobeFiles = const [],
    this.wardrobeFileUrls = const [],
    this.enabledBiometric = false,
    this.googleTwoFactorEnabled = false,
    this.googleTwoFactorCode,
  });

  factory ProfileSetupFormData.fromProfile(ProfileData? profile) {
    final source = profile ?? ProfileData.nullProfile;
    final resolvedName = _trimOrNull(source.name) ?? source.displayName;
    final parsedHeight = _parseHeight(source.height);
    final parsedWeight = _parseWeight(source.weight);
    return ProfileSetupFormData(
      name: resolvedName,
      phone: _trimOrEmpty(source.phone),
      gender: _trimOrNull(source.gender),
      dateOfBirth: source.dateOfBirth,
      country: _trimOrEmpty(source.country),
      city: _trimOrEmpty(source.city),
      bodyType: _trimOrNull(source.bodyType),
      skinTone: _trimOrNull(source.skinTone),
      stylePreferences: _splitValues(
        source.stylePreferences ?? source.preferredStyle,
      ),
      budgetMin: _formatBudget(source.budgetMin),
      budgetMax: _formatBudget(source.budgetMax),
      favoriteColors: _splitValues(
        source.favoriteColors ?? source.preferredColors,
      ),
      preferredBrands: _splitValues(source.preferredBrands),
      height: parsedHeight.rawValue,
      heightUnit: parsedHeight.unit,
      heightCm: parsedHeight.centimeters,
      heightFeet: parsedHeight.feet,
      heightInches: parsedHeight.inches,
      weight: parsedWeight.value,
      weightUnit: parsedWeight.unit,
      favoriteCelebrities: _trimOrEmpty(source.favoriteCelebrities),
      avoidStyles: _trimOrEmpty(source.avoidStyles),
      replaceWardrobe: source.replaceWardrobe ?? false,
      wardrobeFileUrls: source.wardrobeFiles,
      enabledBiometric: source.enabledBiometric ?? false,
      googleTwoFactorEnabled: source.googleTwoFactorEnabled ?? false,
    );
  }

  final String name;
  final String phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final String country;
  final String city;
  final String? bodyType;
  final String? skinTone;
  final List<String> stylePreferences;
  final String budgetMin;
  final String budgetMax;
  final List<String> favoriteColors;
  final List<String> preferredBrands;
  final String height;
  final ProfileSetupHeightUnit heightUnit;
  final String heightCm;
  final String heightFeet;
  final String heightInches;
  final String weight;
  final ProfileSetupWeightUnit weightUnit;
  final String favoriteCelebrities;
  final String avoidStyles;
  final bool replaceWardrobe;
  final List<File> wardrobeFiles;
  final List<String> wardrobeFileUrls;
  final bool enabledBiometric;
  final bool googleTwoFactorEnabled;
  final String? googleTwoFactorCode;

  String? get preferredStyleValue =>
      stylePreferences.isEmpty ? null : stylePreferences.last;

  String? get stylePreferencesText =>
      stylePreferences.isEmpty ? null : stylePreferences.join(', ');

  String? get favoriteColorsText =>
      favoriteColors.isEmpty ? null : favoriteColors.join(', ');

  String? get preferredBrandsText =>
      preferredBrands.isEmpty ? null : preferredBrands.join(', ');

  List<String> get avoidStylesList => _splitValues(avoidStyles);

  String get heightForSubmission {
    switch (heightUnit) {
      case ProfileSetupHeightUnit.centimeters:
        final centimeters = heightCm.trim();
        return centimeters.isEmpty ? '' : '$centimeters cm';
      case ProfileSetupHeightUnit.feetInches:
        final feet = heightFeet.trim();
        final inches = heightInches.trim().isEmpty ? '0' : heightInches.trim();
        return feet.isEmpty ? '' : '$feet ft $inches in';
    }
  }

  bool get hasValidHeight {
    switch (heightUnit) {
      case ProfileSetupHeightUnit.centimeters:
        final centimeters = double.tryParse(heightCm.trim());
        return centimeters != null && centimeters > 0;
      case ProfileSetupHeightUnit.feetInches:
        final feet = int.tryParse(heightFeet.trim());
        final inches = heightInches.trim().isEmpty
            ? 0
            : int.tryParse(heightInches.trim());
        return feet != null &&
            feet > 0 &&
            inches != null &&
            inches >= 0 &&
            inches < 12;
    }
  }

  String get weightForSubmission {
    final value = weight.trim();
    if (value.isEmpty) {
      return '';
    }

    switch (weightUnit) {
      case ProfileSetupWeightUnit.kilograms:
        return '$value kg';
      case ProfileSetupWeightUnit.pounds:
        return '$value lbs';
    }
  }

  bool get hasValidWeight {
    final parsedWeight = double.tryParse(weight.trim());
    return parsedWeight != null && parsedWeight > 0;
  }

  bool get hasAnyHeightSelection =>
      heightCm.trim().isNotEmpty ||
      heightFeet.trim().isNotEmpty ||
      heightInches.trim().isNotEmpty;

  bool get hasAnyWeightSelection => weight.trim().isNotEmpty;

  bool hasAnyValueForStep(ProfileSetupStep step) {
    switch (step) {
      case ProfileSetupStep.basics:
        return phone.trim().isNotEmpty ||
            gender != null ||
            dateOfBirth != null ||
            country.trim().isNotEmpty ||
            city.trim().isNotEmpty;
      case ProfileSetupStep.body:
        return _trimOrNull(bodyType) != null;
      case ProfileSetupStep.skin:
        return _trimOrNull(skinTone) != null;
      case ProfileSetupStep.style:
        return stylePreferences.isNotEmpty ||
            budgetMin.trim().isNotEmpty ||
            budgetMax.trim().isNotEmpty;
      case ProfileSetupStep.height:
        return hasAnyHeightSelection;
      case ProfileSetupStep.weight:
        return hasAnyWeightSelection;
      case ProfileSetupStep.brands:
        return preferredBrands.isNotEmpty;
      case ProfileSetupStep.colors:
        return favoriteColors.isNotEmpty;
      case ProfileSetupStep.avoids:
        return avoidStylesList.isNotEmpty;
      case ProfileSetupStep.photo:
        return wardrobePreviewCount > 0;
    }
  }

  int resolvedHeightInches({int fallback = 48}) {
    if (heightUnit == ProfileSetupHeightUnit.feetInches && hasValidHeight) {
      final feet = int.tryParse(heightFeet.trim()) ?? 0;
      final inches = int.tryParse(heightInches.trim()) ?? 0;
      return (feet * 12) + inches;
    }

    if (heightUnit == ProfileSetupHeightUnit.centimeters && hasValidHeight) {
      final centimeters = double.tryParse(heightCm.trim()) ?? 183;
      return (centimeters / 2.54).round();
    }

    return fallback;
  }

  int resolvedHeightCentimeters({int fallback = 120}) {
    if (heightUnit == ProfileSetupHeightUnit.centimeters && hasValidHeight) {
      return (double.tryParse(heightCm.trim()) ?? fallback.toDouble()).round();
    }

    if (heightUnit == ProfileSetupHeightUnit.feetInches && hasValidHeight) {
      return (resolvedHeightInches(fallback: 48) * 2.54).round();
    }

    return fallback;
  }

  int resolvedWeightValue({int kilogramFallback = 35, int poundFallback = 80}) {
    final parsedWeight = double.tryParse(weight.trim());
    if (parsedWeight != null && parsedWeight > 0) {
      return parsedWeight.round();
    }

    return weightUnit == ProfileSetupWeightUnit.kilograms
        ? kilogramFallback
        : poundFallback;
  }

  int get savedItemCount {
    var total = 0;
    final scalarValues = [
      phone,
      gender,
      dateOfBirth,
      country,
      city,
      bodyType,
      skinTone,
      budgetMin,
      budgetMax,
      heightForSubmission,
      weightForSubmission,
      favoriteCelebrities,
      avoidStyles,
    ];

    for (final value in scalarValues) {
      if (value is DateTime) {
        total++;
        continue;
      }

      final normalized = value?.toString().trim();
      if (normalized != null && normalized.isNotEmpty) {
        total++;
      }
    }

    if (stylePreferences.isNotEmpty) {
      total++;
    }
    if (favoriteColors.isNotEmpty) {
      total++;
    }
    if (preferredBrands.isNotEmpty) {
      total++;
    }

    return total;
  }

  int get wardrobePreviewCount =>
      (replaceWardrobe ? 0 : wardrobeFileUrls.length) + wardrobeFiles.length;

  ProfileSetupFormData copyWith({
    String? name,
    String? phone,
    Object? gender = _formSentinel,
    Object? dateOfBirth = _formSentinel,
    String? country,
    String? city,
    Object? bodyType = _formSentinel,
    Object? skinTone = _formSentinel,
    List<String>? stylePreferences,
    String? budgetMin,
    String? budgetMax,
    List<String>? favoriteColors,
    List<String>? preferredBrands,
    String? height,
    ProfileSetupHeightUnit? heightUnit,
    String? heightCm,
    String? heightFeet,
    String? heightInches,
    String? weight,
    ProfileSetupWeightUnit? weightUnit,
    String? favoriteCelebrities,
    String? avoidStyles,
    bool? replaceWardrobe,
    List<File>? wardrobeFiles,
    List<String>? wardrobeFileUrls,
    bool? enabledBiometric,
    bool? googleTwoFactorEnabled,
    Object? googleTwoFactorCode = _formSentinel,
  }) {
    return ProfileSetupFormData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender == _formSentinel ? this.gender : gender as String?,
      dateOfBirth: dateOfBirth == _formSentinel
          ? this.dateOfBirth
          : dateOfBirth as DateTime?,
      country: country ?? this.country,
      city: city ?? this.city,
      bodyType: bodyType == _formSentinel ? this.bodyType : bodyType as String?,
      skinTone: skinTone == _formSentinel ? this.skinTone : skinTone as String?,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      favoriteColors: favoriteColors ?? this.favoriteColors,
      preferredBrands: preferredBrands ?? this.preferredBrands,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      heightCm: heightCm ?? this.heightCm,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      favoriteCelebrities: favoriteCelebrities ?? this.favoriteCelebrities,
      avoidStyles: avoidStyles ?? this.avoidStyles,
      replaceWardrobe: replaceWardrobe ?? this.replaceWardrobe,
      wardrobeFiles: wardrobeFiles ?? this.wardrobeFiles,
      wardrobeFileUrls: wardrobeFileUrls ?? this.wardrobeFileUrls,
      enabledBiometric: enabledBiometric ?? this.enabledBiometric,
      googleTwoFactorEnabled:
          googleTwoFactorEnabled ?? this.googleTwoFactorEnabled,
      googleTwoFactorCode: googleTwoFactorCode == _formSentinel
          ? this.googleTwoFactorCode
          : googleTwoFactorCode as String?,
    );
  }

  @override
  List<Object?> get props => [
    name,
    phone,
    gender,
    dateOfBirth,
    country,
    city,
    bodyType,
    skinTone,
    stylePreferences,
    budgetMin,
    budgetMax,
    favoriteColors,
    preferredBrands,
    height,
    heightUnit,
    heightCm,
    heightFeet,
    heightInches,
    weight,
    weightUnit,
    favoriteCelebrities,
    avoidStyles,
    replaceWardrobe,
    wardrobeFiles,
    wardrobeFileUrls,
    enabledBiometric,
    googleTwoFactorEnabled,
    googleTwoFactorCode,
  ];
}

class ProfileSetupValidationErrors extends Equatable {
  const ProfileSetupValidationErrors({
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.city,
    this.bodyType,
    this.skinTone,
    this.stylePreferences,
    this.budgetMin,
    this.budgetMax,
    this.favoriteColors,
    this.preferredBrands,
    this.height,
    this.weight,
    this.favoriteCelebrities,
    this.avoidStyles,
  });

  static const empty = ProfileSetupValidationErrors();

  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? country;
  final String? city;
  final String? bodyType;
  final String? skinTone;
  final String? stylePreferences;
  final String? budgetMin;
  final String? budgetMax;
  final String? favoriteColors;
  final String? preferredBrands;
  final String? height;
  final String? weight;
  final String? favoriteCelebrities;
  final String? avoidStyles;

  bool get hasAny =>
      phone != null ||
      gender != null ||
      dateOfBirth != null ||
      country != null ||
      city != null ||
      bodyType != null ||
      skinTone != null ||
      stylePreferences != null ||
      budgetMin != null ||
      budgetMax != null ||
      favoriteColors != null ||
      preferredBrands != null ||
      height != null ||
      weight != null ||
      favoriteCelebrities != null ||
      avoidStyles != null;

  @override
  List<Object?> get props => [
    phone,
    gender,
    dateOfBirth,
    country,
    city,
    bodyType,
    skinTone,
    stylePreferences,
    budgetMin,
    budgetMax,
    favoriteColors,
    preferredBrands,
    height,
    weight,
    favoriteCelebrities,
    avoidStyles,
  ];
}

const Object _formSentinel = Object();

String _trimOrEmpty(String? value) => value?.trim() ?? '';

String? _trimOrNull(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

List<String> _splitValues(String? source) {
  final normalized = _trimOrNull(source);
  if (normalized == null) {
    return const [];
  }

  return normalized
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

String _formatBudget(double? value) {
  if (value == null) {
    return '';
  }

  final normalized = value % 1 == 0
      ? value.toInt().toString()
      : value.toString();
  return normalized;
}

_ParsedHeight _parseHeight(String? value) {
  final rawValue = _trimOrEmpty(value);
  if (rawValue.isEmpty) {
    return const _ParsedHeight(rawValue: '');
  }

  final normalized = rawValue.toLowerCase();
  final centimetersMatch = RegExp(
    r'(\d+(?:\.\d+)?)\s*(cm|centimeter|centimeters)\b',
  ).firstMatch(normalized);
  if (centimetersMatch != null) {
    return _ParsedHeight(
      rawValue: rawValue,
      unit: ProfileSetupHeightUnit.centimeters,
      centimeters: centimetersMatch.group(1) ?? '',
    );
  }

  final feetInchesMatch = RegExp(
    r'''(\d+)\s*(?:ft|feet|foot|')\s*(?:(\d+)\s*(?:in|inch|inches|"))?''',
  ).firstMatch(normalized);
  if (feetInchesMatch != null) {
    return _ParsedHeight(
      rawValue: rawValue,
      unit: ProfileSetupHeightUnit.feetInches,
      feet: feetInchesMatch.group(1) ?? '',
      inches: feetInchesMatch.group(2) ?? '',
    );
  }

  final numericValue = double.tryParse(normalized);
  if (numericValue != null) {
    if (numericValue >= 100) {
      return _ParsedHeight(
        rawValue: rawValue,
        unit: ProfileSetupHeightUnit.centimeters,
        centimeters: rawValue,
      );
    }

    return _ParsedHeight(
      rawValue: rawValue,
      unit: ProfileSetupHeightUnit.feetInches,
      feet: rawValue,
    );
  }

  return _ParsedHeight(
    rawValue: rawValue,
    unit: ProfileSetupHeightUnit.feetInches,
    feet: rawValue,
  );
}

_ParsedWeight _parseWeight(String? value) {
  final rawValue = _trimOrEmpty(value);
  if (rawValue.isEmpty) {
    return const _ParsedWeight(
      rawValue: '',
      value: '',
      unit: ProfileSetupWeightUnit.kilograms,
    );
  }

  final normalized = rawValue.toLowerCase();
  final numericMatch = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(normalized);
  final numericValue = numericMatch?.group(1) ?? '';
  final parsedNumericValue = double.tryParse(numericValue);

  if (RegExp(r'\b(kg|kgs|kilogram|kilograms)\b').hasMatch(normalized)) {
    return _ParsedWeight(
      rawValue: rawValue,
      value: numericValue,
      unit: ProfileSetupWeightUnit.kilograms,
    );
  }

  if (RegExp(r'\b(lb|lbs|pound|pounds)\b').hasMatch(normalized)) {
    return _ParsedWeight(
      rawValue: rawValue,
      value: numericValue,
      unit: ProfileSetupWeightUnit.pounds,
    );
  }

  if (parsedNumericValue != null) {
    return _ParsedWeight(
      rawValue: rawValue,
      value: _formatSingleDecimal(parsedNumericValue),
      unit: parsedNumericValue <= 90
          ? ProfileSetupWeightUnit.kilograms
          : ProfileSetupWeightUnit.pounds,
    );
  }

  return _ParsedWeight(
    rawValue: rawValue,
    value: rawValue,
    unit: ProfileSetupWeightUnit.pounds,
  );
}

class _ParsedHeight {
  const _ParsedHeight({
    required this.rawValue,
    this.unit = ProfileSetupHeightUnit.feetInches,
    this.centimeters = '',
    this.feet = '',
    this.inches = '',
  });

  final String rawValue;
  final ProfileSetupHeightUnit unit;
  final String centimeters;
  final String feet;
  final String inches;
}

class _ParsedWeight {
  const _ParsedWeight({
    required this.rawValue,
    required this.value,
    this.unit = ProfileSetupWeightUnit.pounds,
  });

  final String rawValue;
  final String value;
  final ProfileSetupWeightUnit unit;
}

String _formatSingleDecimal(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
}
