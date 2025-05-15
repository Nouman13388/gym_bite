import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = ''.obs;
  final passwordController = ''.obs;
  final AuthService authService = Get.find<AuthService>();

  Future<void> login() async {
    try {
      final userCredential = await authService.signInWithEmailAndPassword(
        emailController.value,
        passwordController.value,
      );
      if (userCredential != null) {
        final user = authService.userModel;
        if (user != null) {
          if (user.isTrainer) {
            Get.offAllNamed(Routes.TRAINER_DASHBOARD);
          } else {
            Get.offAllNamed(Routes.CLIENT_DASHBOARD);
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
