import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_workout_plan_controller.dart';
import '../../../models/workout_model.dart';

class TrainerWorkoutPlanViewEmbedded
    extends GetView<TrainerWorkoutPlanController> {
  const TrainerWorkoutPlanViewEmbedded({super.key});

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
                          'My Workout Plans',
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
                          'Create and manage workout plans for your clients',
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

                      // Workout Plans
                      Expanded(
                        child: Obx(
                          () =>
                              controller.filteredWorkoutPlans.isEmpty
                                  ? controller.hasError.value
                                      ? _buildErrorState()
                                      : const Center(
                                        child: Text(
                                          'No workout plans available',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                  : RefreshIndicator(
                                    onRefresh: controller.refreshWorkoutPlans,
                                    backgroundColor: Colors.black,
                                    color: Colors.cyanAccent,
                                    child: ListView.builder(
                                      itemCount:
                                          controller
                                              .filteredWorkoutPlans
                                              .length,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final plan =
                                            controller
                                                .filteredWorkoutPlans[index];
                                        return WorkoutPlanCard(
                                          plan: plan,
                                          onTap:
                                              () => _showWorkoutPlanDetails(
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
              _showCreateWorkoutPlanModal(context);
            },
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _showCreateWorkoutPlanModal(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final durationController = TextEditingController();
    final difficultyController = TextEditingController();

    // Pre-select a category
    categoryController.text =
        controller.categories.contains('Upper Body')
            ? 'Upper Body'
            : controller.categories.first;

    // Pre-select a difficulty
    difficultyController.text = 'Intermediate';

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
                  'Create New Workout Plan',
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
                  value: categoryController.text,
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
                          .where((c) => c != 'All')
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
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey.shade800,
                  value: difficultyController.text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Difficulty',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Beginner',
                      child: Text('Beginner'),
                    ),
                    DropdownMenuItem(
                      value: 'Intermediate',
                      child: Text('Intermediate'),
                    ),
                    DropdownMenuItem(
                      value: 'Advanced',
                      child: Text('Advanced'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      difficultyController.text = value;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: durationController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
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
                            durationController.text.isNotEmpty) {
                          final category =
                              categoryController.text.isNotEmpty
                                  ? categoryController.text
                                  : controller.categories.first;

                          final difficulty =
                              difficultyController.text.isNotEmpty
                                  ? difficultyController.text
                                  : 'Intermediate';

                          final duration =
                              int.tryParse(durationController.text) ?? 30;
                          print('DEBUG: Creating workout with input fields:');
                          print('DEBUG: Title: ${titleController.text}');
                          print('DEBUG: Category: $category');
                          print('DEBUG: Duration: $duration');

                          // Format data to match the API requirements
                          final workoutPlanData = {
                            'name': titleController.text,
                            'description': descriptionController.text,
                            'category': category,
                            'difficulty': difficulty,
                            'duration': duration,
                            'imageUrl': 'assets/images/workout.png',
                            'exercises':
                                'Squats, Push-ups, Lunges', // Default exercises as a string per the API format
                            'sets': 3,
                            'reps': 12,
                          };

                          print(
                            'DEBUG: Submitting workout plan data: $workoutPlanData',
                          );

                          Get.back(); // Close the dialog first

                          // Show a loading indicator
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.cyanAccent,
                                ),
                              ),
                            ),
                            barrierDismissible: false,
                          );

                          // Try to create the workout plan
                          controller.createWorkoutPlan(workoutPlanData).then((
                            success,
                          ) {
                            // Close the loading dialog
                            Get.back();

                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Workout plan created successfully',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to create workout plan',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          });
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please fill in all required fields',
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

  void _showWorkoutPlanDetails(BuildContext context, WorkoutPlanModel plan) {
    controller.selectWorkoutPlan(plan);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => WorkoutPlanDetailsSheet(plan: plan),
    );
  }

  void _showAssignPlanSheet(BuildContext context, WorkoutPlanModel plan) {
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
                          'Workout plan assigned to ${clientNames[index]}',
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

  void _showDeleteConfirmation(BuildContext context, WorkoutPlanModel plan) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Delete Workout Plan',
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
              controller.deleteWorkoutPlan(plan.id);
              Get.back();
              Get.snackbar(
                'Success',
                'Workout plan deleted successfully',
                backgroundColor: Colors.black54,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load workout plans',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshWorkoutPlans,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onAssignTap;
  final VoidCallback onDeleteTap;

  const WorkoutPlanCard({
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
                            '${plan.exercises.length} exercises',
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

class WorkoutPlanDetailsSheet extends StatelessWidget {
  final WorkoutPlanModel plan;

  const WorkoutPlanDetailsSheet({super.key, required this.plan});

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
                      'Workout plan editing feature is under development',
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
          // Exercises
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              'Exercises',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plan.exercises.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final exercise = plan.exercises[index];
                return ExerciseCard(exercise: exercise, index: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int index;

  const ExerciseCard({super.key, required this.exercise, required this.index});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Number
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.cyanAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Exercise Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildExerciseDetail('Sets', exercise.sets.toString()),
                    const SizedBox(width: 16),
                    _buildExerciseDetail('Reps', exercise.reps.toString()),
                    const SizedBox(width: 16),
                    _buildExerciseDetail('Rest', '${exercise.restTime}s'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetail(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
