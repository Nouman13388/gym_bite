import 'package:get/get.dart';
import 'package:gym_bite/modules/meal_plans/meal-plan-details.dart';
import 'package:gym_bite/modules/meal_plans/meal-plan-screen1.dart';
import 'package:gym_bite/modules/meal_plans/meal-plan-screen2.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/dashboard/views/client_dashboard_view.dart';
import '../modules/dashboard/views/trainer_dashboard_view.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MEAL_PLAN;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(name: Routes.LOGIN, page: () => const LoginView()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterView()),
    GetPage(name: Routes.MEAL_PLAN, page: () => const MealPlanScreen1()),
    GetPage(
      name: Routes.CLIENT_DASHBOARD,
      page: () => const ClientDashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: Routes.TRAINER_DASHBOARD,
      page: () => const TrainerDashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
  ];
}
