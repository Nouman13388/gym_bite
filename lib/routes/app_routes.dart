part of 'app_pages.dart';

abstract class Routes {
  // Common routes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';

  // Client routes
  static const CLIENT_DASHBOARD = '/client-dashboard';
  static const PLANS = '/plans';
  static const APPOINTMENTS = '/appointments';
  static const CHAT = '/chat';
  static const PROGRESS = '/progress';
  static const MEAL_PLAN = '/meal-plan';

  // Trainer routes
  static const TRAINER_DASHBOARD = '/trainer-dashboard';
  static const CLIENTS = '/clients';
  static const SCHEDULE = '/schedule';
  static const CREATE_PLAN = '/create-plan';
  static const CREATE_MEAL_PLAN = '/create-meal-plan';
}
