// Models
export '../data/models/ai_collection_details_model.dart';
export '../data/models/ai_curated_model.dart';
export '../data/models/shop_model.dart';

// Repository
export '../data/repository/shop_repository.dart';

// BLoC — Shop
export '../domain/shop_bloc.dart';
export '../domain/shop_event.dart';
export '../domain/shop_state.dart';
export '../domain/shop_filters.dart';

// BLoC — AI Curated Collection Details
export '../domain/ai_curated_collection_details_bloc.dart';
export '../domain/ai_curated_collection_details_event.dart';
export '../domain/ai_curated_collection_details_state.dart';

// Views
export '../view/shop_view.dart';
export '../view/ai_curated_collections_view.dart';
export '../view/ai_curated_collection_details_view.dart';

// Widgets
export '../view/widgets/ai_curated_back_button.dart';
export '../view/widgets/ai_curated_collection_details_browser.dart';
export '../view/widgets/ai_curated_collection_hero_card.dart';
export '../view/widgets/ai_curated_collection_loading_widgets.dart';
export '../view/widgets/ai_curated_collection_tile.dart';
export '../view/widgets/ai_curated_collections_browser.dart';
export '../view/widgets/ai_promo_banner.dart';
export '../view/widgets/collection_card.dart';
export '../view/widgets/product_card.dart';
export '../view/widgets/shop_ai_curated_section.dart';
export '../view/widgets/shop_category_filter.dart';
export '../view/widgets/shop_content.dart';
export '../view/widgets/shop_initial_shimmer.dart';
export '../view/widgets/shop_pagination_controls.dart';
export '../view/widgets/shop_pagination_section.dart';
export '../view/widgets/shop_product_section.dart';

// Filter Sheet Widgets
export '../view/widgets/filter_sheet/shop_filter_bottom_sheet.dart';
export '../view/widgets/filter_sheet/shop_filter_checkbox_option.dart';
export '../view/widgets/filter_sheet/shop_filter_choice_chip.dart';
export '../view/widgets/filter_sheet/shop_filter_section_card.dart';
export 'package:flutter/material.dart';
export 'package:go_router/go_router.dart';
export 'package:flutter_bloc/flutter_bloc.dart';