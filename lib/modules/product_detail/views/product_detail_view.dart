import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/fullscreen_image_viewer.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar dengan Image Gallery ─────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.white,
            iconTheme: const IconThemeData(color: AppColors.grey900),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Main Image
                  if (product.images.isEmpty)
                    CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.grey100,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.grey100,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.grey500,
                          size: 48,
                        ),
                      ),
                    )
                  else
                    PageView.builder(
                      controller: controller.pageController,
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => FullscreenImageViewer.show(
                            context,
                            images: controller.product.images.isNotEmpty
                                ? controller.product.images
                                : [controller.product.thumbnail],
                            initialIndex: controller.selectedImageIndex.value,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product.images[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.grey100,
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.grey100,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.grey500,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      },
                      onPageChanged: (value) {
                        controller.selectImage(value);
                      },
                    ),

                  // Image Indicator dots
                  if (product.images.length > 1)
                    Positioned(
                      bottom: AppDimensions.md,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.length,
                          (index) => Obx(() {
                            return GestureDetector(
                              onTap: () => controller.onThumbnailTap(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width:
                                    controller.selectedImageIndex.value == index
                                    ? 20
                                    : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedImageIndex.value ==
                                          index
                                      ? AppColors.primary
                                      : AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category & Brand ─────────────────────
                  Row(
                    children: [
                      _Badge(label: product.category, color: AppColors.primary),
                      const SizedBox(width: AppDimensions.xs),
                      _Badge(label: product.brand, color: AppColors.grey500),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // ── Title ─────────────────────────────────
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // ── Rating & Stock ────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: product.stock > 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.stock > 0
                            ? '${product.stock} in stock'
                            : 'Out of stock',
                        style: TextStyle(
                          color: product.stock > 0
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                          fontSize: AppDimensions.fontSm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ── Price ─────────────────────────────────
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: AppDimensions.fontXxl,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: AppDimensions.sm),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: AppDimensions.fontMd,
                            color: AppColors.grey500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSm,
                            ),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: AppDimensions.fontXs,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Description ───────────────────────────
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    product.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // ── Image Thumbnails ──────────────────────
                  if (product.images.length > 1) ...[
                    Text(
                      'Photos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.images.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppDimensions.xs),
                        itemBuilder: (context, index) => Obx(
                          () => GestureDetector(
                            onTap: () => controller.onThumbnailTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                                border: Border.all(
                                  color:
                                      controller.selectedImageIndex.value ==
                                          index
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd - 2,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product.images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: AppColors.grey100),
                                  errorWidget: (context, url, error) =>
                                      Container(color: AppColors.grey100),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Bar ────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: AppDimensions.md,
          right: AppDimensions.md,
          bottom: MediaQuery.of(context).padding.bottom + AppDimensions.md,
          top: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: product.stock > 0 ? () {} : null,
          child: Text(product.stock > 0 ? 'Add to Cart' : 'Out of Stock'),
        ),
      ),
    );
  }
}

// ── Badge Widget ──────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppDimensions.fontXs,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
