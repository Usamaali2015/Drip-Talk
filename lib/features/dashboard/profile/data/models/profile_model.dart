import 'package:equatable/equatable.dart';

class ProfileResponseModel {
  const ProfileResponseModel({
    this.status,
    this.message,
    this.rawData,
    this.data,
    this.errors,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final dataSource = _asMap(source?['data']);
    final rawData = UserProfilePayload.fromJson(dataSource);

    return ProfileResponseModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      rawData: rawData.isEmpty ? null : rawData,
      data: ProfileData.fromJson(dataSource),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final UserProfilePayload? rawData;
  final ProfileData? data;
  final dynamic errors;

  bool get isSuccessful {
    final normalized = status?.trim().toLowerCase();
    return normalized == null ||
        normalized == 'success' ||
        normalized == 'ok' ||
        normalized == 'created';
  }
}

class UserProfilePayload extends Equatable {
  const UserProfilePayload({this.user, this.stylistProfile});

  factory UserProfilePayload.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserProfilePayload();
    }

    final userSource = _asMap(source['user']);
    final stylistProfileSource = _asMap(source['stylist_profile']);
    final hasNestedPayload = userSource != null || stylistProfileSource != null;

    return UserProfilePayload(
      user: UserAccountProfile.fromJson(hasNestedPayload ? userSource : source),
      stylistProfile: UserStylistProfile.fromJson(stylistProfileSource),
    );
  }

  final UserAccountProfile? user;
  final UserStylistProfile? stylistProfile;

  bool get isEmpty =>
      (user == null || user!.isEmpty) &&
      (stylistProfile == null || stylistProfile!.isEmpty);

  @override
  List<Object?> get props => [user, stylistProfile];
}

