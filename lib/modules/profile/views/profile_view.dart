import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/profile_controller.dart';
import '../../../data/models/user_model.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return RefreshIndicator(
          onRefresh: controller.fetchMe,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _ProfileHeader(user: user),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    children: [
                      // ── Account ────────────────────────────
                      _InfoCard(
                        title: 'Account',
                        icon: Icons.person_outline,
                        items: [
                          _InfoItem(label: 'Full Name', value: user.fullName),
                          _InfoItem(
                            label: 'Username',
                            value: '@${user.username}',
                          ),
                          _InfoItem(label: 'Email', value: user.email),
                          _InfoItem(
                            label: 'Role',
                            value: _capitalize(user.role ?? '-'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // ── Personal ───────────────────────────
                      _InfoCard(
                        title: 'Personal',
                        icon: Icons.badge_outlined,
                        items: [
                          _InfoItem(label: 'Phone', value: user.phone ?? '-'),
                          _InfoItem(
                            label: 'Gender',
                            value: _capitalize(user.gender ?? '-'),
                          ),
                          _InfoItem(
                            label: 'Age',
                            value: user.age != null ? '${user.age} years' : '-',
                          ),
                          _InfoItem(
                            label: 'Birth Date',
                            value: user.birthDate ?? '-',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // ── Address ────────────────────────────
                      _InfoCard(
                        title: 'Address',
                        icon: Icons.location_on_outlined,
                        items: [
                          _InfoItem(
                            label: 'Street',
                            value: user.addressStreet ?? '-',
                          ),
                          _InfoItem(
                            label: 'City',
                            value: user.addressCity ?? '-',
                          ),
                          _InfoItem(
                            label: 'State',
                            value: user.addressState ?? '-',
                          ),
                          _InfoItem(
                            label: 'Country',
                            value: user.addressCountry ?? '-',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // ── Company ────────────────────────────
                      _InfoCard(
                        title: 'Company',
                        icon: Icons.business_outlined,
                        items: [
                          _InfoItem(
                            label: 'Name',
                            value: user.companyName ?? '-',
                          ),
                          _InfoItem(
                            label: 'Department',
                            value: user.companyDepartment ?? '-',
                          ),
                          _InfoItem(
                            label: 'Title',
                            value: user.companyTitle ?? '-',
                          ),
                          _InfoItem(
                            label: 'University',
                            value: user.university ?? '-',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

// ── Header ────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final UserModel user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xl,
        horizontal: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: user.image != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.image!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator.adaptive(),
                      errorWidget: (context, url, error) =>
                          _avatarFallback(user),
                    ),
                  )
                : _avatarFallback(user),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(user.fullName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimensions.xs),
          // Username badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              '@${user.username}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.fontSm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(UserModel user) => Text(
    user.firstName.substring(0, 1).toUpperCase(),
    style: const TextStyle(
      fontSize: 36,
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
    ),
  );
}

// ── Info Card ─────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_InfoItem> items;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: AppDimensions.xs),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(height: AppDimensions.lg),
            ...items.map(
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
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Item ─────────────────────────────────────────────────
class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});
}
