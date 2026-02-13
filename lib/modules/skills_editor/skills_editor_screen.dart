import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'skills_editor_controller.dart';

class SkillsEditorScreen extends GetView<SkillsEditorController> {
  const SkillsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: !controller.hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Skills'),
          actions: [
            IconButton(
              onPressed: controller.saveSkills,
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save to Firestore',
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.skills.isEmpty) {
            return _buildEmptyState(context, isDark, theme);
          }

          return RefreshIndicator(
            onRefresh: controller.loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: SkillsEditorController.categories.map((category) {
                final categorySkills = controller.skills
                    .where((s) => s['category'] == category)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryHeader(context, category, theme, isDark),
                    const SizedBox(height: 12),
                    if (categorySkills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, left: 16),
                        child: Text(
                          'No skills in this category',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      )
                    else
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categorySkills.length,
                        onReorder: (oldIndex, newIndex) => controller
                            .reorderSkills(category, oldIndex, newIndex),
                        itemBuilder: (context, index) {
                          final skill = categorySkills[index];
                          // Find the actual index in the main controller list for edit/delete
                          final actualIndex = controller.skills.indexOf(skill);

                          return Padding(
                            key: ValueKey(
                              '${category}_${skill['name']}_$index',
                            ),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _SkillCard(
                              skill: skill,
                              onEdit: () => _showSkillDialog(
                                context,
                                index: actualIndex,
                                skill: skill,
                              ),
                              onDelete: () =>
                                  _confirmDelete(context, actualIndex),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSkillDialog(context),
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    String category,
    ThemeData theme,
    bool isDark,
  ) {
    final color = AppColors.categoryColor(category);
    final label = SkillsEditorController.categoryLabels[category] ?? category;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                .withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.code_off_rounded,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No skills added yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first skill',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: controller.seedSkills,
            icon: const Icon(Icons.cloud_upload_rounded),
            label: const Text('Seed Default Skills'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    final skill = controller.skills[index];
    final removedSkill = Map<String, dynamic>.from(skill);

    controller.deleteSkill(index);

    Get.snackbar(
      'Skill Deleted',
      '"${removedSkill['name']}" removed',
      mainButton: TextButton(
        onPressed: () {
          controller.skills.insert(index, removedSkill);
          if (Get.isSnackbarOpen) Get.back();
        },
        child: const Text(
          'UNDO',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  void _showSkillDialog(
    BuildContext context, {
    int? index,
    Map<String, dynamic>? skill,
  }) {
    final nameCtrl = TextEditingController(text: skill?['name']);
    final tagCtrl = TextEditingController(text: skill?['tag']);
    final expertiseCtrl = TextEditingController(text: skill?['expertise']);
    final descriptionCtrl = TextEditingController(text: skill?['description']);
    final docUrlCtrl = TextEditingController(text: skill?['docUrl']);
    final searchSuffixCtrl = TextEditingController(
      text: skill?['searchSuffix'],
    );
    String category = skill?['category'] ?? 'core';

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(index == null ? 'Add Skill' : 'Edit Skill'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.code_rounded),
                      hintText: 'e.g. Swift',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tagCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tag',
                      prefixIcon: Icon(Icons.label_outline_rounded),
                      hintText: 'e.g. Language',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: expertiseCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Expertise',
                      prefixIcon: Icon(Icons.star_outline_rounded),
                      hintText: 'e.g. Expert, Advanced, Proficient',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    items: SkillsEditorController.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.categoryColor(c),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  SkillsEditorController.categoryLabels[c] ??
                                      c.toUpperCase(),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setDialogState(() => category = v!);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: docUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Documentation URL (optional)',
                      prefixIcon: Icon(Icons.link_rounded),
                      hintText: 'https://...',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchSuffixCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Search Suffix (optional)',
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'e.g. programming language',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Name is required',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final newSkill = <String, dynamic>{
                    'name': nameCtrl.text.trim(),
                    'tag': tagCtrl.text.trim(),
                    'expertise': expertiseCtrl.text.trim(),
                    'category': category,
                    'description': descriptionCtrl.text.trim(),
                  };

                  // Only include optional fields if they have values
                  if (docUrlCtrl.text.trim().isNotEmpty) {
                    newSkill['docUrl'] = docUrlCtrl.text.trim();
                  }
                  if (searchSuffixCtrl.text.trim().isNotEmpty) {
                    newSkill['searchSuffix'] = searchSuffixCtrl.text.trim();
                  }

                  if (index == null) {
                    controller.addSkill(newSkill);
                  } else {
                    controller.updateSkill(index, newSkill);
                  }
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SkillCard({
    required this.skill,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final category = skill['category'] ?? 'core';
    final categoryColor = AppColors.categoryColor(category);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category indicator
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          skill['name'] ?? '',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Tag chip
                      if ((skill['tag'] ?? '').isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: categoryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            skill['tag'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        SkillsEditorController.categoryLabels[category] ??
                            category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      if ((skill['expertise'] ?? '').isNotEmpty) ...[
                        Text(
                          ' • ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        Text(
                          skill['expertise'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert_rounded,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
