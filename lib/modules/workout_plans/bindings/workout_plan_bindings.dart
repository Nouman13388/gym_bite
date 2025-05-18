import 'package:get/get.dart';
import '../controllers/client_workout_plan_controller.dart';
import '../controllers/trainer_workout_plan_controller.dart';

class WorkoutPlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientWorkoutPlanController>(() => ClientWorkoutPlanController());
    Get.lazyPut<TrainerWorkoutPlanController>(() => TrainerWorkoutPlanController());
  }
}
