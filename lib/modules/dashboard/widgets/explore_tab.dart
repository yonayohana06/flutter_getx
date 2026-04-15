import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/explore_controller.dart';
import 'product_card.dart';

class ExploreTab extends GetView<ExploreController> {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search Bar ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.md,
            AppDimensions.md,
            AppDimensions.md,
            AppDimensions.sm,
          ),
          child: Obx(
            () => TextFormField(
              controller: controller.searchCtrl,
              onChanged: controller.onSearchChanged,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search products...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryLight),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: controller.clearSearch,
                      )
                    : null,
              ),
            ),
          ),
        ),

        // ── Content ────────────────────────────────────────
        Expanded(
          child: Obx(() {
            // Loading
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            // Belum search
            if (!controller.hasSearched.value) {
              return _EmptyState(
                icon: Icons.search_rounded,
                title: 'Search Products',
                subtitle: 'Type something to start searching',
              );
            }

            // Hasil kosong
            if (controller.products.isEmpty) {
              return _EmptyState(
                icon: Icons.find_in_page_outlined,
                title: 'No Results',
                subtitle:
                    'No products found for "${controller.searchQuery.value}"',
              );
            }

            // Hasil search
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Result count
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.xs,
                  ),
                  child: Text(
                    '${controller.products.length} results for '
                    '"${controller.searchQuery.value}"',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.sm,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppDimensions.sm,
                          mainAxisSpacing: AppDimensions.sm,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: controller.products.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ProductCard(product: controller.products[index]),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey300),
          const SizedBox(height: AppDimensions.md),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
