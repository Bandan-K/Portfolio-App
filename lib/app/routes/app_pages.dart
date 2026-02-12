import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/auth/auth_binding.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/dashboard/dashboard_binding.dart';
import '../../modules/dashboard/dashboard_screen.dart';
import '../../modules/hero_editor/hero_editor_binding.dart';
import '../../modules/hero_editor/hero_editor_screen.dart';
import '../../modules/skills_editor/skills_editor_binding.dart';
import '../../modules/skills_editor/skills_editor_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.heroEditor,
      page: () => const HeroEditorScreen(),
      binding: HeroEditorBinding(),
    ),
    GetPage(
      name: AppRoutes.skillsEditor,
      page: () => const SkillsEditorScreen(),
      binding: SkillsEditorBinding(),
    ),
  ];
}