class UserAccountProfile extends Equatable {
  const UserAccountProfile({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.city,
    this.height,
    this.weight,
    this.preferredStyle,
    this.stylePreferences = const [],
    this.preferredColors = const [],
    this.favoriteColors = const [],
    this.preferredBrands = const [],
    this.bodyType,
    this.skinTone,
    this.favoriteCelebrities = const [],
    this.avoidStyles = const [],
    this.preferredFit = const [],
    this.stylePatterns = const [],
    this.budgetMin,
    this.budgetMax,
    this.replaceWardrobe,
    this.wardrobeFiles = const [],
    this.enabledBiometric,
    this.googleTwoFactorEnabled,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAccountProfile.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserAccountProfile();
    }

    return UserAccountProfile(
      id: _asInt(source['id']),
      name: _asString(source['name']),
      username: _asString(
        source['username'] ?? source['user_name'] ?? source['handle'],
      ),
      email: _asString(source['email']),
      phone: _asString(source['phone']),
      profileImage: _asString(source['profile_image']),
      gender: _asString(source['gender']),
      dateOfBirth: _asString(source['date_of_birth']),
      country: _asString(source['country']),
      city: _asString(source['city']),
      height: _asString(source['height']),
      weight: _asString(source['weight']),
      preferredStyle: _asString(source['preferred_style']),
      stylePreferences: _asStringList(source['style_preferences']),
      preferredColors: _asStringList(source['preferred_colors']),
      favoriteColors: _asStringList(
        source['favorite_colors'] ?? source['preferred_colors'],
      ),
      preferredBrands: _asStringList(source['preferred_brands']),
      bodyType: _asString(source['body_type']),
      skinTone: _asString(source['skin_tone']),
      favoriteCelebrities: _asStringList(source['favorite_celebrities']),
      avoidStyles: _asStringList(source['avoid_styles']),
      preferredFit: _asStringList(source['preferred_fit']),
      stylePatterns: _asStringList(source['style_patterns']),
      budgetMin: _asDouble(source['budget_min']),
      budgetMax: _asDouble(source['budget_max']),
      replaceWardrobe: _asBool(source['replace_wardrobe']),
      wardrobeFiles: _extractWardrobeUrls([
        source['wardrobe_files'],
        source['wardrobe_images'],
        source['style_photos'],
        source['wardrobe'],
      ]),
      enabledBiometric: _asBool(
        source['enabled_biometric'] ?? source['biometric_enabled'],
      ),
      googleTwoFactorEnabled: _asBool(
        source['google2fa_enabled'] ?? source['google_2fa_enabled'],
      ),
      emailVerifiedAt: _asString(source['email_verified_at']),
      createdAt: _asString(source['created_at']),
      updatedAt: _asString(source['updated_at']),
    );
  }

  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? gender;
  final String? dateOfBirth;
  final String? country;
  final String? city;
  final String? height;
  final String? weight;
  final String? preferredStyle;
  final List<String> stylePreferences;
  final List<String> preferredColors;
  final List<String> favoriteColors;
  final List<String> preferredBrands;
  final String? bodyType;
  final String? skinTone;
  final List<String> favoriteCelebrities;
  final List<String> avoidStyles;
  final List<String> preferredFit;
  final List<String> stylePatterns;
  final double? budgetMin;
  final double? budgetMax;
  final bool? replaceWardrobe;
  final List<String> wardrobeFiles;
  final bool? enabledBiometric;
  final bool? googleTwoFactorEnabled;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  bool get isEmpty =>
      id == null &&
      !_hasText(name) &&
      !_hasText(username) &&
      !_hasText(email) &&
      !_hasText(phone) &&
      !_hasText(profileImage) &&
      !_hasText(gender) &&
      !_hasText(country) &&
      !_hasText(city) &&
      !_hasText(height) &&
      !_hasText(weight) &&
      !_hasText(preferredStyle) &&
      stylePreferences.isEmpty &&
      preferredColors.isEmpty &&
      favoriteColors.isEmpty &&
      preferredBrands.isEmpty &&
      !_hasText(bodyType) &&
      !_hasText(skinTone) &&
      favoriteCelebrities.isEmpty &&
      avoidStyles.isEmpty &&
      preferredFit.isEmpty &&
      stylePatterns.isEmpty &&
      budgetMin == null &&
      budgetMax == null &&
      replaceWardrobe == null &&
      wardrobeFiles.isEmpty &&
      enabledBiometric == null &&
      googleTwoFactorEnabled == null &&
      !_hasText(emailVerifiedAt) &&
      !_hasText(createdAt) &&
      !_hasText(updatedAt);

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    email,
    phone,
    profileImage,
    gender,
    dateOfBirth,
    country,
    city,
    height,
    weight,
    preferredStyle,
    stylePreferences,
    preferredColors,
    favoriteColors,
    preferredBrands,
    bodyType,
    skinTone,
    favoriteCelebrities,
    avoidStyles,
    preferredFit,
    stylePatterns,
    budgetMin,
    budgetMax,
    replaceWardrobe,
    wardrobeFiles,
    enabledBiometric,
    googleTwoFactorEnabled,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  ];
}

class UserStylistProfile extends Equatable {
  const UserStylistProfile({
    this.userId,
    this.profile,
    this.styleDna,
    this.wardrobe = const [],
    this.profileComplete,
    this.missingFields = const [],
    this.nextQuestion,
    this.lastInteraction,
  });

  factory UserStylistProfile.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserStylistProfile();
    }

    return UserStylistProfile(
      userId: _asInt(source['user_id']),
      profile: UserStyleProfile.fromJson(_asMap(source['profile'])),
      styleDna: UserStyleDna.fromJson(_asMap(source['style_dna'])),
      wardrobe: _parseWardrobeItems(source['wardrobe']),
      profileComplete: _asBool(source['profile_complete']),
      missingFields: _asStringList(source['missing_fields']),
      nextQuestion: _asString(source['next_question']),
      lastInteraction: _asString(source['last_interaction']),
    );
  }

  final int? userId;
  final UserStyleProfile? profile;
  final UserStyleDna? styleDna;
  final List<UserWardrobeItem> wardrobe;
  final bool? profileComplete;
  final List<String> missingFields;
  final String? nextQuestion;
  final String? lastInteraction;

  bool get isEmpty =>
      userId == null &&
      (profile == null || profile!.isEmpty) &&
      (styleDna == null || styleDna!.isEmpty) &&
      wardrobe.isEmpty &&
      profileComplete == null &&
      missingFields.isEmpty &&
      !_hasText(nextQuestion) &&
      !_hasText(lastInteraction);

  @override
  List<Object?> get props => [
    userId,
    profile,
    styleDna,
    wardrobe,
    profileComplete,
    missingFields,
    nextQuestion,
    lastInteraction,
  ];
}

