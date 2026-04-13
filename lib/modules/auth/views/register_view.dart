import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Us Today 🚀',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Create your account to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── Name ────────────────────────────────────
                AuthTextField(
                  controller: controller.nameCtrl,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  validator: controller.validateName,
                ),
                const SizedBox(height: AppDimensions.md),

                // ── Email ───────────────────────────────────
                AuthTextField(
                  controller: controller.emailCtrl,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: AppDimensions.md),

                // ── Password ────────────────────────────────
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordCtrl,
                    label: 'Password',
                    hint: 'Min. 8 characters',
                    prefixIcon: Icons.lock_outline,
                    obscureText: controller.isPasswordHidden.value,
                    validator: controller.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),

                // ── Confirm Password ────────────────────────
                Obx(
                  () => AuthTextField(
                    controller: controller.confirmCtrl,
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: controller.isConfirmHidden.value,
                    validator: controller.validateConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.toggleConfirmPassword,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── Register Button ─────────────────────────
                // Obx(() => ElevatedButton(
                //       onPressed: controller.isLoading.value
                //           ? null
                //           : controller.register,
                //       child: controller.isLoading.value
                //           ? const SizedBox(
                //               height: 20,
                //               width: 20,
                //               child: CircularProgressIndicator(
                //                 color: Colors.white,
                //                 strokeWidth: 2,
                //               ),
                //             )
                //           : const Text('Create Account'),
                //     )),
                const SizedBox(height: AppDimensions.lg),

                // ── Login Link ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
