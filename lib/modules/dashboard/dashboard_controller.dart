import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/routes/app_routes.dart';

class DashboardController extends GetxController {
  String get userEmail => FirebaseAuth.instance.currentUser?.email ?? 'Admin';

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
