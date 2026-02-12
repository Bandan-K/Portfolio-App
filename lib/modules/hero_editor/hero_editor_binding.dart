import 'package:get/get.dart';
import 'hero_editor_controller.dart';

class HeroEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeroEditorController>(() => HeroEditorController());
  }
}
