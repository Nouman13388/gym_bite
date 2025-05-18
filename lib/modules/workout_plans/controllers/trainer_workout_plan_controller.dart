import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/workout_model.dart';
import '../../../services/workout_service.dart';
import '../../../services/auth_service.dart';

class TrainerWorkoutPlanController extends GetxController {
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

  Future<void> refreshUserData() async {
    // Refresh user data if needed before creating a workout plan
    // This can be used to ensure the user ID is available
  }

  Future<void> fetchWorkoutPlans() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = ''; // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        print('DEBUG TrainerWorkoutPlanController: User ID found: ${user.id}');
        try {
          // Fetch workout plans created by this trainer
          print(
            'DEBUG TrainerWorkoutPlanController: Fetching workout plans for trainer ID: ${user.id}',
          );
          final plans = await _workoutService.getTrainerWorkoutPlans(user.id);
          workoutPlans.value = plans;

          print(
            'DEBUG TrainerWorkoutPlanController: Fetched ${plans.length} workout plans',
          );

          // Log details about the loaded workout plans
          logWorkoutPlansStatus();
        } catch (e) {
          print(
            'DEBUG TrainerWorkoutPlanController: Error fetching trainer workout plans: $e',
          );

          // Try to get all workout plans if trainer-specific endpoint fails
          print(
            'DEBUG TrainerWorkoutPlanController: Falling back to fetching all workout plans',
          );
          try {
            final plans = await _workoutService.getAllWorkoutPlans();
            workoutPlans.value = plans;
            print(
              'DEBUG TrainerWorkoutPlanController: Fetched ${plans.length} workout plans from fallback',
            );
          } catch (fallbackError) {
            print(
              'DEBUG TrainerWorkoutPlanController: Fallback also failed: $fallbackError',
            );
            hasError.value = true;
            errorMessage.value = 'Failed to load workout plans: $fallbackError';
          }
        }
      } else {
        print('DEBUG TrainerWorkoutPlanController: No user ID available');
        // No user ID available, try to get all workout plans
        try {
          print(
            'DEBUG TrainerWorkoutPlanController: Fetching all workout plans',
          );
          final plans = await _workoutService.getAllWorkoutPlans();
          workoutPlans.value = plans;
          print(
            'DEBUG TrainerWorkoutPlanController: Fetched ${plans.length} workout plans',
          );
        } catch (e) {
          print(
            'DEBUG TrainerWorkoutPlanController: Error fetching all workout plans: $e',
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

  Future<bool> createWorkoutPlan(Map<String, dynamic> workoutPlanData) async {
    try {
      // Debug print before creating workout plan
      print(
        'DEBUG: Attempting to create workout plan with data: $workoutPlanData',
      );

      // Get the current authenticated user ID
      final user = _authService.userModel;
      if (user != null) {
        print('DEBUG: User ID found: ${user.id}');

        // Add user ID to the workout plan data
        workoutPlanData['userId'] = user.id;

        // Debug print workout plan data before sending
        print('DEBUG: Sending workout plan data: $workoutPlanData');

        // Try the new method first (which expects a Map)
        try {
          print('DEBUG: Trying createNewWorkoutPlan method');
          final result = await _workoutService.createNewWorkoutPlan(
            workoutPlanData,
          );
          print('DEBUG: API response received: $result');

          if (result != null) {
            print('DEBUG: Workout plan created successfully');
            // Refresh the list after creating a new plan
            fetchWorkoutPlans();
            return true;
          }
        } catch (e) {
          print(
            'DEBUG: Error with createNewWorkoutPlan, falling back to createWorkoutPlan: $e',
          );

          // Fallback to the original method (which expects a WorkoutPlanModel)
          final result = await _workoutService.createWorkoutPlan(
            WorkoutPlanModel.fromJson(workoutPlanData),
          );
          print('DEBUG: API response received from fallback method: $result');

          if (result != null) {
            print('DEBUG: Workout plan created successfully via fallback');
            // Refresh the list after creating a new plan
            fetchWorkoutPlans();
            return true;
          }
        }
      } else {
        print('DEBUG: No user ID available');
      }
      return false;
    } catch (e) {
      print('DEBUG: Error creating workout plan: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to create workout plan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> deleteWorkoutPlan(int workoutPlanId) async {
    try {
      final result = await _workoutService.deleteWorkoutPlan(workoutPlanId);
      if (result) {
        // Remove from local list if successful
        workoutPlans.removeWhere((plan) => plan.id == workoutPlanId);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete workout plan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> assignPlanToClient(int planId, String clientId) async {
    try {
      print('DEBUG: Assigning plan $planId to client $clientId');
      // Convert clientId string to int (assuming it's in the format 'client_123')
      final id = int.tryParse(clientId.split('_').last) ?? 0;
      if (id <= 0) return false;

      final result = await _workoutService.assignWorkoutPlanToClient(
        planId,
        id,
      );
      return result;
    } catch (e) {
      print('DEBUG: Error assigning plan to client: $e');
      Get.snackbar(
        'Error',
        'Failed to assign workout plan to client: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Method to select a category for filtering
  void selectCategory(String category) {
    print('DEBUG: Selected category: $category');
    selectedCategory.value = category;
  }

  // Method to select a workout plan for viewing details
  void selectWorkoutPlan(WorkoutPlanModel plan) {
    print('DEBUG: Selected workout plan: ${plan.title}');
    selectedPlan.value = plan;
  } // Helper method to display workout plans status

  void logWorkoutPlansStatus() {
    if (workoutPlans.isEmpty) {
      print('DEBUG TrainerWorkoutPlanController: No workout plans available');
    } else {
      print(
        'DEBUG TrainerWorkoutPlanController: ${workoutPlans.length} workout plans loaded',
      );
      for (var plan in workoutPlans) {
        print(
          'DEBUG TrainerWorkoutPlanController: Plan - ${plan.title}, Category: ${plan.category}',
        );
      }
    }
  }

  // Getter for filtered workout plans based on selected category
  List<WorkoutPlanModel> get filteredWorkoutPlans {
    if (selectedCategory.value == 'All') {
      return workoutPlans;
    } else {
      return workoutPlans
          .where((plan) => plan.category == selectedCategory.value)
          .toList();
    }
  }
}
