abstract class HelpCenterEvent {
  const HelpCenterEvent();
}

class LoadHelpCenterRequested extends HelpCenterEvent {
  const LoadHelpCenterRequested({this.showLoader = true});

  final bool showLoader;
}

class HelpCenterCategorySelected extends HelpCenterEvent {
  const HelpCenterCategorySelected(this.categoryId);

  final int categoryId;
}
