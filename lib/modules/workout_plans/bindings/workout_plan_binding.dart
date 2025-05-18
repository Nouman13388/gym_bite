import 'package:get/get.dart';
import '../controllers/workout_plan_controller.dart';

class WorkoutPlanBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutPlanController>(() => WorkoutPlanController());
  }
}
