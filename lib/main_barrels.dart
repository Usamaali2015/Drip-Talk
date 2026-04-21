// Third-party libraries
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

// Core - Config & Services
export 'package:drip_talk/core/common/constants/constants_barrels.dart';
export 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
export 'package:drip_talk/core/config/app_environment.dart';
export 'package:drip_talk/core/config/env_config.dart';
export 'package:drip_talk/core/services/get_it/service_locator.dart';
export 'package:drip_talk/core/services/api/api_barrels.dart';
export 'package:drip_talk/core/utils/routes/routes_barrels.dart';
export 'package:drip_talk/core/utils/routes/app_router.dart';
export 'package:drip_talk/core/utils/app_utils/systems_utils.dart';
export 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
export 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
export 'package:drip_talk/core/utils/routes/auth_guard.dart';
export 'package:drip_talk/core/utils/responsive/device_type.dart';
export 'package:drip_talk/core/utils/responsive/responsive_bloc.dart';
export 'package:drip_talk/core/utils/responsive/responsive_event.dart';
export 'package:drip_talk/core/utils/responsive/responsive_state.dart';

// L10n
export 'package:drip_talk/l10n/app_localizations.dart';
export 'package:drip_talk/l10n/bloc/localization_bloc.dart';
export 'package:drip_talk/l10n/bloc/localization_state.dart';
export 'package:drip_talk/l10n/bloc/localization_event.dart';
export 'package:drip_talk/l10n/l10n.dart';

// Features - Barrels
export 'package:drip_talk/features/auth/barrels/auth_barrels.dart';
export 'package:drip_talk/features/auth/barrels/login_barrels.dart';
export 'package:drip_talk/features/auth/barrels/signup_barrels.dart';
export 'package:drip_talk/features/auth/barrels/profile_setup_barrels.dart';
export 'package:drip_talk/features/auth/barrels/forgot_password_barrels.dart';
export 'package:drip_talk/features/auth/barrels/otp_barrels.dart';
export 'package:drip_talk/features/auth/barrels/reset_password_barrels.dart';
export 'package:drip_talk/features/auth/barrels/two_factor_barrels.dart';
export 'package:drip_talk/features/auth/barrels/biometric_barrels.dart';

export 'package:drip_talk/features/dashboard/barrels/dashboard_barrels.dart';
export 'package:drip_talk/features/address/barrels/address_barrels.dart';
export 'package:drip_talk/features/cart/barrels/cart_barrels.dart';
export 'package:drip_talk/features/chat/barrels/chat_barrels.dart';
export 'package:drip_talk/features/contact_support/barrels/contact_support_barrels.dart';
export 'package:drip_talk/features/help_center/barrels/help_center_barrels.dart';
export 'package:drip_talk/features/legal_pages/barrels/legal_pages_barrels.dart';
export 'package:drip_talk/features/on_boarding/barrels/on_boarding_barrels.dart';
export 'package:drip_talk/features/payment_methods/barrels/payment_methods_barrels.dart';
export 'package:drip_talk/features/product/barrels/product_barrels.dart';
export 'package:drip_talk/features/return_policy/barrels/return_policy_barrels.dart';
export 'package:drip_talk/features/reviews/barrels/reviews_barrels.dart';
export 'package:drip_talk/features/shop/barrels/shop_barrels.dart'
    hide SelectCategory;
export 'package:drip_talk/features/splash/barrels/splash_barrels.dart';
export 'package:drip_talk/features/wishlist/barrels/wishlist_barrels.dart';
