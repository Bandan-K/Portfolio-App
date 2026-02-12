import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillsEditorController extends GetxController {
  final skills = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  static const List<String> categories = ['core', 'frameworks', 'tools'];

  static const Map<String, String> categoryLabels = {
    'core': 'Core Stack',
    'frameworks': 'Frameworks & Services',
    'tools': 'Tools & Distribution',
  };

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc('MyDetail')
          .get();

      if (doc.exists) {
        final data = doc.data()?['skillsSection'] as List<dynamic>?;
        if (data != null) {
          skills.value = List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load skills: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSkills() async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc('MyDetail')
          .set({'skillsSection': skills.toList()}, SetOptions(merge: true));
      Get.snackbar(
        'Success',
        'Skills updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save skills: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSkill(Map<String, dynamic> skill) {
    skills.add(skill);
  }

  void updateSkill(int index, Map<String, dynamic> skill) {
    skills[index] = skill;
    skills.refresh();
  }

  void deleteSkill(int index) {
    skills.removeAt(index);
  }
}
