import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/auth_error_handler.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordVisible = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final AuthService authService = Get.find<AuthService>();

  Future<void> login() async {
    if (isLoading.value) return; // Prevent multiple clicks

    try {
      isLoading.value = true;
      final userCredential = await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (userCredential != null) {
        final user = authService.userModel;
        debugPrint('User: ${user?.toJson()}');
        debugPrint('AuthService userModel: ${authService.userModel?.toJson()}');
        if (user != null) {
          debugPrint('User role: ${user.role}');
          // Navigate to the main dashboard which will handle role-specific views
          Get.offAllNamed(Routes.MAIN_DASHBOARD);
        }
      }
    } catch (e) {
      final errorMessage = AuthErrorHandler.getMessage(e);
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
