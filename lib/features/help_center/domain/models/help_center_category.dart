enum HelpCenterCategoryAction { none, chat }

class HelpCenterCategory {
  const HelpCenterCategory({
    required this.title,
    required this.iconAsset,
    this.action = HelpCenterCategoryAction.none,
  });

  final String title;
  final String iconAsset;
  final HelpCenterCategoryAction action;
}
