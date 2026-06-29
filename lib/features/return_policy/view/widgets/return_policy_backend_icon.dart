import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';

class ReturnPolicyBackendIcon extends StatelessWidget {
  const ReturnPolicyBackendIcon({
    super.key,
    this.iconName,
    this.size = 18,
    this.color = AppColors.secondary,
  });

  final String? iconName;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      ReturnPolicyIconResolver.resolve(iconName),
      size: size,
      color: color,
    );
  }
}

class ReturnPolicyIconResolver {
  ReturnPolicyIconResolver._();

  static IconData resolve(String? rawValue) {
    final compactValue = _compact(rawValue);
    if (compactValue.isEmpty) {
      return FontAwesomeIcons.circleInfo;
    }

    for (final entry in _iconMatchers) {
      if (compactValue.contains(entry.$1)) {
        return entry.$2;
      }
    }

    return FontAwesomeIcons.circleInfo;
  }

  static String _compact(String? value) {
    if (value == null) {
      return '';
    }

    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static const List<(String, IconData)> _iconMatchers = [
    ('circlecheck', FontAwesomeIcons.circleCheck),
    ('checkcircle', FontAwesomeIcons.circleCheck),
    ('checkmark', FontAwesomeIcons.circleCheck),
    ('verified', FontAwesomeIcons.circleCheck),
    ('eligibility', FontAwesomeIcons.clipboardCheck),
    ('eligible', FontAwesomeIcons.clipboardCheck),
    ('clipboard', FontAwesomeIcons.clipboardCheck),
    ('inspection', FontAwesomeIcons.magnifyingGlass),
    ('inspect', FontAwesomeIcons.magnifyingGlass),
    ('search', FontAwesomeIcons.magnifyingGlass),
    ('refund', FontAwesomeIcons.moneyBillWave),
    ('payment', FontAwesomeIcons.moneyBillWave),
    ('money', FontAwesomeIcons.moneyBillWave),
    ('cash', FontAwesomeIcons.moneyBillWave),
    ('policy', FontAwesomeIcons.fileLines),
    ('detail', FontAwesomeIcons.fileLines),
    ('document', FontAwesomeIcons.fileLines),
    ('file', FontAwesomeIcons.fileLines),
    ('return', FontAwesomeIcons.arrowRotateLeft),
    ('rotateleft', FontAwesomeIcons.arrowRotateLeft),
    ('undo', FontAwesomeIcons.arrowRotateLeft),
    ('timeline', FontAwesomeIcons.clockRotateLeft),
    ('clock', FontAwesomeIcons.clockRotateLeft),
    ('time', FontAwesomeIcons.clockRotateLeft),
    ('hourglass', FontAwesomeIcons.hourglassHalf),
    ('shipping', FontAwesomeIcons.truckFast),
    ('delivery', FontAwesomeIcons.truckFast),
    ('truck', FontAwesomeIcons.truckFast),
    ('package', FontAwesomeIcons.boxOpen),
    ('parcel', FontAwesomeIcons.boxOpen),
    ('box', FontAwesomeIcons.boxOpen),
    ('product', FontAwesomeIcons.boxOpen),
    ('item', FontAwesomeIcons.boxOpen),
    ('tag', FontAwesomeIcons.tags),
    ('sale', FontAwesomeIcons.tags),
    ('list', FontAwesomeIcons.listCheck),
    ('steps', FontAwesomeIcons.listCheck),
    ('process', FontAwesomeIcons.listCheck),
    ('check', FontAwesomeIcons.circleCheck),
    ('info', FontAwesomeIcons.circleInfo),
  ];
}
