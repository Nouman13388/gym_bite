import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_meal_plan_controller.dart';
import '../../../models/meal_plan_model.dart';

class TrainerMealPlanViewEmbedded extends GetView<TrainerMealPlanController> {
  const TrainerMealPlanViewEmbedded({super.key});

  @override
  Widget build(BuildContext context) {
    // Embedded view for use within the dashboard
    return Stack(
      children: [
        Obx(
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
                                      return MealPlanCard(
                                        plan: plan,
                                        onTap:
                                            () => _showMealPlanDetails(
                                              context,
                                              plan,
                                            ),
                                        onAssignTap:
                                            () => _showAssignPlanSheet(
                                              context,
                                              plan,
                                            ),
                                        onDeleteTap:
                                            () => _showDeleteConfirmation(
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
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.cyanAccent,
            onPressed: () async {
              // Refresh user data before showing the modal
              await controller.refreshUserData();
              _showCreateMealPlanModal(context);
            },
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _showCreateMealPlanModal(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final fatController = TextEditingController();
    final carbsController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create New Meal Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey.shade800,
                  value: controller.categories.first,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items:
                      controller.categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      categoryController.text = value;
                    }
                  },
                ),

                // Nutrition Information
                const SizedBox(height: 15),
                const Text(
                  'Nutrition Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Calories
                TextField(
                  controller: caloriesController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Calories (kcal)',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Macros Row
                Row(
                  children: [
                    // Protein
                    Expanded(
                      child: TextField(
                        controller: proteinController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Protein (g)',
                          labelStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Fat
                    Expanded(
                      child: TextField(
                        controller: fatController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Fat (g)',
                          labelStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Carbs
                TextField(
                  controller: carbsController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Carbs (g)',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            caloriesController.text.isNotEmpty &&
                            proteinController.text.isNotEmpty &&
                            fatController.text.isNotEmpty &&
                            carbsController.text.isNotEmpty) {
                          final category =
                              categoryController.text.isNotEmpty
                                  ? categoryController.text
                                  : controller.categories.first;

                          // Debug print user info before creating meal plan data
                          print(
                            'TrainerMealPlanViewEmbedded - Create Button Pressed',
                          );
                          print('Current auth user details:');
                          if (controller.user.value != null) {
                            print('User ID: ${controller.user.value?.id}');
                            print('User Name: ${controller.user.value?.name}');
                            print('User Role: ${controller.user.value?.role}');
                            print(
                              'User Firebase UID: ${controller.user.value?.firebaseUid}',
                            );
                          } else {
                            print('WARNING: User is null in controller');
                          }

                          // Check if user ID is valid
                          final userId = controller.user.value?.id ?? 0;
                          if (userId == 0) {
                            print(
                              'WARNING: User ID is 0, which may cause API errors',
                            );
                            Get.snackbar(
                              'Warning',
                              'User ID not found. Please ensure you are logged in.',
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                            // You could return here to prevent the API call
                            // or proceed and let the server handle it
                          }

                          // Create map with the required data structure for the API
                          final Map<String, dynamic> mealPlanData = {
                            "userId": userId, // Get current user ID
                            "name": titleController.text,
                            "description": descriptionController.text,
                            "calories":
                                int.tryParse(caloriesController.text) ?? 0,
                            "protein":
                                double.tryParse(proteinController.text) ?? 0.0,
                            "fat": double.tryParse(fatController.text) ?? 0.0,
                            "carbs":
                                double.tryParse(carbsController.text) ?? 0.0,
                            "category": category,
                          };

                          print("Creating meal plan with data: $mealPlanData");
                          controller.createNewMealPlan(mealPlanData);
                          Get.back();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please fill in all fields',
                            backgroundColor: Colors.black54,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMealPlanDetails(BuildContext context, MealPlanModel plan) {
    controller.selectMealPlan(plan);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MealPlanDetailsSheet(plan: plan),
    );
  }

  void _showAssignPlanSheet(BuildContext context, MealPlanModel plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Assign to Client',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // In a real app, you would fetch clients from an API
                // For now, we'll use a dummy list
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final clientNames = [
                      'John Doe',
                      'Jane Smith',
                      'Alex Johnson',
                    ];
                    return ListTile(
                      title: Text(
                        clientNames[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: CircleAvatar(child: Text(clientNames[index][0])),
                      onTap: () {
                        // Assign plan to client
                        controller.assignPlanToClient(
                          plan.id,
                          'client_${index + 1}',
                        );
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Meal plan assigned to ${clientNames[index]}',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MealPlanModel plan) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Meal Plan'),
        content: Text('Are you sure you want to delete ${plan.title}?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              controller.deleteMealPlan(plan.id);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class MealPlanCard extends StatelessWidget {
  final MealPlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onAssignTap;
  final VoidCallback onDeleteTap;

  const MealPlanCard({
    super.key,
    required this.plan,
    required this.onTap,
    required this.onAssignTap,
    required this.onDeleteTap,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            onPressed: onAssignTap,
                            tooltip: 'Assign to client',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: onDeleteTap,
                            tooltip: 'Delete plan',
                          ),
                        ],
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
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    // In a real app, this would navigate to an edit screen
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Meal plan editing feature is under development',
                      backgroundColor: Colors.black54,
                      colorText: Colors.white,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // In a real app, this would navigate to assign client screen
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Client assignment feature is under development',
                      backgroundColor: Colors.black54,
                      colorText: Colors.white,
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Assign'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                    const SizedBox(width: 16),
                    const Icon(Icons.restaurant, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${meal.protein}g protein',
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
