import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../meal_plans/views/meal_plan_selection_view.dart';
import '../views/client_dashboard_view.dart';
import '../views/trainer_dashboard_view.dart';
import '../../../models/user_model.dart';

class MainDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final selectedIndex = 0.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final isTrainer = false.obs;

  // Pages that will be displayed in the bottom navigation
  late final List<Widget> pages;

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
    isTrainer.value = user.value?.isTrainer ?? false;

    // Initialize pages based on user role
    _initPages();
  }

  void _initPages() {
    if (isTrainer.value) {
      _initTrainerPages();
    } else {
      _initClientPages();
    }
  }

  void _initClientPages() {
    pages = [
      const ClientDashboardView(),
      const MealPlanSelectionView(), // Meal plans tab
      Container(child: const Center(child: Text("Workout Plans"))),
      Container(child: const Center(child: Text("Progress Tracking"))),
    ];
  }

  void _initTrainerPages() {
    pages = [
      const TrainerDashboardView(),
      Container(child: const Center(child: Text("Clients List"))),
      Container(child: const Center(child: Text("Training Sessions"))),
      Container(child: const Center(child: Text("Custom Plans"))),
    ];
  }

  void changePage(int index) {
    selectedIndex.value = index;
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
