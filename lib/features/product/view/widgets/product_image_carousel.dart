import 'package:carousel_slider/carousel_slider.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/product/domain/bloc/product_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    required this.currentIndex,
  });

  final List<String> imageUrls;
  final int currentIndex;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void didUpdateWidget(covariant ProductImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final imagesChanged = !listEquals(oldWidget.imageUrls, widget.imageUrls);
    final indexChanged = oldWidget.currentIndex != widget.currentIndex;
    if (!imagesChanged && !indexChanged) {
      return;
    }

    _syncToCurrentImage();
  }

  Future<void> _syncToCurrentImage() async {
    if (widget.imageUrls.isEmpty) {
      return;
    }

    final targetIndex = widget.currentIndex.clamp(
      0,
      widget.imageUrls.length - 1,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      if (!_carouselController.ready) {
        await _carouselController.onReady;
      }
      if (!mounted) {
        return;
      }

      _carouselController.jumpToPage(targetIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return RepaintBoundary(
        child: Container(
          height: AppSizes.s300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r30),
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: AppSizes.s56,
              color: AppColors.pureWhite.withValues(alpha: 0.9),
            ),
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: AppSizes.s300,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: false,
              initialPage: widget.currentIndex.clamp(
                0,
                widget.imageUrls.length - 1,
              ),
              enableInfiniteScroll: widget.imageUrls.length > 1,
              onPageChanged: (index, _) =>
                  context.read<ProductBloc>().add(ProductPageChanged(index)),
            ),
            items: widget.imageUrls.map((imageUrl) {
              return RepaintBoundary(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r30),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondary,
                        AppColors.cyan,
                        AppColors.primary,
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r30),
                    child: AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: AppSizes.fitWidth,
                      placeholder: Container(color: AppColors.lightBg),
                      errorWidget: Container(
                        color: AppColors.lightBg,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.pureWhite54,
                          size: AppSizes.s40,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (widget.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageUrls.asMap().entries.map((entry) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: widget.currentIndex == entry.key ? 20.0 : 8.0,
                    height: 8.0,
                    margin: AppPadding.horizontalExtraSmall,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: widget.currentIndex == entry.key
                          ? AppColors.secondary
                          : AppColors.pureWhite,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
