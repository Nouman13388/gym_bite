import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../meal_plans/controllers/client_meal_plan_controller.dart';
import '../../meal_plans/controllers/trainer_meal_plan_controller.dart';
import '../../../models/user_model.dart';

class MainDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final selectedIndex = 0.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final isTrainer = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
    isTrainer.value = user.value?.isTrainer ?? false;

    // Register the necessary controllers
    _registerControllers();
  }

  void _registerControllers() {
    // Register client controllers if user is a client
    if (!isTrainer.value) {
      if (!Get.isRegistered<ClientMealPlanController>()) {
        Get.put(ClientMealPlanController());
      }
    }
    // Register trainer controllers if user is a trainer
    else {
      if (!Get.isRegistered<TrainerMealPlanController>()) {
        Get.put(TrainerMealPlanController());
      }
    }
  }

  void changePage(int index) {
    // If we're already on this index, no need to do anything
    if (selectedIndex.value == index) return;

    // Check if we're switching to profile tab to refresh user data
    if (index == 4) {
      // Refresh the user data to ensure we have the latest
      _refreshUserData();
    }

    // Update the selected index
    // The UI will react to this change through the Obx wrapper in the views
    selectedIndex.value = index;
  }

  // Method to refresh user data from auth service
  Future<void> _refreshUserData() async {
    try {
      // Update from auth service
      user.value = _authService.userModel;
      print('Main Dashboard: User data refreshed for profile tab');
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

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
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Close loading dialog if error occurs
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        'Error',
        'Failed to sign out: ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
