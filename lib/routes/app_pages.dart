import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/dashboard/views/client_dashboard_view.dart';
import '../modules/dashboard/views/trainer_dashboard_view.dart';
import '../modules/meal_plans/views/meal_plan_details_view.dart';
import '../modules/meal_plans/views/meal_plan_selection_view.dart';
import '../modules/meal_plans/views/meal_plan_overview_view.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),

    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.MEAL_PLAN_DETAILS,
      page: () => const MealPlanDetailsView(),
    ),
    GetPage(
      name: Routes.MEAL_PLAN_1,
      page: () => const MealPlanSelectionView(),
    ),
    GetPage(name: Routes.MEAL_PLAN_2, page: () => const MealPlanOverviewView()),
    GetPage(
      name: Routes.CLIENT_DASHBOARD,
      page: () => const ClientDashboardView(),
      binding: ClientDashboardBinding(),
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
