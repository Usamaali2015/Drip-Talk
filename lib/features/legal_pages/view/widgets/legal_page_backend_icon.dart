import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';

class LegalPageBackendIcon extends StatelessWidget {
  const LegalPageBackendIcon({
    super.key,
    this.iconName,
    this.size = 16,
    this.color = AppColors.secondary,
  });

  final String? iconName;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      LegalPageIconResolver.resolve(iconName),
      size: size,
      color: color,
    );
  }
}

class LegalPageIconResolver {
  LegalPageIconResolver._();

  static IconData resolve(String? rawValue) {
    final compactValue = _compact(rawValue);
    if (compactValue.isEmpty) {
      return FontAwesomeIcons.fileLines;
    }

    for (final entry in _iconMatchers) {
      if (compactValue.contains(entry.$1)) {
        return entry.$2;
      }
    }

    return FontAwesomeIcons.fileLines;
  }

  static String _compact(String? value) {
    if (value == null) {
      return '';
    }

    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static const List<(String, IconData)> _iconMatchers = [
    ('account', FontAwesomeIcons.userShield),
    ('user', FontAwesomeIcons.userShield),
    ('profile', FontAwesomeIcons.userShield),
    ('responsibility', FontAwesomeIcons.userShield),
    ('privacy', FontAwesomeIcons.shieldHalved),
    ('shield', FontAwesomeIcons.shieldHalved),
    ('security', FontAwesomeIcons.shieldHalved),
    ('protect', FontAwesomeIcons.shieldHalved),
    ('data', FontAwesomeIcons.database),
    ('cookie', FontAwesomeIcons.cookieBite),
    ('payment', FontAwesomeIcons.creditCard),
    ('wallet', FontAwesomeIcons.wallet),
    ('card', FontAwesomeIcons.creditCard),
    ('order', FontAwesomeIcons.receipt),
    ('purchase', FontAwesomeIcons.receipt),
    ('refund', FontAwesomeIcons.clockRotateLeft),
    ('return', FontAwesomeIcons.clockRotateLeft),
    ('term', FontAwesomeIcons.fileContract),
    ('condition', FontAwesomeIcons.fileContract),
    ('agreement', FontAwesomeIcons.fileContract),
    ('legal', FontAwesomeIcons.scaleBalanced),
    ('rights', FontAwesomeIcons.scaleBalanced),
    ('contact', FontAwesomeIcons.envelopeOpenText),
    ('support', FontAwesomeIcons.circleInfo),
    ('policy', FontAwesomeIcons.fileLines),
    ('document', FontAwesomeIcons.fileLines),
    ('file', FontAwesomeIcons.fileLines),
    ('info', FontAwesomeIcons.circleInfo),
  ];
}