class UserStyleProfile extends Equatable {
  const UserStyleProfile({
    this.age,
    this.gender,
    this.bodyType,
    this.height,
    this.weight,
    this.favoriteColors = const [],
    this.stylePreferences = const [],
    this.favoriteCelebrities = const [],
    this.avoidStyles = const [],
    this.budgetRange,
  });

  factory UserStyleProfile.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserStyleProfile();
    }

    return UserStyleProfile(
      age: _asInt(source['age']),
      gender: _asString(source['gender']),
      bodyType: _asString(source['body_type']),
      height: _asString(source['height']),
      weight: _asString(source['weight']),
      favoriteColors: _asStringList(source['favorite_colors']),
      stylePreferences: _asStringList(source['style_preferences']),
      favoriteCelebrities: _asStringList(source['favorite_celebrities']),
      avoidStyles: _asStringList(source['avoid_styles']),
      budgetRange: _asString(source['budget_range']),
    );
  }

  final int? age;
  final String? gender;
  final String? bodyType;
  final String? height;
  final String? weight;
  final List<String> favoriteColors;
  final List<String> stylePreferences;
  final List<String> favoriteCelebrities;
  final List<String> avoidStyles;
  final String? budgetRange;

  bool get isEmpty =>
      age == null &&
      !_hasText(gender) &&
      !_hasText(bodyType) &&
      !_hasText(height) &&
      !_hasText(weight) &&
      favoriteColors.isEmpty &&
      stylePreferences.isEmpty &&
      favoriteCelebrities.isEmpty &&
      avoidStyles.isEmpty &&
      !_hasText(budgetRange);

  @override
  List<Object?> get props => [
    age,
    gender,
    bodyType,
    height,
    weight,
    favoriteColors,
    stylePreferences,
    favoriteCelebrities,
    avoidStyles,
    budgetRange,
  ];
}

class UserStyleDna extends Equatable {
  const UserStyleDna({
    this.likedColors = const [],
    this.avoidedColors = const [],
    this.preferredFit = const [],
    this.stylePatterns = const [],
  });

  factory UserStyleDna.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserStyleDna();
    }

    return UserStyleDna(
      likedColors: _asStringList(source['liked_colors']),
      avoidedColors: _asStringList(source['avoided_colors']),
      preferredFit: _asStringList(source['preferred_fit']),
      stylePatterns: _asStringList(source['style_patterns']),
    );
  }

  final List<String> likedColors;
  final List<String> avoidedColors;
  final List<String> preferredFit;
  final List<String> stylePatterns;

  bool get isEmpty =>
      likedColors.isEmpty &&
      avoidedColors.isEmpty &&
      preferredFit.isEmpty &&
      stylePatterns.isEmpty;

  @override
  List<Object?> get props => [
    likedColors,
    avoidedColors,
    preferredFit,
    stylePatterns,
  ];
}

class UserWardrobeItem extends Equatable {
  const UserWardrobeItem({
    this.id,
    this.imageUrl,
    this.category,
    this.color,
    this.style,
    this.material,
    this.formality,
    this.season,
    this.tags = const [],
    this.status,
  });

  factory UserWardrobeItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return const UserWardrobeItem();
    }

    return UserWardrobeItem(
      id: _asString(source['id']),
      imageUrl: _asString(source['image_url']),
      category: _asString(source['category']),
      color: _asString(source['color']),
      style: _asString(source['style']),
      material: _asString(source['material']),
      formality: _asString(source['formality']),
      season: _asString(source['season']),
      tags: _asStringList(source['tags']),
      status: _asString(source['status']),
    );
  }

  final String? id;
  final String? imageUrl;
  final String? category;
  final String? color;
  final String? style;
  final String? material;
  final String? formality;
  final String? season;
  final List<String> tags;
  final String? status;

  bool get isEmpty =>
      !_hasText(id) &&
      !_hasText(imageUrl) &&
      !_hasText(category) &&
      !_hasText(color) &&
      !_hasText(style) &&
      !_hasText(material) &&
      !_hasText(formality) &&
      !_hasText(season) &&
      tags.isEmpty &&
      !_hasText(status);

  @override
  List<Object?> get props => [
    id,
    imageUrl,
    category,
    color,
    style,
    material,
    formality,
    season,
    tags,
    status,
  ];
}

