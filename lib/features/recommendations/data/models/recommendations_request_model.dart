import 'dart:io';

const String _profileImageField = 'profile_image';

class RecommendationsRequestModel {
  const RecommendationsRequestModel({required this.profileImageFile});

  final File profileImageFile;

  Map<String, dynamic> toDebugMap() {
    return <String, dynamic>{_profileImageField: profileImageFile.path};
  }

  Map<String, dynamic> toQueryParameters() {
    return const <String, dynamic>{};
  }
}
