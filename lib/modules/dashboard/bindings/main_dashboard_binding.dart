import 'package:get/get.dart';
import '../controllers/main_dashboard_controller.dart';
import '../controllers/client_dashboard_controller.dart';
import '../controllers/trainer_dashboard_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../meal_plans/controllers/meal_plan_controller.dart';
import '../../profile/controllers/client_profile_controller.dart';
import '../../profile/controllers/trainer_profile_controller.dart';
import '../../../services/auth_service.dart';

class MainDashboardBinding implements Bindings {
  @override
  void dependencies() {
    // Main dashboard controller is always needed
    Get.lazyPut<MainDashboardController>(() => MainDashboardController());

    // Original dashboard controller still needed for some functionality
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(() => DashboardController());
    }

    // Get the user role
    final authService = Get.find<AuthService>();
    final isTrainer = authService.userModel?.isTrainer ?? false;

    if (isTrainer) {
      // Register trainer-specific controllers
      Get.lazyPut<TrainerDashboardController>(
        () => TrainerDashboardController(),
      );
      Get.lazyPut<TrainerProfileController>(() => TrainerProfileController());

      // Additional trainer-specific controllers could be registered here
    } else {
      // Register client-specific controllers
      Get.lazyPut<ClientDashboardController>(() => ClientDashboardController());
      Get.lazyPut<MealPlanController>(() => MealPlanController());
      Get.lazyPut<ClientProfileController>(() => ClientProfileController());

      // Additional client-specific controllers could be registered here
    }
  }
}
