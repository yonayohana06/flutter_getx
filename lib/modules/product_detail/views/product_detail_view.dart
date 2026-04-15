import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/fullscreen_image_viewer.dart';
import '../../../data/models/product_model.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.white;
    final fgColor = isDark ? AppColors.white : AppColors.grey900;
    return Scaffold(
      body: GetBuilder<ProductDetailController>(
        builder: (ctrl) => CustomScrollView(
          controller: ctrl.scrollController,

          slivers: [
            // ── Image Gallery ──────────────────────────────
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: bgColor,
              iconTheme: IconThemeData(color: fgColor),
              // Title dengan animasi fade
              title: Obx(
                () => AnimatedOpacity(
                  opacity: ctrl.isTitleVisible.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    ctrl.product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    PageView.builder(
                      controller: ctrl.pageController,
                      onPageChanged: ctrl.onPageChanged,
                      itemCount: ctrl.product.images.isNotEmpty
                          ? ctrl.product.images.length
                          : 1,
                      itemBuilder: (BuildContext context, int index) {
                        final imageUrl = ctrl.product.images.isNotEmpty
                            ? ctrl.product.images[index]
                            : ctrl.product.thumbnail;

                        return GestureDetector(
                          onTap: () => FullscreenImageViewer.show(
                            context,
                            images: ctrl.product.images.isNotEmpty
                                ? ctrl.product.images
                                : [ctrl.product.thumbnail],
                            initialIndex: ctrl.selectedImageIndex.value,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (
                                  BuildContext context,
                                  String url,
                                  DownloadProgress downloadProgress,
                                ) => Container(
                                  color: AppColors.grey100,
                                  child: Center(
                                    child: CircularProgressIndicator.adaptive(
                                      value: downloadProgress.progress,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (
                                  BuildContext context,
                                  String url,
                                  Object error,
                                ) => Container(
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
                    ),

                    // Dot indicator
                    if (ctrl.product.images.length > 1)
                      Positioned(
                        bottom: AppDimensions.md,
                        left: 0,
                        right: 0,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              ctrl.product.images.length,
                              (int index) => GestureDetector(
                                onTap: () => ctrl.selectImage(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: ctrl.selectedImageIndex.value == index
                                      ? 20
                                      : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color:
                                        ctrl.selectedImageIndex.value == index
                                        ? AppColors.primary
                                        : AppColors.primaryLight.withValues(
                                            alpha: 0.6,
                                          ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Counter
                    if (ctrl.product.images.length > 1)
                      Positioned(
                        top: AppDimensions.md + 40,
                        right: AppDimensions.md,
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.sm,
                              vertical: AppDimensions.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              '${ctrl.selectedImageIndex.value + 1}/${ctrl.product.images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppDimensions.fontXs,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Content ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Tags & Brand ───────────────────────
                    Wrap(
                      spacing: AppDimensions.xs,
                      children: [
                        _Badge(
                          label: ctrl.product.category,
                          color: AppColors.primary,
                        ),
                        if (ctrl.product.brand.isNotEmpty)
                          _Badge(
                            label: ctrl.product.brand,
                            color: AppColors.grey500,
                          ),
                        ...ctrl.product.tags.map(
                          (String tag) => _Badge(
                            label: '#$tag',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // ── Title ──────────────────────────────
                    Text(
                      ctrl.product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.xs),

                    // ── SKU ────────────────────────────────
                    Text(
                      'SKU: ${ctrl.product.sku}',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontXs,
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // ── Rating & Stock ─────────────────────
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ctrl.product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${ctrl.product.reviews.length} reviews)',
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSm,
                            color: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: ctrl.product.isInStock
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ctrl.product.availabilityStatus ??
                              (ctrl.product.isInStock
                                  ? '${ctrl.product.stock} in stock'
                                  : 'Out of stock'),
                          style: TextStyle(
                            color: ctrl.product.isInStock
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w500,
                            fontSize: AppDimensions.fontSm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),

                    // ── Price ──────────────────────────────
                    Row(
                      children: [
                        Text(
                          '\$${ctrl.product.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: AppDimensions.fontXxl,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (ctrl.product.discountPercentage > 0) ...[
                          const SizedBox(width: AppDimensions.sm),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '\$${ctrl.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: AppDimensions.fontMd,
                                color: AppColors.grey500,
                                decoration: TextDecoration.lineThrough,
                              ),
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
                              '-${ctrl.product.discountPercentage.toStringAsFixed(0)}%',
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

                    // ── Description ────────────────────────
                    _SectionTitle('Description'),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      ctrl.product.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // ── Specifications ─────────────────────
                    _SectionTitle('Specifications'),
                    const SizedBox(height: AppDimensions.sm),
                    _SpecCard(
                      items: [
                        _SpecItem(
                          label: 'Weight',
                          value: '${ctrl.product.weight} kg',
                        ),
                        if (ctrl.product.dimensions != null) ...[
                          _SpecItem(
                            label: 'Width',
                            value:
                                '${ctrl.product.dimensions!.width.toStringAsFixed(1)} cm',
                          ),
                          _SpecItem(
                            label: 'Height',
                            value:
                                '${ctrl.product.dimensions!.height.toStringAsFixed(1)} cm',
                          ),
                          _SpecItem(
                            label: 'Depth',
                            value:
                                '${ctrl.product.dimensions!.depth.toStringAsFixed(1)} cm',
                          ),
                        ],
                        _SpecItem(
                          label: 'Min. Order',
                          value: '${ctrl.product.minimumOrderQuantity} pcs',
                        ),
                        _SpecItem(label: 'SKU', value: ctrl.product.sku),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // ── Shipping & Policy ──────────────────
                    _SectionTitle('Shipping & Policy'),
                    const SizedBox(height: AppDimensions.sm),
                    _SpecCard(
                      items: [
                        _SpecItem(
                          label: 'Shipping',
                          value: ctrl.product.shippingInformation ?? '-',
                        ),
                        _SpecItem(
                          label: 'Warranty',
                          value: ctrl.product.warrantyInformation ?? '-',
                        ),
                        _SpecItem(
                          label: 'Return',
                          value: ctrl.product.returnPolicy ?? '-',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // ── Image Thumbnails ───────────────────
                    if (ctrl.product.images.length > 1) ...[
                      _SectionTitle('Photos'),
                      const SizedBox(height: AppDimensions.sm),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: ctrl.product.images.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: AppDimensions.xs),
                          itemBuilder: (BuildContext context, int index) => Obx(
                            () => GestureDetector(
                              onTap: () => ctrl.selectImage(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMd,
                                  ),
                                  border: Border.all(
                                    color:
                                        ctrl.selectedImageIndex.value == index
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
                                    imageUrl: ctrl.product.images[index],
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (
                                          BuildContext context,
                                          String url,
                                          DownloadProgress downloadProgress,
                                        ) =>
                                            Container(color: AppColors.grey100),
                                    errorWidget:
                                        (
                                          BuildContext context,
                                          String url,
                                          Object error,
                                        ) =>
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

                    // ── Reviews ────────────────────────────
                    if (ctrl.product.reviews.isNotEmpty) ...[
                      Row(
                        children: [
                          _SectionTitle('Reviews'),
                          const SizedBox(width: AppDimensions.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              '${ctrl.product.reviews.length}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: AppDimensions.fontXs,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      ...ctrl.product.reviews.map(
                        (ReviewModel review) => _ReviewCard(review: review),
                      ),
                    ],

                    const SizedBox(height: AppDimensions.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Bar ──────────────────────────────────────────
      bottomNavigationBar: GetBuilder<ProductDetailController>(
        builder: (ctrl) => Container(
          padding: EdgeInsets.only(
            left: AppDimensions.md,
            right: AppDimensions.md,
            bottom: MediaQuery.of(context).padding.bottom + AppDimensions.md,
            top: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: ctrl.product.isInStock ? () {} : null,
            child: Text(
              ctrl.product.isInStock ? 'Add to Cart' : 'Out of Stock',
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

// ── Badge ─────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.xs),
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

// ── Spec Card ─────────────────────────────────────────────────
class _SpecCard extends StatelessWidget {
  final List<_SpecItem> items;

  const _SpecCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSm,
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSm,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SpecItem {
  final String label;
  final String value;

  const _SpecItem({required this.label, required this.value});
}

// ── Review Card ───────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Reviewer Info ────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    review.reviewerName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontSm,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.fontSm,
                        ),
                      ),
                      Text(
                        _formatDate(review.date),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontXs,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Star rating
                Row(
                  children: List.generate(
                    5,
                    (int index) => Icon(
                      index < review.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),

            // ── Comment ──────────────────────────────────
            Text(
              review.comment,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_monthName(date.month)} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
