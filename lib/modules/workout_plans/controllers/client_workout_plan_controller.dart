import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/workout_model.dart';
import '../../../services/workout_service.dart';
import '../../../services/auth_service.dart';

class ClientWorkoutPlanController extends GetxController {
  final WorkoutService _workoutService = WorkoutService();
  final AuthService _authService = Get.find<AuthService>();

  // Observable properties
  final workoutPlans = <WorkoutPlanModel>[].obs;
  final selectedPlan = Rx<WorkoutPlanModel?>(null);
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final selectedCategory = 'All'.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  final categories =
      [
        'All',
        'Upper Body',
        'Lower Body',
        'Core',
        'Full Body',
        'Cardio',
        'Flexibility',
      ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkoutPlans();
  }

  Future<void> fetchWorkoutPlans() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        print('DEBUG ClientWorkoutPlanController: User ID found: ${user.id}');
        try {
          // Fetch workout plans assigned to this client
          print(
            'DEBUG ClientWorkoutPlanController: Fetching workout plans for client ID: ${user.id}',
          );
          final plans = await _workoutService.getClientWorkoutPlans(user.id);
          workoutPlans.value = plans;
          print(
            'DEBUG ClientWorkoutPlanController: Fetched ${plans.length} workout plans for client',
          );

          // Log details about the loaded workout plans
          logWorkoutPlansStatus();
        } catch (e) {
          print(
            'DEBUG ClientWorkoutPlanController: Error fetching client workout plans: $e',
          );

          // Try to get all workout plans if client-specific endpoint fails
          print(
            'DEBUG ClientWorkoutPlanController: Falling back to fetching all workout plans',
          );
          try {
            final plans = await _workoutService.getAllWorkoutPlans();
            workoutPlans.value = plans;
            print(
              'DEBUG ClientWorkoutPlanController: Fetched ${plans.length} workout plans from fallback',
            );
          } catch (fallbackError) {
            print(
              'DEBUG ClientWorkoutPlanController: Fallback also failed: $fallbackError',
            );
            hasError.value = true;
            errorMessage.value = 'Failed to load workout plans: $fallbackError';
          }
        }
      } else {
        print('DEBUG ClientWorkoutPlanController: No user ID available');
        // No user ID available, try to get all workout plans
        try {
          print(
            'DEBUG ClientWorkoutPlanController: Fetching all workout plans',
          );
          final plans = await _workoutService.getAllWorkoutPlans();
          workoutPlans.value = plans;
          print(
            'DEBUG ClientWorkoutPlanController: Fetched ${plans.length} workout plans',
          );
        } catch (e) {
          print(
            'DEBUG ClientWorkoutPlanController: Error fetching all workout plans: $e',
          );
          hasError.value = true;
          errorMessage.value = 'Failed to load workout plans: $e';
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load workout plans: ${e.toString()}';
      Get.snackbar('Error', 'Failed to load workout plans: ${e.toString()}');
    }
  }

  Future<void> refreshWorkoutPlans() async {
    isRefreshing.value = true;
    try {
      await fetchWorkoutPlans();
      Get.snackbar(
        'Success',
        'Workout plans refreshed',
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh workout plans',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  WorkoutPlanModel? getWorkoutPlanById(int id) {
    try {
      // Try to find the workout plan in the current list
      for (var plan in workoutPlans) {
        if (plan.id == id) {
          return plan;
        }
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get workout plan details',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return null;
    }
  } // Helper method to display workout plans status

  void logWorkoutPlansStatus() {
    if (workoutPlans.isEmpty) {
      print(
        'DEBUG ClientWorkoutPlanController: No workout plans available for this client',
      );
    } else {
      print(
        'DEBUG ClientWorkoutPlanController: ${workoutPlans.length} workout plans assigned',
      );
      for (var plan in workoutPlans) {
        print(
          'DEBUG ClientWorkoutPlanController: Plan - ${plan.title}, Category: ${plan.category}',
        );
      }
    }
  }

  List<WorkoutPlanModel> get filteredWorkoutPlans {
    if (selectedCategory.value == 'All') {
      return workoutPlans;
    } else {
      return workoutPlans
          .where((plan) => plan.category == selectedCategory.value)
          .toList();
    }
  }

  void selectWorkoutPlan(WorkoutPlanModel plan) {
    selectedPlan.value = plan;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
