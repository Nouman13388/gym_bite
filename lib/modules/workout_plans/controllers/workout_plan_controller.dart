import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/workout_model.dart';
import '../../../routes/app_pages.dart';

class WorkoutPlanController extends GetxController {
  // Observable properties
  final selectedPlan = Rx<WorkoutPlanModel?>(null);
  final isLoading = false.obs;
  final workoutPlans = <WorkoutPlanModel>[].obs;
  final selectedCategory = 'All'.obs;

  final categories =
      [
        'All',
        'Upper Body',
        'Lower Body',
        'Full Body',
        'Core',
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

      // Call the API to get workout plans
      final response = await http
          .get(
            Uri.parse('http://13.61.146.2:3000/api/workout-plans'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final plans =
            data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
        workoutPlans.value = plans;

        // If no plans are returned from API, use sample data for testing
        if (workoutPlans.isEmpty) {
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
            WorkoutPlanModel(
              id: 3,
              userId: 3,
              title: 'Core Crusher',
              category: 'Core',
              description:
                  'Strengthen your core with this targeted abdominal workout.',
              duration: 30,
              difficulty: 'Beginner',
              imageUrl: 'assets/images/workout_plans.jpeg',
              exercises: [
                Exercise(
                  name: 'Plank',
                  description:
                      'Hold a push-up position with your body in a straight line from head to heels.',
                  sets: 3,
                  reps: 1, // Hold for time
                  restTime: 45,
                  imageUrl: 'assets/images/workout.png',
                ),
                Exercise(
                  name: 'Crunches',
                  description:
                      'Lie on your back with knees bent and lift your shoulders towards your knees.',
                  sets: 3,
                  reps: 15,
                  restTime: 45,
                  imageUrl: 'assets/images/workout.png',
                ),
                Exercise(
                  name: 'Russian Twists',
                  description:
                      'Sit on the floor, lean back slightly, and twist your torso from side to side.',
                  sets: 3,
                  reps: 20,
                  restTime: 45,
                  imageUrl: 'assets/images/workout.png',
                ),
              ],
            ),
          ];
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load workout plans: ${e.toString()}');
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

  void navigateToWorkoutPlanDetails(WorkoutPlanModel plan) {
    selectWorkoutPlan(plan);
    Get.toNamed(Routes.WORKOUT_PLAN_DETAILS);
  }
}
