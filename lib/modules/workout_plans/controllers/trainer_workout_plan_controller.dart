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
      errorMessage.value = '';

      // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        try {
          // Fetch workout plans created by this trainer
          final plans = await _workoutService.getTrainerWorkoutPlans(user.id);
          workoutPlans.value = plans;

          // If no plans are returned from API, use sample data for testing
          if (workoutPlans.isEmpty) {
            _loadSampleData();
          }
        } catch (e) {
          print('Error fetching trainer workout plans: $e');
          // Fallback to all workout plans if trainer-specific endpoint fails
          final plans = await _workoutService.getAllWorkoutPlans();
          workoutPlans.value = plans;

          if (workoutPlans.isEmpty) {
            _loadSampleData();
          }
        }
      } else {
        // No user ID available, fallback to getting all workout plans
        final plans = await _workoutService.getAllWorkoutPlans();
        workoutPlans.value = plans;

        if (workoutPlans.isEmpty) {
          _loadSampleData();
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
  }

  void _loadSampleData() {
    workoutPlans.value = [
      WorkoutPlanModel(
        id: 1,
        userId: 1,
        title: 'Ultimate Upper Body',
        description:
            'A comprehensive workout focusing on chest, shoulders, back and arms.',
        category: 'Upper Body',
        duration: 45,
        difficulty: 'Intermediate',
        imageUrl: 'assets/images/workout.png',
        exercises: [
          Exercise(
            name: 'Bench Press',
            description:
                'Lie on a bench and press the weight upward until your arms are extended.',
            sets: 3,
            reps: 12,
            restTime: 60,
            imageUrl: 'assets/images/workout.png',
          ),
          Exercise(
            name: 'Pull-ups',
            description:
                'Hang from a bar with palms facing away and pull your body up until chin over bar.',
            sets: 3,
            reps: 8,
            restTime: 60,
            imageUrl: 'assets/images/workout.png',
          ),
          Exercise(
            name: 'Shoulder Press',
            description:
                'Press weights from shoulder height until your arms are fully extended overhead.',
            sets: 3,
            reps: 10,
            restTime: 60,
            imageUrl: 'assets/images/workout.png',
          ),
        ],
      ),
      WorkoutPlanModel(
        id: 2,
        userId: 2,
        title: 'Leg Day Champion',
        category: 'Lower Body',
        description:
            'Build stronger legs with this lower body focused workout routine.',
        duration: 50,
        difficulty: 'Advanced',
        imageUrl: 'assets/images/Workout_plan.jpg',
        exercises: [
          Exercise(
            name: 'Squats',
            description:
                'Stand with feet shoulder-width apart, lower your body as if sitting in a chair.',
            sets: 4,
            reps: 12,
            restTime: 90,
            imageUrl: 'assets/images/workout.png',
          ),
          Exercise(
            name: 'Lunges',
            description:
                'Step forward with one leg and lower your hips until both knees are bent at 90 degrees.',
            sets: 3,
            reps: 10,
            restTime: 60,
            imageUrl: 'assets/images/workout.png',
          ),
          Exercise(
            name: 'Deadlifts',
            description:
                'Bend at hips and knees to lower down and grab the bar, then return to standing.',
            sets: 4,
            reps: 8,
            restTime: 90,
            imageUrl: 'assets/images/workout.png',
          ),
        ],
      ),
    ];
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
