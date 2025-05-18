import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_meal_plan_controller.dart';
import '../../../models/meal_plan_model.dart';

class TrainerMealPlanView extends GetView<TrainerMealPlanController> {
  const TrainerMealPlanView({super.key});
  @override
  Widget build(BuildContext context) {
    // Using a Container instead of Scaffold as this is embedded in main dashboard
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
              SafeArea(
            child: Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.cyanAccent,
                          ),
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'My Meal Plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Manage meal plans for your clients',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
    
                          // Categories
                          SizedBox(
                            height: 40,
                            child: Obx(
                              () => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.categories.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final category = controller.categories[index];
                                  final isSelected =
                                      category == controller.selectedCategory.value;
    
                                  return GestureDetector(
                                    onTap:
                                        () => controller.selectCategory(category),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.cyanAccent
                                                : Colors.white10,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
    
                          const SizedBox(height: 20),
    
                          // Meal Plans
                          Expanded(
                            child: Obx(
                              () =>
                                  controller.filteredMealPlans.isEmpty
                                      ? const Center(
                                        child: Text(
                                          'No meal plans available',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                      : ListView.builder(
                                        itemCount:
                                            controller.filteredMealPlans.length,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        itemBuilder: (context, index) {
                                          final plan =
                                              controller.filteredMealPlans[index];
                                          return TrainerMealPlanCard(
                                            plan: plan,
                                            onTap:
                                                () => _showMealPlanManagement(
                                                  context,
                                                  plan,
                                                ),
                                            onAssign:
                                                () => _showAssignMealPlanDialog(
                                                  context,
                                                  plan,
                                                ),
                                            onEdit:
                                                () => _showEditMealPlanModal(
                                                  context,
                                                  plan,
                                                ),
                                            onDelete:
                                                () => _confirmDeleteMealPlan(
                                                  context,
                                                  plan,
                                                ),
                                          );
                                        },
                                      ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMealPlanManagement(BuildContext context, MealPlanModel plan) {
    controller.selectMealPlan(plan);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MealPlanDetailsSheet(plan: plan),
    );
  }

  void _showCreateMealPlanModal(BuildContext context) {
    // In a real implementation, you would show a form to create a new meal plan
    Get.snackbar(
      'Feature Coming Soon',
      'Create meal plan feature is under development',
      backgroundColor: Colors.cyan,
      colorText: Colors.white,
    );
  }

  void _showEditMealPlanModal(BuildContext context, MealPlanModel plan) {
    // In a real implementation, you would show a form to edit the meal plan
    Get.snackbar(
      'Feature Coming Soon',
      'Edit meal plan feature is under development',
      backgroundColor: Colors.cyan,
      colorText: Colors.white,
    );
  }

  void _confirmDeleteMealPlan(BuildContext context, MealPlanModel plan) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Delete Meal Plan',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${plan.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteMealPlan(plan.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAssignMealPlanDialog(BuildContext context, MealPlanModel plan) {
    // In a real implementation, you would show a list of clients to assign the plan to
    Get.snackbar(
      'Feature Coming Soon',
      'Assign meal plan feature is under development',
      backgroundColor: Colors.cyan,
      colorText: Colors.white,
    );
  }
}

class TrainerMealPlanCard extends StatelessWidget {
  final MealPlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onAssign;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TrainerMealPlanCard({
    super.key,
    required this.plan,
    required this.onTap,
    required this.onAssign,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(plan.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    plan.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${plan.meals.length} meals',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ActionButton(
                        icon: Icons.people,
                        label: 'Assign',
                        onTap: onAssign,
                      ),
                      const SizedBox(width: 10),
                      ActionButton(
                        icon: Icons.edit,
                        label: 'Edit',
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 10),
                      ActionButton(
                        icon: Icons.delete,
                        label: 'Delete',
                        onTap: onDelete,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealPlanDetailsSheet extends StatelessWidget {
  final MealPlanModel plan;

  const MealPlanDetailsSheet({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  plan.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  plan.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          // Meals
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Meals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plan.meals.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final meal = plan.meals[index];
                return MealCard(meal: meal);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Meal Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              meal.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Meal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        meal.type,
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  meal.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${meal.calories} kcal',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
