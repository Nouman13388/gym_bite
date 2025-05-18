import 'package:get/get.dart';
import '../controllers/client_meal_plan_controller.dart';
import '../controllers/trainer_meal_plan_controller.dart';

class MealPlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientMealPlanController>(() => ClientMealPlanController());
    Get.lazyPut<TrainerMealPlanController>(() => TrainerMealPlanController());
  }
}