class ProfileData extends Equatable {
  const ProfileData({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.city,
    this.height,
    this.weight,
    this.preferredStyle,
    this.stylePreferences,
    this.preferredColors,
    this.favoriteColors,
    this.preferredBrands,
    this.bodyType,
    this.skinTone,
    this.favoriteCelebrities,
    this.avoidStyles,
    this.preferredFit,
    this.stylePatterns,
    this.budgetMin,
    this.budgetMax,
    this.replaceWardrobe,
    this.wardrobeFiles = const [],
    this.enabledBiometric,
    this.googleTwoFactorEnabled,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null) {
      return nullProfile;
    }

    final hasNestedPayload =
        _asMap(source['user']) != null ||
        _asMap(source['stylist_profile']) != null;
    if (hasNestedPayload) {
      return ProfileData.fromPayload(UserProfilePayload.fromJson(source));
    }

    return ProfileData._fromFlatJson(source);
  }

  factory ProfileData.fromPayload(UserProfilePayload? payload) {
    if (payload == null || payload.isEmpty) {
      return nullProfile;
    }

    final user = payload.user;
    final stylistProfile = payload.stylistProfile;
    final profile = stylistProfile?.profile;
    final styleDna = stylistProfile?.styleDna;
    final budgetBounds = _BudgetBounds.fromValues(
      explicitMin: user?.budgetMin,
      explicitMax: user?.budgetMax,
      fallbackRange: profile?.budgetRange,
    );

    final stylePreferences = _firstNonEmptyString([
      _joinValues(user?.stylePreferences),
      _joinValues(profile?.stylePreferences),
    ]);
    final favoriteColors = _firstNonEmptyString([
      _joinValues(user?.favoriteColors),
      _joinValues(user?.preferredColors),
      _joinValues(profile?.favoriteColors),
      _joinValues(styleDna?.likedColors),
    ]);
    final preferredColors = _firstNonEmptyString([
      _joinValues(user?.preferredColors),
      _joinValues(styleDna?.likedColors),
      _joinValues(profile?.favoriteColors),
      favoriteColors,
    ]);

    return ProfileData(
      id: user?.id,
      name: user?.name,
      username: user?.username,
      email: user?.email,
      phone: user?.phone,
      profileImage: user?.profileImage,
      gender: _firstNonEmptyString([user?.gender, profile?.gender]),
      dateOfBirth: _asDateTime(user?.dateOfBirth),
      country: user?.country,
      city: user?.city,
      height: _firstNonEmptyString([user?.height, profile?.height]),
      weight: _firstNonEmptyString([user?.weight, profile?.weight]),
      preferredStyle: _firstNonEmptyString([
        user?.preferredStyle,
        _lastValue(user?.stylePreferences),
        _lastValue(profile?.stylePreferences),
      ]),
      stylePreferences: stylePreferences,
      preferredColors: preferredColors,
      favoriteColors: favoriteColors,
      preferredBrands: _joinValues(user?.preferredBrands),
      bodyType: _firstNonEmptyString([user?.bodyType, profile?.bodyType]),
      skinTone: user?.skinTone,
      favoriteCelebrities: _firstNonEmptyString([
        _joinValues(user?.favoriteCelebrities),
        _joinValues(profile?.favoriteCelebrities),
      ]),
      avoidStyles: _firstNonEmptyString([
        _joinValues(user?.avoidStyles),
        _joinValues(profile?.avoidStyles),
      ]),
      preferredFit: _firstNonEmptyString([
        _joinValues(user?.preferredFit),
        _joinValues(styleDna?.preferredFit),
      ]),
      stylePatterns: _firstNonEmptyString([
        _joinValues(user?.stylePatterns),
        _joinValues(styleDna?.stylePatterns),
      ]),
      budgetMin: budgetBounds.min,
      budgetMax: budgetBounds.max,
      replaceWardrobe: user?.replaceWardrobe,
      wardrobeFiles: _firstNonEmptyStringList([
        user?.wardrobeFiles ?? const [],
        stylistProfile?.wardrobe
                .map((item) => _asString(item.imageUrl))
                .whereType<String>()
                .toList(growable: false) ??
            const [],
      ]),
      enabledBiometric: user?.enabledBiometric,
      googleTwoFactorEnabled: user?.googleTwoFactorEnabled,
      emailVerifiedAt: _asDateTime(user?.emailVerifiedAt),
      createdAt: _asDateTime(user?.createdAt),
      updatedAt: _asDateTime(user?.updatedAt),
    );
  }

