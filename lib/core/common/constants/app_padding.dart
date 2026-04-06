import 'package:flutter/material.dart';

class AppPadding {
  AppPadding._();

  /// General padding values
  static const EdgeInsets allExtraSmall = EdgeInsets.all(8.0);
  static const EdgeInsets smallAll = EdgeInsets.all(10.0);

  static const EdgeInsets allSmall = EdgeInsets.all(12.0);
  static const EdgeInsets allMedium = EdgeInsets.all(16.0);

  static const EdgeInsets allMediumLarge = EdgeInsets.all(20.0);
  static const EdgeInsets allLarge = EdgeInsets.all(24.0);

  /// Horizontal padding
  static const EdgeInsets horizontalExtraSmall = EdgeInsets.symmetric(
    horizontal: 4.0,
  );
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(
    horizontal: 8.0,
  );
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  static const EdgeInsets horizontalMediumLarge = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(
    horizontal: 24.0,
  );
  static const EdgeInsets extraHorizontalLarge = EdgeInsets.symmetric(
    horizontal: 80.0,
  );


  /// Vertical padding
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: 24.0);

  /// Custom padding
  static const EdgeInsets custom = EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0);
}
