import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class MealPlanModel {
  final int id;
  final String title;
  final String dietType;
  final String goal;
  final int dailyCalories;
  final List<Meal> meals;

  MealPlanModel({
    required this.id,
    required this.title,
    required this.dietType,
    required this.goal,
    required this.dailyCalories,
    required this.meals,
  });
}

class Meal {
  final String name;
  final String time;
  final String description;

  Meal({required this.name, required this.time, required this.description});
}

class MealPlanController extends GetxController {
  // Observable properties
  final selectedPlan = Rx<MealPlanModel?>(null);
  final isLoading = false.obs;
  final mealPlans = <MealPlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMealPlans();
  }

  Future<void> fetchMealPlans() async {
    try {
      isLoading.value = true;
      // In a real app, you would fetch from API
      // For now simulating data
      await Future.delayed(const Duration(seconds: 1));

      // Sample meal plans
      mealPlans.value = [
        MealPlanModel(
          id: 1,
          title: 'Meal Plan 1',
          dietType: 'High Protein, Non-Vegetarian',
          goal: 'Muscle Gain',
          dailyCalories: 2500,
          meals: [
            Meal(
              name: 'Breakfast',
              time: '08:00 AM',
              description:
                  '3 scrambled eggs, 2 slices whole grain toast, 1 avocado, 1 banana, 1 glass of whole milk',
            ),
            Meal(
              name: 'Lunch',
              time: '01:00 PM',
              description:
                  'Grilled chicken breast (200g), brown rice (1 cup), steamed broccoli and carrots, olive oil dressing',
            ),
            Meal(
              name: 'Dinner',
              time: '08:00 PM',
              description:
                  'Grilled salmon (150g), quinoa (1/2 cup), sautéed spinach, sweet potato wedges (100g)',
            ),
          ],
        ),
        MealPlanModel(
          id: 2,
          title: 'Meal Plan 2',
          dietType: 'Balanced, Vegetarian',
          goal: 'Weight Maintenance',
          dailyCalories: 2000,
          meals: [
            Meal(
              name: 'Breakfast',
              time: '07:30 AM',
              description:
                  'Greek yogurt with granola and berries, 1 apple, green tea',
            ),
            Meal(
              name: 'Lunch',
              time: '12:30 PM',
              description:
                  'Quinoa bowl with roasted vegetables, chickpeas, and tahini dressing',
            ),
            Meal(
              name: 'Dinner',
              time: '07:00 PM',
              description:
                  'Vegetable stir-fry with tofu, brown rice, and mixed seeds',
            ),
          ],
        ),
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load meal plans');
    }
  }

  void selectMealPlan(MealPlanModel plan) {
    selectedPlan.value = plan;
  }

  void navigateToMealPlanOverview() {
    Get.toNamed(Routes.MEAL_PLAN_OVERVIEW);
  }

  void navigateToMealPlanDetails(MealPlanModel plan) {
    selectMealPlan(plan);
    Get.toNamed(Routes.MEAL_PLAN_DETAILS);
  }
}
