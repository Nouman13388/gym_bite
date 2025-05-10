import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
  }

  bool get isTrainer => user.value?.isTrainer ?? false;
  bool get isClient => user.value?.isClient ?? false;
  bool get isAdmin => user.value?.isAdmin ?? false;

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed('/login');
  }
}
