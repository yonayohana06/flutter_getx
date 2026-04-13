import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────────────
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: product.thumbnail,
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
                    ),
                  ),
                ),
                // Discount badge
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(AppDimensions.radiusSm),
                        ),
                      ),
                      child: Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontXs,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Rating badge
                // Positioned(
                //   top: AppDimensions.xs,
                //   right: AppDimensions.xs,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: AppDimensions.xs,
                //       vertical: 2,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withValues(alpha: 0.6),
                //       borderRadius: BorderRadius.circular(
                //         AppDimensions.radiusSm,
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         const Icon(
                //           Icons.star_rounded,
                //           size: 10,
                //           color: Colors.amber,
                //         ),
                //         const SizedBox(width: 2),
                //         Text(
                //           product.rating.toStringAsFixed(1),
                //           style: const TextStyle(
                //             color: Colors.white,
                //             fontSize: AppDimensions.fontXs,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // ── Info ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppDimensions.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXs,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 10,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontXs,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontMd,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (product.discountPercentage > 0) ...[
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: AppDimensions.fontXs,
                          color: AppColors.grey500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
