
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

  void reorderSkills(String category, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    // Get the indices of skills in this category
    final categoryIndices = <int>[];
    for (int i = 0; i < skills.length; i++) {
      if (skills[i]['category'] == category) {
        categoryIndices.add(i);
      }
    }

    if (oldIndex < categoryIndices.length &&
        newIndex < categoryIndices.length) {
      final actualOldIndex = categoryIndices[oldIndex];
      final actualNewIndex = categoryIndices[newIndex];

      final item = skills.removeAt(actualOldIndex);
      skills.insert(actualNewIndex, item);

      // Auto-save after reorder
      saveSkills(showLoading: false);
    }
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

  Future<void> saveSkills({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
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

  Future<void> seedSkills() async {
    isLoading.value = true;
    try {
      // Use the default skills list
      final defaultSkills = _defaultSkills;

      await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc('MyDetail')
          .set({'skillsSection': defaultSkills}, SetOptions(merge: true));

      // Update local state
      skills.value = defaultSkills;

      Get.snackbar(
        'Success',
        'Skills seeded successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to seed skills: $e',
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

  static const List<Map<String, dynamic>> _defaultSkills = [
    // Core Stack
    {
      'name': 'Swift',
      'tag': 'Language',
      'expertise': 'Expert',
      'category': 'core',
      'description':
          'The primary programming language for iOS development. Highly focused on performance, safety, and modern expressive syntax.',
      'docUrl': 'https://developer.apple.com/swift/',
      'searchSuffix': 'programming language',
    },
    {
      'name': 'UIKit',
      'tag': 'Traditional UI',
      'expertise': 'Expert',
      'category': 'core',
      'description':
          'The foundation of iOS UI development. Extensive experience building complex, performant interfaces using Storyboards and XIBs.',
      'docUrl': 'https://developer.apple.com/documentation/uikit',
      'searchSuffix': 'ios development',
    },
    {
      'name': 'SwiftUI',
      'tag': 'Modern UI',
      'expertise': 'Expert',
      'category': 'core',
      'description':
          "Apple's modern declarative framework. Expert in building state-driven, cross-platform interfaces with fluid animations.",
      'docUrl': 'https://developer.apple.com/xcode/swiftui/',
      'searchSuffix': 'declarative ui',
    },
    {
      'name': 'Xcode',
      'tag': 'Environment',
      'expertise': 'Expert',
      'category': 'core',
      'description':
          'Proficient in the full suite of Xcode tools, including Instruments, Debugging, and Build System configuration.',
      'docUrl': 'https://developer.apple.com/xcode/',
      'searchSuffix': 'ide features',
    },

    // Frameworks & Services
    {
      'name': 'Google Maps & Places',
      'tag': 'APIs',
      'expertise': 'Advanced',
      'category': 'frameworks',
      'description':
          'Seamless integration of map views, custom markers, place autocomplete, and complex route optimizations.',
      'docUrl':
          'https://developers.google.com/maps/documentation/ios-sdk/overview',
      'searchSuffix': 'ios sdk',
    },
    {
      'name': 'Firebase Analytics',
      'tag': 'Analytics',
      'expertise': 'Advanced',
      'category': 'frameworks',
      'description':
          'Setting up custom event tracking and user properties to derive actionable insights from user behavior.',
      'docUrl': 'https://firebase.google.com/docs/analytics',
      'searchSuffix': 'event tracking',
    },
    {
      'name': 'Firebase Crashlytics',
      'tag': 'Stability',
      'expertise': 'Advanced',
      'category': 'frameworks',
      'description':
          'Proactive monitoring and resolution of crashes with detailed stack traces and environmental logs.',
      'docUrl': 'https://firebase.google.com/docs/crashlytics',
      'searchSuffix': 'error reporting',
    },
    {
      'name': 'Core Data / SwiftData',
      'tag': 'Persistence',
      'expertise': 'Advanced',
      'category': 'frameworks',
      'description':
          'Expertise in both traditional Core Data stacks and the modern, declarative SwiftData for local storage.',
      'docUrl': 'https://developer.apple.com/documentation/swiftdata',
      'searchSuffix': 'persistence framework',
    },
    {
      'name': 'Combine',
      'tag': 'Reactive',
      'expertise': 'Proficient',
      'category': 'frameworks',
      'description':
          'Handling complex asynchronous data streams and event pipelines using Apple-native reactive patterns.',
      'docUrl': 'https://developer.apple.com/documentation/combine',
      'searchSuffix': 'reactive programming',
    },
    {
      'name': 'REST APIs',
      'tag': 'Networking',
      'expertise': 'Expert',
      'category': 'frameworks',
      'description':
          'Integration of back-end services with URLSession, optimized caching, and robust error handling patterns.',
      'docUrl':
          'https://developer.apple.com/documentation/foundation/urlsession',
      'searchSuffix': 'ios networking',
    },

    // Tools & Distribution
    {
      'name': 'TestFlight',
      'tag': 'Beta Testing',
      'expertise': 'Expert',
      'category': 'tools',
      'description':
          'Managing end-to-end beta cycles, build distribution, and gathering user feedback for high-quality releases.',
      'docUrl': 'https://developer.apple.com/testflight/',
      'searchSuffix': 'distribution guide',
    },
    {
      'name': 'Git & Version Control',
      'tag': 'VCS',
      'expertise': 'Expert',
      'category': 'tools',
      'description':
          'Deep knowledge of collaborative workflows, conflict resolution, and maintaining clean commit histories.',
      'docUrl': 'https://git-scm.com/',
      'searchSuffix': 'best practices',
    },
    {
      'name': 'CocoaPods/SPM',
      'tag': 'Dependencies',
      'expertise': 'Expert',
      'category': 'tools',
      'description':
          'Expert integration and maintenance of third-party libraries and modularized internal frameworks.',
      'docUrl':
          'https://developer.apple.com/documentation/xcode/swift-packages',
      'searchSuffix': 'dependency management',
    },
  ];
}
