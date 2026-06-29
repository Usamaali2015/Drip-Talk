import 'package:drip_talk/features/help_center/data/models/help_center_model.dart';
import 'package:drip_talk/features/help_center/domain/models/help_center_question.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';

class HelpCenterContent {
  HelpCenterContent._();

  static String subtitle(AppLocalizations l10n) => l10n.helpCenterSubtitle;

  static String browseByCategoryTitle(AppLocalizations l10n) =>
      l10n.helpCenterBrowseByCategory;

  static String popularQuestionsTitle(AppLocalizations l10n) =>
      l10n.helpCenterPopularQuestions;

  static List<HelpCenterQuestion> questionsFor(HelpCenterItem? item) {
    final faqs = item?.faqs ?? const <HelpCenterFaq>[];
    return faqs
        .where((faq) => faq.isMeaningful)
        .map(
          (faq) => HelpCenterQuestion(
            question: faq.question!.trim(),
            answer: faq.answer!.trim(),
          ),
        )
        .toList(growable: false);
  }

  static String? iconAssetFor(HelpCenterItem item) {
    final candidates = [
      item.slug,
      item.name,
      item.type,
    ].whereType<String>().map((value) => value.trim().toLowerCase()).toList();

    final joined = candidates.join(' ');
    if (joined.contains('order') || joined.contains('track')) {
      return Assets.orderTracking;
    }
    if (joined.contains('ship') || joined.contains('deliver')) {
      return Assets.shipping;
    }
    if (joined.contains('account') || joined.contains('profile')) {
      return Assets.accountProfile;
    }
    if (joined.contains('ai') || joined.contains('style')) {
      return Assets.aiChat;
    }
    return null;
  }
}
