import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/dashboard_controller.dart';
import 'product_card.dart';

class HomeTab extends GetView<DashboardController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchProducts(refresh: true),
      child: CustomScrollView(
        slivers: [
          // ── Greeting ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Obx(
                () => _GreetingCard(
                  name: controller.currentUser.value?.firstName ?? 'User',
                  image: controller.currentUser.value?.image,
                ),
              ),
            ),
          ),

          // ── Title ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Products',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          // ── Product Grid ──────────────────────────────────
          Obx(() {
            if (controller.isLoading.value && controller.products.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == controller.products.length) {
                    return Obx(
                      () => controller.isLoadingMore.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.md),
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  }
                  // trigger load more
                  if (index == controller.products.length - 3) {
                    controller.loadMore();
                  }
                  return ProductCard(product: controller.products[index]);
                }, childCount: controller.products.length + 1),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.sm,
                  mainAxisSpacing: AppDimensions.sm,
                  childAspectRatio: 0.72,
                ),
              ),
            );
          }),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppDimensions.lg),
          ),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String name;
  final String? image;

  const _GreetingCard({required this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 28,
            //   backgroundImage: image != null ? NetworkImage(image!) : null,
            //   backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            //   child: image == null
            //       ? Text(
            //           name.substring(0, 1).toUpperCase(),
            //           style: const TextStyle(
            //             fontSize: 22,
            //             color: AppColors.primary,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         )
            //       : null,
            // ),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: image != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: image!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator.adaptive(),
                        errorWidget: (context, url, error) => Text(
                          name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: AppDimensions.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name 👋',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Browse our products',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
