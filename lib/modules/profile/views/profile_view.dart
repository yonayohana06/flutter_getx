import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_info_field.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.isEditing.value
                        ? controller.saveProfile
                        : controller.toggleEdit,
                child: Text(
                  controller.isEditing.value ? 'Save' : 'Edit',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // ── Avatar ──────────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 52,
                            backgroundImage:
                                controller.user.value?.avatar != null
                                    ? NetworkImage(controller.user.value!.avatar!)
                                    : null,
                            child: controller.user.value?.avatar == null
                                ? Text(
                                    controller.user.value?.name
                                            .substring(0, 1)
                                            .toUpperCase() ??
                                        'U',
                                    style: const TextStyle(fontSize: 40),
                                  )
                                : null,
                          )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.camera_alt,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── Fields ───────────────────────────────────
                Obx(() => ProfileInfoField(
                      controller: controller.nameCtrl,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      enabled: controller.isEditing.value,
                      validator: controller.validateName,
                    )),
                const SizedBox(height: AppDimensions.md),

                Obx(() => ProfileInfoField(
                      controller: TextEditingController(
                          text: controller.user.value?.email ?? ''),
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: false, // email tidak bisa diubah
                    )),
                const SizedBox(height: AppDimensions.md),

                Obx(() => ProfileInfoField(
                      controller: controller.phoneCtrl,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      enabled: controller.isEditing.value,
                      keyboardType: TextInputType.phone,
                      validator: controller.validatePhone,
                    )),
                const SizedBox(height: AppDimensions.xl),

                // ── Cancel Button (only when editing) ────────
                Obx(() => controller.isEditing.value
                    ? OutlinedButton(
                        onPressed: controller.toggleEdit,
                        child: const Text('Cancel'),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        );
      }),
    );
  }
}