  factory ProfileData._fromFlatJson(Map<String, dynamic> json) {
    final budgetBounds = _BudgetBounds.fromValues(
      explicitMin: _asDouble(json['budget_min']),
      explicitMax: _asDouble(json['budget_max']),
      fallbackRange: _asString(json['budget_range']),
    );
    final stylePreferences = _firstNonEmptyString([
      _asJoinedString(json['style_preferences']),
      _asJoinedString(json['preferred_style']),
    ]);
    final favoriteColors = _firstNonEmptyString([
      _asJoinedString(json['favorite_colors']),
      _asJoinedString(json['preferred_colors']),
      _asJoinedString(json['liked_colors']),
    ]);
    final preferredColors = _firstNonEmptyString([
      _asJoinedString(json['preferred_colors']),
      _asJoinedString(json['liked_colors']),
      favoriteColors,
    ]);

    return ProfileData(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      username: _asString(
        json['username'] ?? json['user_name'] ?? json['handle'],
      ),
      email: _asString(json['email']),
      phone: _asString(json['phone']),
      profileImage: _asString(json['profile_image']),
      gender: _asString(json['gender']),
      dateOfBirth: _asDateTime(json['date_of_birth']),
      country: _asString(json['country']),
      city: _asString(json['city']),
      height: _asString(json['height']),
      weight: _asString(json['weight']),
      preferredStyle: _firstNonEmptyString([
        _asString(json['preferred_style']),
        _lastValue(_asStringList(json['style_preferences'])),
      ]),
      stylePreferences: stylePreferences,
      preferredColors: preferredColors,
      favoriteColors: favoriteColors,
      preferredBrands: _asJoinedString(json['preferred_brands']),
      bodyType: _asString(json['body_type']),
      skinTone: _asString(json['skin_tone']),
      favoriteCelebrities: _asJoinedString(json['favorite_celebrities']),
      avoidStyles: _asJoinedString(json['avoid_styles']),
      preferredFit: _asJoinedString(json['preferred_fit']),
      stylePatterns: _asJoinedString(json['style_patterns']),
      budgetMin: budgetBounds.min,
      budgetMax: budgetBounds.max,
      replaceWardrobe: _asBool(json['replace_wardrobe']),
      wardrobeFiles: _extractWardrobeUrls([
        json['wardrobe_files'],
        json['wardrobe_images'],
        json['wardrobe'],
        json['style_photos'],
      ]),
      enabledBiometric: _asBool(
        json['enabled_biometric'] ?? json['biometric_enabled'],
      ),
      googleTwoFactorEnabled: _asBool(
        json['google2fa_enabled'] ?? json['google_2fa_enabled'],
      ),
      emailVerifiedAt: _asDateTime(json['email_verified_at']),
      createdAt: _asDateTime(json['created_at']),
      updatedAt: _asDateTime(json['updated_at']),
    );
  }

