import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meal_plan_controller.dart';

class MealPlanOverviewView extends GetView<MealPlanController> {
  const MealPlanOverviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                'Select your Meal plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'choose a meal plan to start',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 30),
              mealPlanTile(context, 'Meal Plan 1'),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget mealPlanTile(BuildContext context, String title) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(20),
        width: 90,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/Meal_plan2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'view details',
        style: TextStyle(color: Colors.white54, fontSize: 14),
      ),      onTap: () {
        // Create a sample meal plan and navigate
        final mealPlan = MealPlanModel(
          id: 1,
          title: title,
          dietType: 'High Protein, Non-Vegetarian',
          goal: 'Muscle Gain',
          dailyCalories: 2500,
          meals: [
            Meal(
              name: 'Breakfast',
              time: '08:00 AM',
              description: '3 scrambled eggs, 2 slices whole grain toast, 1 avocado',
            ),
            Meal(
              name: 'Lunch',
              time: '01:00 PM',
              description: 'Grilled chicken breast, brown rice, steamed vegetables',
            ),
            Meal(
              name: 'Dinner',
              time: '08:00 PM',
              description: 'Grilled salmon, quinoa, sautéed spinach, sweet potato',
            ),
          ],
        );
        controller.navigateToMealPlanDetails(mealPlan);
      },
    );
  }
}

