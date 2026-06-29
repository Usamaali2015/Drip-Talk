import 'dart:io';

import 'package:dio/dio.dart';

const String _wardrobeFilesField = 'wardrobe_files';

class UpdateProfileRequestModel {
  const UpdateProfileRequestModel({
    required this.name,
    this.username,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.profileImageFile,
    this.country,
    this.city,
    this.height,
    this.weight,
    this.bodyType,
    this.skinTone,
    this.favoriteCelebrities,
    this.preferredStyle,
    this.stylePreferences,
    this.avoidStyles,
    this.favoriteColors,
    this.preferredFit,
    this.stylePatterns,
    this.preferredBrands,
    this.budgetMin,
    this.budgetMax,
    this.replaceWardrobe,
    this.wardrobeFiles = const [],
    this.enabledBiometric,
    this.googleTwoFactorEnabled,
    this.googleTwoFactorCode,
  });

  final String name;
  final String? username;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final File? profileImageFile;
  final String? country;
  final String? city;
  final String? height;
  final String? weight;
  final String? bodyType;
  final String? skinTone;
  final String? favoriteCelebrities;
  final String? preferredStyle;
  final String? stylePreferences;
  final String? avoidStyles;
  final String? favoriteColors;
  final String? preferredFit;
  final String? stylePatterns;
  final String? preferredBrands;
  final String? budgetMin;
  final String? budgetMax;
  final bool? replaceWardrobe;
  final List<File> wardrobeFiles;
  final bool? enabledBiometric;
  final bool? googleTwoFactorEnabled;
  final String? googleTwoFactorCode;

  Map<String, dynamic> toDebugMap() {
    return <String, dynamic>{
      ..._scalarFields(),
      if (wardrobeFiles.isNotEmpty)
        _wardrobeFilesField: wardrobeFiles.map((file) => file.path).toList(),
      if (profileImageFile != null) 'profile_image': profileImageFile!.path,
    };
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap(_scalarFields());

    if (profileImageFile != null) {
      formData.files.add(
        MapEntry(
          'profile_image',
          await MultipartFile.fromFile(profileImageFile!.path),
        ),
      );
    }

    for (int i = 0; i < wardrobeFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'wardrobe_files[$i]',
          await MultipartFile.fromFile(
            wardrobeFiles[i].path,
            filename: wardrobeFiles[i].path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }

  Map<String, dynamic> _scalarFields() {
    return <String, dynamic>{
      'name': name,
      if (_normalized(username) != null)
        'username': _normalized(username)!.replaceFirst(RegExp(r'^@+'), ''),
      if (_normalized(phone) != null) 'phone': _normalized(phone),
      if (_normalized(gender) != null)
        'gender': _normalized(gender)!.toLowerCase(),
      if (_normalized(dateOfBirth) != null)
        'date_of_birth': _normalized(dateOfBirth),
      if (_normalized(country) != null) 'country': _normalized(country),
      if (_normalized(city) != null) 'city': _normalized(city),
      if (_normalized(height) != null) 'height': _normalized(height),
      if (_normalized(weight) != null) 'weight': _normalized(weight),
      if (_normalized(bodyType) != null)
        'body_type': _normalized(bodyType)!.toLowerCase(),
      if (_normalized(skinTone) != null) 'skin_tone': _normalized(skinTone),
      if (_normalized(favoriteCelebrities) != null)
        'favorite_celebrities': _normalized(favoriteCelebrities),
      if (_normalized(preferredStyle) != null)
        'preferred_style': _normalized(preferredStyle),
      if (_normalized(stylePreferences) != null)
        'style_preferences': _normalized(stylePreferences),
      if (_normalized(avoidStyles) != null)
        'avoid_styles': _normalized(avoidStyles),
      if (_normalized(favoriteColors) != null)
        'favorite_colors': _normalized(favoriteColors),
      if (_normalized(preferredFit) != null)
        'preferred_fit': _normalized(preferredFit),
      if (_normalized(stylePatterns) != null)
        'style_patterns': _normalized(stylePatterns),
      if (_normalized(preferredBrands) != null)
        'preferred_brands': _normalized(preferredBrands),
      if (_normalized(budgetMin) != null) 'budget_min': _normalized(budgetMin),
      if (_normalized(budgetMax) != null) 'budget_max': _normalized(budgetMax),
      if (replaceWardrobe != null) 'replace_wardrobe': replaceWardrobe! ? 1 : 0,
      if (enabledBiometric != null)
        'enabled_biometric': enabledBiometric! ? 1 : 0,
      if (googleTwoFactorEnabled != null)
        'google2fa_enabled': googleTwoFactorEnabled! ? 1 : 0,
      if (_normalized(googleTwoFactorCode) != null)
        'google2fa_code': _normalized(googleTwoFactorCode),
    };
  }
}

String? _normalized(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}
