import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx/data/models/user_model.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/profile_controller.dart';

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
        return SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────
              _ProfileHeader(user: user),

              // ── Info Cards ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  children: [
                    _InfoCard(
                      title: 'Account Info',
                      items: [
                        _InfoItem(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: user.fullName,
                        ),
                        _InfoItem(
                          icon: Icons.alternate_email,
                          label: 'Username',
                          value: '@${user.username}',
                        ),
                        _InfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _InfoCard(
                      title: 'Personal Info',
                      items: [
                        _InfoItem(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: user.phone ?? '-',
                        ),
                        _InfoItem(
                          icon: Icons.people_outline,
                          label: 'Gender',
                          value: user.gender != null
                              ? _capitalize(user.gender!)
                              : '-',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

// ── Header Widget ────────────────────────────────────────────
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
          // Avatar
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
                      errorWidget: (context, url, error) => Text(
                        user.firstName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 36,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Text(
                    user.firstName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Name
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
}

// ── Info Card Widget ─────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppDimensions.sm),
            const Divider(),
            ...items,
          ],
        ),
      ),
    );
  }
}

// ── Info Item Widget ─────────────────────────────────────────
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXs,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontMd,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
