import 'package:get/get.dart';
import '../controllers/client_profile_controller.dart';
import '../controllers/trainer_profile_controller.dart';
import '../../../services/auth_service.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    final authService = Get.find<AuthService>();
    final isTrainer = authService.userModel?.isTrainer ?? false;

    if (isTrainer) {
      Get.lazyPut<TrainerProfileController>(() => TrainerProfileController());
    } else {
      Get.lazyPut<ClientProfileController>(() => ClientProfileController());
    }
  }
}
