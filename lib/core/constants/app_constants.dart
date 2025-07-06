import '../config/environment_config.dart';

class AppConstants {
  static const String appName = 'GymBite';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;
  static final String userEndpoint = '$baseUrl/users';
  static final String clientEndpoint = '$baseUrl/clients';
  static final String trainerEndpoint = '$baseUrl/trainers';
  static final String appointmentEndpoint = '$baseUrl/appointments';
  static final String feedbackEndpoint = '$baseUrl/feedbacks';
  static final String consultationEndpoint = '$baseUrl/consultations';
  static final String mealPlanEndpoint = '$baseUrl/meal-plans';
  static final String workoutPlanEndpoint = '$baseUrl/workout-plans';
  static final String progressEndpoint = '$baseUrl/progress';
  static final String authEndpoint = '$baseUrl/auth';

  // Extended Client Endpoints
  static final String clientCompleteProfileEndpoint =
      '$baseUrl/clients/{id}/complete';
  static final String clientPlansEndpoint = '$baseUrl/clients/{id}/plans';
  static final String clientProgressEndpoint = '$baseUrl/clients/{id}/progress';
  static final String clientActivitiesEndpoint =
      '$baseUrl/clients/{id}/activities';

  // Extended Trainer Endpoints
  static final String trainerCompleteProfileEndpoint =
      '$baseUrl/trainers/{id}/complete';
  static final String trainerClientsEndpoint = '$baseUrl/trainers/{id}/clients';
  static final String trainerScheduleEndpoint =
      '$baseUrl/trainers/{id}/schedule';
  static final String trainerMetricsEndpoint = '$baseUrl/trainers/{id}/metrics';

  // Route Names
  static final String splashRoute = '/splash';
  static final String loginRoute = '/login';
  static final String registerRoute = '/register';
  static final String dashboardRoute = '/dashboard';
  static final String profileRoute = '/profile';
  static final String plansRoute = '/plans';
  static final String appointmentsRoute = '/appointments';
  static final String chatRoute = '/chat';
  static final String feedbackRoute = '/feedback';
}
