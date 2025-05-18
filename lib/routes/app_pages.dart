import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/dashboard/bindings/client_dashboard_binding.dart'
    as bindings;
import '../modules/dashboard/bindings/trainer_dashboard_binding.dart';
import '../modules/dashboard/bindings/main_dashboard_binding.dart';
import '../modules/dashboard/views/client_dashboard_view.dart';
import '../modules/dashboard/views/trainer_dashboard_view.dart';
import '../modules/dashboard/views/client_main_dashboard_view.dart';
import '../modules/dashboard/views/trainer_main_dashboard_view.dart';
import '../modules/meal_plans/bindings/meal_plan_binding.dart';
import '../modules/meal_plans/bindings/meal_plan_bindings.dart';
import '../modules/meal_plans/views/meal_plan_details_view.dart';
import '../modules/meal_plans/views/meal_plan_selection_view.dart';
import '../modules/meal_plans/views/meal_plan_overview_view.dart';
import '../modules/meal_plans/views/client_meal_plan_view.dart';
import '../modules/meal_plans/views/trainer_meal_plan_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../services/auth_service.dart';

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
      binding: MealPlanBinding(),
    ),
    GetPage(
      name: Routes.MEAL_PLAN_SELECTION,
      page: () => const MealPlanSelectionView(),
      binding: MealPlanBinding(),
    ),
    GetPage(
      name: Routes.MEAL_PLAN_OVERVIEW,
      page: () => const MealPlanOverviewView(),
      binding: MealPlanBinding(),
    ),
    GetPage(
      name: Routes.CLIENT_MEAL_PLANS,
      page: () => const ClientMealPlanView(),
      binding: MealPlanBindings(),
    ),
    GetPage(
      name: Routes.TRAINER_MEAL_PLANS,
      page: () => const TrainerMealPlanView(),
      binding: MealPlanBindings(),
    ),
    GetPage(
      name: Routes.CLIENT_DASHBOARD,
      page: () => const ClientDashboardView(),
      binding: bindings.ClientDashboardBinding(),
    ),
    GetPage(
      name: Routes.TRAINER_DASHBOARD,
      page: () => const TrainerMainDashboardView(),
      binding: MainDashboardBinding(),
    ),
    GetPage(
      name: Routes.MAIN_DASHBOARD,
      page: () {
        final authService = Get.find<AuthService>();
        final isTrainer = authService.userModel?.isTrainer ?? false;
        return isTrainer
            ? const TrainerMainDashboardView()
            : const ClientMainDashboardView();
      },
      binding: MainDashboardBinding(),
    ),
  ];
}
