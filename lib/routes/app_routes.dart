part of 'app_pages.dart';

abstract class Routes {
  // Common routes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const MAIN_DASHBOARD = '/main_dashboard';

  // Client routes
  static const CLIENT_DASHBOARD = '/client_dashboard';
  static const PLANS = '/plans';
  static const APPOINTMENTS = '/appointments';
  static const CHAT = '/chat';
  static const PROGRESS = '/progress';
  static const FEEDBACK = '/feedback';
  static const MEAL_PLAN_DETAILS = '/meal_plan_details';
  static const MEAL_PLAN_SELECTION = '/meal_plan_selection';
  static const MEAL_PLAN_OVERVIEW = '/meal_plan_overview';

  // Trainer routes
  static const TRAINER_DASHBOARD = '/trainer_dashboard';
  static const CLIENTS = '/clients';
  static const SCHEDULE = '/schedule';
  static const CREATE_PLAN = '/create_plan';
  static const CREATE_MEAL_PLAN = '/create_meal_plan';
}
