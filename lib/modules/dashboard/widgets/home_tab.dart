import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/dashboard_controller.dart';

class HomeTab extends GetView<DashboardController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchProfile,
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          // ── Greeting Card ──────────────────────────────
          Obx(() => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: controller.currentUser.value?.avatar != null
                            ? NetworkImage(controller.currentUser.value!.avatar!)
                            : null,
                        child: controller.currentUser.value?.avatar == null
                            ? Text(
                                controller.currentUser.value?.name
                                        .substring(0, 1)
                                        .toUpperCase() ??
                                    'U',
                                style: const TextStyle(fontSize: 24),
                              )
                            : null,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${controller.currentUser.value?.name ?? 'User'} 👋',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            controller.currentUser.value?.email ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: AppDimensions.lg),

          // ── Placeholder Content ────────────────────────
          Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDimensions.sm),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppDimensions.md,
            mainAxisSpacing: AppDimensions.md,
            children: const [
              _QuickActionCard(icon: Icons.bar_chart, label: 'Analytics'),
              _QuickActionCard(icon: Icons.notifications_outlined, label: 'Notifications'),
              _QuickActionCard(icon: Icons.settings_outlined, label: 'Settings'),
              _QuickActionCard(icon: Icons.help_outline, label: 'Help'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppDimensions.iconLg),
            const SizedBox(height: AppDimensions.sm),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
