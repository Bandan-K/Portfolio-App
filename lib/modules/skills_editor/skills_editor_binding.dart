import 'package:get/get.dart';
import 'skills_editor_controller.dart';

class SkillsEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkillsEditorController>(() => SkillsEditorController());
  }
}
