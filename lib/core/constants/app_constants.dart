class AppConstants {
  static const String appName = 'GymBite';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'http://13.61.146.2:3000/api';
  static const String userEndpoint = '$baseUrl/users';
  static const String clientEndpoint = '$baseUrl/clients';
  static const String trainerEndpoint = '$baseUrl/trainers';
  static const String appointmentEndpoint = '$baseUrl/appointments';
  static const String feedbackEndpoint = '$baseUrl/feedbacks';
  static const String consultationEndpoint = '$baseUrl/consultations';
  static const String mealPlanEndpoint = '$baseUrl/meal-plans';
  static const String workoutPlanEndpoint = '$baseUrl/workout-plans';
  static const String progressEndpoint = '$baseUrl/progress';
  static const String authEndpoint = '$baseUrl/auth';

  // Extended Client Endpoints
  static const String clientCompleteProfileEndpoint =
      '$baseUrl/clients/{id}/complete';
  static const String clientPlansEndpoint = '$baseUrl/clients/{id}/plans';
  static const String clientProgressEndpoint = '$baseUrl/clients/{id}/progress';
  static const String clientActivitiesEndpoint =
      '$baseUrl/clients/{id}/activities';

  // Extended Trainer Endpoints
  static const String trainerCompleteProfileEndpoint =
      '$baseUrl/trainers/{id}/complete';
  static const String trainerClientsEndpoint = '$baseUrl/trainers/{id}/clients';
  static const String trainerScheduleEndpoint =
      '$baseUrl/trainers/{id}/schedule';
  static const String trainerMetricsEndpoint = '$baseUrl/trainers/{id}/metrics';

  // Route Names
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String profileRoute = '/profile';
  static const String plansRoute = '/plans';
  static const String appointmentsRoute = '/appointments';
  static const String chatRoute = '/chat';
  static const String feedbackRoute = '/feedback';
}