  static const ProfileData nullProfile = ProfileData();

  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? country;
  final String? city;
  final String? height;
  final String? weight;
  final String? preferredStyle;
  final String? stylePreferences;
  final String? preferredColors;
  final String? favoriteColors;
  final String? preferredBrands;
  final String? bodyType;
  final String? skinTone;
  final String? favoriteCelebrities;
  final String? avoidStyles;
  final String? preferredFit;
  final String? stylePatterns;
  final double? budgetMin;
  final double? budgetMax;
  final bool? replaceWardrobe;
  final List<String> wardrobeFiles;
  final bool? enabledBiometric;
  final bool? googleTwoFactorEnabled;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isEmpty =>
      id == null &&
      !_hasText(name) &&
      !_hasText(username) &&
      !_hasText(email) &&
      !_hasText(phone) &&
      !_hasText(profileImage) &&
      !_hasText(gender) &&
      dateOfBirth == null &&
      !_hasText(country) &&
      !_hasText(city) &&
      !_hasText(height) &&
      !_hasText(weight) &&
      !_hasText(preferredStyle) &&
      !_hasText(stylePreferences) &&
      !_hasText(preferredColors) &&
      !_hasText(favoriteColors) &&
      !_hasText(preferredBrands) &&
      !_hasText(bodyType) &&
      !_hasText(skinTone) &&
      !_hasText(favoriteCelebrities) &&
      !_hasText(avoidStyles) &&
      !_hasText(preferredFit) &&
      !_hasText(stylePatterns) &&
      budgetMin == null &&
      budgetMax == null &&
      replaceWardrobe == null &&
      wardrobeFiles.isEmpty &&
      enabledBiometric == null &&
      googleTwoFactorEnabled == null &&
      emailVerifiedAt == null &&
      createdAt == null &&
      updatedAt == null;

  String get displayName {
    final normalizedName = name?.trim();
    if (normalizedName != null && normalizedName.isNotEmpty) {
      return normalizedName;
    }

    final normalizedEmail = email?.trim();
    if (normalizedEmail != null && normalizedEmail.isNotEmpty) {
      return normalizedEmail.split('@').first;
    }

    return 'DripTalk User';
  }

  String get usernameHandle {
    final normalizedUsername = editableUsername;
    if (normalizedUsername.isNotEmpty) {
      return '@$normalizedUsername';
    }

    return '@driptalk_user';
  }

  String get editableUsername {
    final normalizedUsername = username?.trim();
    if (normalizedUsername != null && normalizedUsername.isNotEmpty) {
      return normalizedUsername.replaceFirst(RegExp(r'^@+'), '');
    }

    final normalizedEmail = email?.trim();
    if (normalizedEmail != null && normalizedEmail.contains('@')) {
      final handle = normalizedEmail.split('@').first.trim();
      if (handle.isNotEmpty) {
        return handle;
      }
    }

    final normalizedName = name?.trim();
    if (normalizedName != null && normalizedName.isNotEmpty) {
      final slug = normalizedName
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
          .replaceAll(RegExp(r'_+'), '_')
          .replaceAll(RegExp(r'^_|_$'), '');
      if (slug.isNotEmpty) {
        return slug;
      }
    }

    return 'driptalk_user';
  }

  String get initials {
    final words = displayName
        .split(RegExp(r'\s+'))
        .where((segment) => segment.trim().isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'DT';
    }

    if (words.length == 1) {
      return _leadingCharacters(words.first, 2).toUpperCase();
    }

    return (_leadingCharacters(words.first, 1) +
            _leadingCharacters(words.last, 1))
        .toUpperCase();
  }

  Map<String, dynamic> toSessionJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'country': country,
      'city': city,
      'height': height,
      'weight': weight,
      'preferred_style': preferredStyle,
      'style_preferences': stylePreferences,
      'preferred_colors': preferredColors,
      'favorite_colors': favoriteColors,
      'preferred_brands': preferredBrands,
      'body_type': bodyType,
      'skin_tone': skinTone,
      'favorite_celebrities': favoriteCelebrities,
      'avoid_styles': avoidStyles,
      'preferred_fit': preferredFit,
      'style_patterns': stylePatterns,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'replace_wardrobe': replaceWardrobe,
      'wardrobe_files': wardrobeFiles,
      'enabled_biometric': enabledBiometric == null
          ? null
          : (enabledBiometric! ? 1 : 0),
      'google2fa_enabled': googleTwoFactorEnabled,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    email,
    phone,
    profileImage,
    gender,
    dateOfBirth,
    country,
    city,
    height,
    weight,
    preferredStyle,
    stylePreferences,
    preferredColors,
    favoriteColors,
    preferredBrands,
    bodyType,
    skinTone,
    favoriteCelebrities,
    avoidStyles,
    preferredFit,
    stylePatterns,
    budgetMin,
    budgetMax,
    replaceWardrobe,
    wardrobeFiles,
    enabledBiometric,
    googleTwoFactorEnabled,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  ];
}

