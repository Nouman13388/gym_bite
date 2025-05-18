import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
  }

  bool get isTrainer => user.value?.isTrainer ?? false;
  bool get isClient => user.value?.isClient ?? false;
  bool get isAdmin => user.value?.isAdmin ?? false;
  Future<void> signOut() async {
    try {
      // Show loading dialog
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        barrierDismissible: false,
      );

      // Perform sign out
      await _authService.signOut();

      // Close loading dialog and navigate to login
      Get.back();
      Get.offAllNamed('/login');
    } catch (e) {
      // Close loading dialog if error occurs
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
