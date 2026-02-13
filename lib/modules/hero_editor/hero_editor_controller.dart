import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroEditorController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final appRatingCtrl = TextEditingController();
  final appsPublishedCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final projectsWorkedCtrl = TextEditingController();
  final isLoading = false.obs;

  // Initial values for change detection
  String _initialAppRating = '';
  String _initialAppsPublished = '';
  String _initialExperience = '';
  String _initialProjectsWorked = '';

  bool get hasChanges {
    return appRatingCtrl.text.trim() != _initialAppRating ||
        appsPublishedCtrl.text.trim() != _initialAppsPublished ||
        experienceCtrl.text.trim() != _initialExperience ||
        projectsWorkedCtrl.text.trim() != _initialProjectsWorked;
  }

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
        final data = doc.data()?['heroSection'] as Map<String, dynamic>?;
        if (data != null) {
          appRatingCtrl.text = _initialAppRating = data['appRating'] ?? '';
          appsPublishedCtrl.text = _initialAppsPublished =
              data['appsPublished'] ?? '';
          experienceCtrl.text = _initialExperience = data['experience'] ?? '';
          projectsWorkedCtrl.text = _initialProjectsWorked =
              data['projectsWorked'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc('MyDetail')
          .update({
            'heroSection': {
              'appRating': appRatingCtrl.text.trim(),
              'appsPublished': appsPublishedCtrl.text.trim(),
              'experience': experienceCtrl.text.trim(),
              'projectsWorked': projectsWorkedCtrl.text.trim(),
            },
          });

      // Update initial values after successful save
      _initialAppRating = appRatingCtrl.text.trim();
      _initialAppsPublished = appsPublishedCtrl.text.trim();
      _initialExperience = experienceCtrl.text.trim();
      _initialProjectsWorked = projectsWorkedCtrl.text.trim();

      Get.snackbar(
        'Success',
        'Hero Section updated!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Update failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    appRatingCtrl.dispose();
    appsPublishedCtrl.dispose();
    experienceCtrl.dispose();
    projectsWorkedCtrl.dispose();
    super.onClose();
  }
}