class _BudgetBounds {
  const _BudgetBounds({this.min, this.max});

  factory _BudgetBounds.fromValues({
    double? explicitMin,
    double? explicitMax,
    String? fallbackRange,
  }) {
    if (explicitMin != null || explicitMax != null) {
      return _BudgetBounds(min: explicitMin, max: explicitMax);
    }

    final normalizedRange = _asString(fallbackRange);
    if (normalizedRange == null) {
      return const _BudgetBounds();
    }

    final values = RegExp(r'-?\d+(?:\.\d+)?')
        .allMatches(normalizedRange)
        .map((match) {
          return double.tryParse(match.group(0) ?? '');
        })
        .whereType<double>()
        .toList(growable: false);

    if (values.isEmpty) {
      return const _BudgetBounds();
    }

    if (values.length == 1) {
      return _BudgetBounds(min: values.first, max: values.first);
    }

    return _BudgetBounds(min: values.first, max: values.last);
  }

  final double? min;
  final double? max;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty || normalized.toLowerCase() == 'null'
      ? null
      : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '');
}

double? _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }

  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  final sanitized = normalized.replaceAll(RegExp(r'[^0-9.\-]'), '');
  return sanitized.isEmpty ? null : double.tryParse(sanitized);
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value
        .map(_asString)
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  final normalized = _asString(value);
  if (normalized == null) {
    return const [];
  }

  return normalized
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

String? _asJoinedString(dynamic value) {
  final values = _asStringList(value);
  return _joinValues(values);
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty || normalized == 'null') {
    return null;
  }
  if (normalized == '1' || normalized == 'true') {
    return true;
  }
  if (normalized == '0' || normalized == 'false') {
    return false;
  }

  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return DateTime.tryParse(normalized);
}

String? _joinValues(Iterable<String>? values) {
  if (values == null) {
    return null;
  }

  final normalized = values
      .map(_asString)
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  if (normalized.isEmpty) {
    return null;
  }

  return normalized.join(', ');
}

String? _lastValue(Iterable<String>? values) {
  if (values == null) {
    return null;
  }

  final normalized = values
      .map(_asString)
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  return normalized.isEmpty ? null : normalized.last;
}

String? _firstNonEmptyString(Iterable<String?> values) {
  for (final value in values) {
    final normalized = _asString(value);
    if (normalized != null) {
      return normalized;
    }
  }

  return null;
}

List<String> _firstNonEmptyStringList(Iterable<List<String>> values) {
  for (final value in values) {
    if (value.isNotEmpty) {
      return List<String>.unmodifiable(value);
    }
  }

  return const [];
}

List<UserWardrobeItem> _parseWardrobeItems(dynamic value) {
  if (value is! List) {
    return const [];
  }

  return value
      .map((item) => UserWardrobeItem.fromJson(_asMap(item)))
      .where((item) => !item.isEmpty)
      .toList(growable: false);
}

List<String> _extractWardrobeUrls(Iterable<dynamic> sources) {
  for (final source in sources) {
    final urls = _asWardrobeUrlList(source);
    if (urls.isNotEmpty) {
      return urls;
    }
  }

  return const [];
}

List<String> _asWardrobeUrlList(dynamic value) {
  if (value is List) {
    final urls = <String>[];
    for (final item in value) {
      if (item is Map || item is Map<String, dynamic>) {
        final source = _asMap(item);
        final url = _asString(
          source?['image_url'] ?? source?['imageUrl'] ?? source?['url'],
        );
        if (url != null) {
          urls.add(url);
        }
        continue;
      }

      final url = _asString(item);
      if (url != null) {
        urls.add(url);
      }
    }
    return urls.toList(growable: false);
  }

  final url = _asString(value);
  return url == null ? const [] : <String>[url];
}

bool _hasText(String? value) => value?.trim().isNotEmpty == true;

String _leadingCharacters(String value, int count) {
  if (value.isEmpty || count <= 0) {
    return '';
  }

  final runes = value.runes.take(count).toList();
  return String.fromCharCodes(runes);
}
