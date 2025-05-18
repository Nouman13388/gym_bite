import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/meal_plan_model.dart';
import '../../../models/user_model.dart';
import '../../../services/meal_plan_service.dart';
import '../../../services/auth_service.dart';

class TrainerMealPlanController extends GetxController {
  final MealPlanService _mealPlanService = MealPlanService();
  final AuthService _authService = Get.find<AuthService>();

  // Observable properties
  final mealPlans = <MealPlanModel>[].obs;
  final selectedPlan = Rx<MealPlanModel?>(null);
  final isLoading = false.obs;
  final clients = <UserModel>[].obs;
  final selectedCategory = 'All'.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  final categories =
      [
        'All',
        'Weight Loss',
        'Muscle Gain',
        'Maintenance',
        'Vegetarian',
        'Vegan',
        'Keto',
      ].obs;
  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;

    // Debug logs for user information
    print('TrainerMealPlanController - onInit');
    print('Current user from AuthService: ${_authService.userModel?.toJson()}');
    print('User ID: ${_authService.userModel?.id}');
    print('User Firebase UID: ${_authService.userModel?.firebaseUid}');
    print('User Role: ${_authService.userModel?.role}');

    fetchMealPlans();
    fetchClients();
  }

  Future<void> fetchMealPlans() async {
    try {
      isLoading.value = true;

      // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        print('DEBUG TrainerMealPlanController: User ID found: ${user.id}');
        try {
          // Fetch meal plans created by this trainer
          print(
            'DEBUG TrainerMealPlanController: Fetching meal plans for trainer ID: ${user.id}',
          );
          final plans = await _mealPlanService.getTrainerMealPlans(user.id);
          mealPlans.value = plans;
          print(
            'DEBUG TrainerMealPlanController: Fetched ${plans.length} meal plans for trainer',
          );

          // Log details about the loaded meal plans
          logMealPlansStatus();
        } catch (e) {
          print(
            'DEBUG TrainerMealPlanController: Error fetching trainer meal plans: $e',
          );

          // Fallback to all meal plans if trainer-specific endpoint fails
          print(
            'DEBUG TrainerMealPlanController: Falling back to fetching all meal plans',
          );
          try {
            final plans = await _mealPlanService.getAllMealPlans();
            mealPlans.value = plans;
            print(
              'DEBUG TrainerMealPlanController: Fetched ${plans.length} meal plans from fallback',
            );
          } catch (fallbackError) {
            print(
              'DEBUG TrainerMealPlanController: Fallback also failed: $fallbackError',
            );
          }
        }
      } else {
        print('DEBUG TrainerMealPlanController: No user ID available');
        // No user ID available, fallback to getting all meal plans
        try {
          print('DEBUG TrainerMealPlanController: Fetching all meal plans');
          final plans = await _mealPlanService.getAllMealPlans();
          mealPlans.value = plans;
          print(
            'DEBUG TrainerMealPlanController: Fetched ${plans.length} meal plans',
          );
        } catch (e) {
          print(
            'DEBUG TrainerMealPlanController: Error fetching all meal plans: $e',
          );
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load meal plans: ${e.toString()}');
    }
  }

  Future<void> fetchClients() async {
    // In a real app, fetch clients assigned to this trainer
    // This is a placeholder
  }
  // Helper method to display meal plans status
  void logMealPlansStatus() {
    if (mealPlans.isEmpty) {
      print(
        'DEBUG TrainerMealPlanController: No meal plans available for this trainer',
      );
    } else {
      print(
        'DEBUG TrainerMealPlanController: ${mealPlans.length} meal plans loaded',
      );
      for (var plan in mealPlans) {
        print(
          'DEBUG TrainerMealPlanController: Plan - ${plan.title}, Category: ${plan.category}',
        );
      }
    }
  }

  // This method is kept for reference but no longer used
  void _loadSampleData() {
    mealPlans.value = [
      MealPlanModel(
        id: 1,
        trainerId: 1,
        title: 'Weight Loss Program',
        description:
            'A calorie-restricted meal plan to help clients lose weight gradually and healthily.',
        category: 'Weight Loss',
        imageUrl: 'assets/images/Meal_plan1.png',
        meals: [
          Meal(
            name: 'Avocado & Egg Toast',
            description: 'Healthy breakfast with whole grain toast and avocado',
            type: 'Breakfast',
            ingredients: [
              'Whole grain bread',
              'Avocado',
              'Eggs',
              'Salt',
              'Pepper',
            ],
            calories: 350,
            protein: 15,
            imageUrl: 'assets/images/Meals.png',
          ),
          Meal(
            name: 'Grilled Chicken Salad',
            description: 'Fresh salad with lean protein',
            type: 'Lunch',
            ingredients: [
              'Chicken breast',
              'Mixed greens',
              'Cherry tomatoes',
              'Cucumber',
              'Olive oil',
            ],
            calories: 400,
            protein: 35,
            imageUrl: 'assets/images/Meals.png',
          ),
          Meal(
            name: 'Baked Salmon with Veggies',
            description: 'Omega-rich dinner option',
            type: 'Dinner',
            ingredients: [
              'Salmon fillet',
              'Broccoli',
              'Carrots',
              'Lemon',
              'Olive oil',
            ],
            calories: 450,
            protein: 30,
            imageUrl: 'assets/images/Meals.png',
          ),
        ],
      ),
      MealPlanModel(
        id: 2,
        trainerId: 1,
        title: 'Muscle Building Plan',
        description:
            'High-protein meal plan designed to support muscle growth and recovery.',
        category: 'Muscle Gain',
        imageUrl: 'assets/images/Meal_plan2.png',
        meals: [
          Meal(
            name: 'Protein Oatmeal',
            description: 'Protein-packed start to your day',
            type: 'Breakfast',
            ingredients: [
              'Oats',
              'Protein powder',
              'Banana',
              'Almond milk',
              'Honey',
            ],
            calories: 450,
            protein: 25,
            imageUrl: 'assets/images/Meals.png',
          ),
          Meal(
            name: 'Chicken & Rice Bowl',
            description: 'Classic bodybuilding meal',
            type: 'Lunch',
            ingredients: [
              'Chicken breast',
              'Brown rice',
              'Broccoli',
              'Olive oil',
              'Spices',
            ],
            calories: 550,
            protein: 40,
            imageUrl: 'assets/images/Meals.png',
          ),
          Meal(
            name: 'Steak with Sweet Potato',
            description: 'Protein and complex carbs for dinner',
            type: 'Dinner',
            ingredients: [
              'Lean steak',
              'Sweet potato',
              'Asparagus',
              'Butter',
              'Garlic',
            ],
            calories: 650,
            protein: 45,
            imageUrl: 'assets/images/Meals.png',
          ),
        ],
      ),
    ];
  }

  List<MealPlanModel> get filteredMealPlans {
    if (selectedCategory.value == 'All') {
      return mealPlans;
    } else {
      return mealPlans
          .where((plan) => plan.category == selectedCategory.value)
          .toList();
    }
  }

  void selectMealPlan(MealPlanModel plan) {
    selectedPlan.value = plan;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> createMealPlan(
    MealPlanModel mealPlan,
    String text,
    String category,
  ) async {
    try {
      isLoading.value = true;
      final createdPlan = await _mealPlanService.createMealPlan(mealPlan);
      mealPlans.add(createdPlan);
      isLoading.value = false;
      Get.snackbar('Success', 'Meal plan created successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to create meal plan: ${e.toString()}');
    }
  }

  Future<void> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      isLoading.value = true;
      final updatedPlan = await _mealPlanService.updateMealPlan(mealPlan);

      // Update the plan in the list
      final index = mealPlans.indexWhere((p) => p.id == mealPlan.id);
      if (index != -1) {
        mealPlans[index] = updatedPlan;
      }

      isLoading.value = false;
      Get.snackbar('Success', 'Meal plan updated successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to update meal plan: ${e.toString()}');
    }
  }

  Future<void> createNewMealPlan(Map<String, dynamic> mealPlanData) async {
    try {
      isLoading.value = true;

      // Debug prints for meal plan creation
      print('TrainerMealPlanController - createNewMealPlan');
      print('Current user ID: ${user.value?.id}');
      print('Meal plan data before API call: $mealPlanData');

      // Check if the user ID is valid before proceeding
      final userId = mealPlanData['userId'];
      if (userId == 0 || userId == null) {
        print('ERROR: Cannot create meal plan with invalid user ID: $userId');
        // Try to refresh the user data once more
        await refreshUserData();

        // Update the meal plan data with the refreshed user ID
        if (user.value != null && user.value!.id > 0) {
          print('Updated user ID from $userId to ${user.value!.id}');
          mealPlanData['userId'] = user.value!.id;
        } else {
          // Still no valid user ID, show error and return
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Cannot create meal plan: User ID not available. Please log out and log back in.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
          );
          return;
        }
      }

      // Call the API to create the meal plan
      final createdPlan = await _mealPlanService.createNewMealPlan(
        mealPlanData,
      );

      // Add the new meal plan to the list if successful
      if (createdPlan != null) {
        mealPlans.add(createdPlan);
        print('Meal plan created successfully: ${createdPlan.toJson()}');
        Get.snackbar(
          'Success',
          'Meal plan created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('Failed to create meal plan - returned null from service');
        Get.snackbar(
          'Error',
          'Failed to create meal plan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Exception in createNewMealPlan: $e');
      Get.snackbar(
        'Error',
        'Failed to create meal plan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteMealPlan(int mealPlanId) async {
    try {
      isLoading.value = true;
      final success = await _mealPlanService.deleteMealPlan(mealPlanId);

      if (success) {
        // Remove the plan from the list
        mealPlans.removeWhere((p) => p.id == mealPlanId);
        Get.snackbar('Success', 'Meal plan deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete meal plan');
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete meal plan: ${e.toString()}');
    }
  }

  Future<void> assignMealPlanToClient(int mealPlanId, int clientId) async {
    try {
      isLoading.value = true;
      final success = await _mealPlanService.assignMealPlanToClient(
        mealPlanId,
        clientId,
      );

      isLoading.value = false;
      if (success) {
        Get.snackbar('Success', 'Meal plan assigned successfully');
      } else {
        Get.snackbar('Error', 'Failed to assign meal plan');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to assign meal plan: ${e.toString()}');
    }
  }

  // Additional convenience method that accepts a String clientId
  Future<void> assignPlanToClient(int mealPlanId, String clientId) async {
    try {
      isLoading.value = true;
      // Convert the client ID string to integer if needed
      // or use it directly if your API accepts string IDs
      int clientIdInt;
      try {
        // Try to parse the string to an integer
        clientIdInt = int.parse(clientId.replaceAll('client_', ''));
      } catch (e) {
        // If parsing fails, use a default value or handle accordingly
        clientIdInt = 1; // Default client ID for testing
      }

      final success = await _mealPlanService.assignMealPlanToClient(
        mealPlanId,
        clientIdInt,
      );

      isLoading.value = false;
      if (success) {
        Get.snackbar('Success', 'Meal plan assigned successfully');
      } else {
        Get.snackbar('Error', 'Failed to assign meal plan');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to assign meal plan: ${e.toString()}');
    }
  }

  // Method to ensure we have the latest user data before creating a meal plan
  Future<void> refreshUserData() async {
    print('TrainerMealPlanController - refreshUserData called');

    // First check current user data
    print('Current user before refresh: ${user.value?.toJson()}');
    print('Current User ID: ${user.value?.id}');

    try {
      // Use AuthService to force refresh user data from API
      final refreshedUser = await _authService.refreshUserData();
      if (refreshedUser != null) {
        user.value = refreshedUser;
        print('User data refreshed successfully');
        print('New user data: ${user.value?.toJson()}');
        print('New User ID: ${user.value?.id}');
      } else {
        print('Failed to refresh user data from AuthService');
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }

    // If user is still null or id is 0, log a warning
    if (user.value == null || user.value?.id == 0) {
      print('WARNING: User is still null or has ID=0 after refresh');
    }
  }
}
