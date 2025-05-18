import 'package:get/get.dart';
import '../../../models/meal_plan_model.dart';
import '../../../services/meal_plan_service.dart';

class ClientMealPlanController extends GetxController {
  final MealPlanService _mealPlanService = MealPlanService();

  // Observable properties
  final mealPlans = <MealPlanModel>[].obs;
  final selectedPlan = Rx<MealPlanModel?>(null);
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;

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
    fetchMealPlans();
  }

  Future<void> fetchMealPlans() async {
    try {
      isLoading.value = true;

      // In a real app, you would fetch plans assigned to the current client
      // For now, we'll fetch all meal plans
      final plans = await _mealPlanService.getAllMealPlans();
      mealPlans.value = plans;

      // If no plans are returned from API, use sample data for testing
      if (mealPlans.isEmpty) {
        _loadSampleData();
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load meal plans: ${e.toString()}');
    }
  }

  void _loadSampleData() {
    mealPlans.value = [
      MealPlanModel(
        id: 1,
        trainerId: 1,
        title: 'Weight Loss Program',
        description:
            'A calorie-restricted meal plan to help you lose weight gradually and healthily.',
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
}
