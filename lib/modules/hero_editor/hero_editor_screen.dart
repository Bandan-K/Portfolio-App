import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'hero_editor_controller.dart';

class HeroEditorScreen extends GetView<HeroEditorController> {
  const HeroEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Hero Section')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildField(
                controller: controller.appRatingCtrl,
                label: 'App Rating',
                hint: 'e.g. 4.8+',
                icon: Icons.star_outline_rounded,
              ),
              _buildField(
                controller: controller.appsPublishedCtrl,
                label: 'Apps Published',
                hint: 'e.g. 10+',
                icon: Icons.apps_rounded,
              ),
              _buildField(
                controller: controller.experienceCtrl,
                label: 'Years of Experience',
                hint: 'e.g. 3+',
                icon: Icons.work_outline_rounded,
              ),
              _buildField(
                controller: controller.projectsWorkedCtrl,
                label: 'Projects Worked',
                hint: 'e.g. 25+',
                icon: Icons.folder_outlined,
              ),
              const SizedBox(height: 32),

              // Gradient update button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: controller.updateData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Hero Section',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
