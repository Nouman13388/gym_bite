import 'package:get/get.dart';
import '../controllers/trainer_dashboard_controller.dart';
import '../controllers/dashboard_controller.dart';

class TrainerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerDashboardController>(() => TrainerDashboardController());
    // Ensure DashboardController is available
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(() => DashboardController());
    }
  }
}
