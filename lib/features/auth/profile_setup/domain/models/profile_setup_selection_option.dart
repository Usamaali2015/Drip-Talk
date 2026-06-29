import 'package:flutter/material.dart';

class ProfileSetupOption {
  const ProfileSetupOption({required this.value, required this.label});

  final String value;
  final String label;
}

class ProfileSetupBodyTypeOption extends ProfileSetupOption {
  const ProfileSetupBodyTypeOption({
    required super.value,
    required super.label,
    required this.description,
    required this.assetPath,
  });

  final String description;
  final String assetPath;
}

class ProfileSetupSkinToneOption extends ProfileSetupOption {
  const ProfileSetupSkinToneOption({
    required super.value,
    required super.label,
    required this.description,
    required this.color,
  });

  final String description;
  final Color color;
}

class ProfileSetupColorOption extends ProfileSetupOption {
  const ProfileSetupColorOption({
    required super.value,
    required super.label,
    required this.color,
  });

  final Color color;
}
