import 'package:get/get.dart';
import '../../../services/trainer_service.dart';
import '../../../services/auth_service.dart';

class TrainerDashboardController extends GetxController {
  final TrainerService _trainerService = TrainerService();
  final AuthService _authService = Get.find<AuthService>();

  // Trainer data from API
  final trainerProfile = Rx<Map<String, dynamic>>({});
  final trainerClients = Rx<List<dynamic>>([]);
  final trainerSchedule = Rx<Map<String, dynamic>>({});
  final trainerMetrics = Rx<Map<String, dynamic>>({});

  // Observable state
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Observable properties for dashboard
  final clientCount = 0.obs;
  final pendingAppointments = 0.obs;
  final completedSessions = 0.obs;
  final averageRating = 0.0.obs;

  // Trainer info
  final specialty = ''.obs;
  final experienceYears = 0.obs;

  // Client metrics
  final clientMetrics = <ClientMetric>[].obs;

  // Weekly schedule
  final weeklySchedule = <ScheduleItem>[].obs;

  // Weekly earnings data for chart (sample data as this might not come from API)
  final weeklyEarnings = <double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainerData();
  }

  Future<void> fetchTrainerData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = ''; // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        print('DEBUG TrainerDashboardController: User ID found: ${user.id}');

        // Find trainer ID associated with the user
        int trainerId;
        try {
          final foundTrainerId = await _trainerService.getTrainerIdByUserId(
            user.id,
          );

          if (foundTrainerId == null) {
            // Fallback to hardcoded ID only if needed (development/testing)
            trainerId = 8; // Temporary fallback - remove in production
            print(
              'DEBUG TrainerDashboardController: No trainer ID found for user, using fallback ID: $trainerId',
            );
          } else {
            trainerId = foundTrainerId;
            print(
              'DEBUG TrainerDashboardController: Found trainer ID: $trainerId for user ID: ${user.id}',
            );
          }
        } catch (e) {
          // If API endpoint doesn't exist yet, fallback to hardcoded ID
          trainerId = 8; // Temporary fallback - remove in production
          print(
            'DEBUG TrainerDashboardController: Error finding trainer ID, using fallback: $trainerId. Error: $e',
          );
        }

        print('DEBUG TrainerDashboardController: Using trainerId: $trainerId');

        try {
          // Fetch trainer complete profile
          final profile = await _trainerService.getTrainerCompleteProfile(
            trainerId,
          );
          trainerProfile.value = profile;
          print('DEBUG TrainerDashboardController: Trainer profile loaded');

          // Extract basic trainer info
          specialty.value = profile['specialty']?.toString() ?? '';
          experienceYears.value = profile['experienceYears'] ?? 0;

          print(
            'DEBUG TrainerDashboardController: Profile data extracted - Specialty: ${specialty.value}, Experience: ${experienceYears.value} years',
          );

          // Process appointments if available
          if (profile['appointments'] != null &&
              profile['appointments'] is List) {
            final appointments = List<Map<String, dynamic>>.from(
              profile['appointments'],
            );

            // Update schedule items from appointments
            weeklySchedule.clear();
            for (var appointment in appointments) {
              try {
                final DateTime appointmentTime = DateTime.parse(
                  appointment['appointmentTime'],
                );
                final String clientId =
                    appointment['clientId']?.toString() ?? 'Unknown';
                final String status = appointment['status'] ?? 'Scheduled';
                final String notes = appointment['notes'] ?? '';

                final dayOfWeek = _getDayOfWeek(appointmentTime.weekday);
                final formattedTime =
                    '${appointmentTime.hour}:${appointmentTime.minute.toString().padLeft(2, '0')}';

                weeklySchedule.add(
                  ScheduleItem(
                    clientName:
                        'Client #$clientId', // We'll replace with real names later
                    time: formattedTime,
                    day: dayOfWeek,
                    type: notes,
                    status: status,
                  ),
                );
              } catch (e) {
                print(
                  'DEBUG TrainerDashboardController: Error processing appointment: $e',
                );
              }
            }

            print(
              'DEBUG TrainerDashboardController: Processed ${weeklySchedule.length} appointments',
            );

            // Count pending appointments
            pendingAppointments.value =
                appointments
                    .where(
                      (a) =>
                          a['status'] == 'Pending' ||
                          a['status'] == 'Scheduled',
                    )
                    .length;
            print(
              'DEBUG TrainerDashboardController: Pending appointments: ${pendingAppointments.value}',
            );
          }

          // Fetch trainer clients
          final clients = await _trainerService.getTrainerClients(trainerId);
          trainerClients.value = clients;
          print(
            'DEBUG TrainerDashboardController: Trainer clients loaded: ${clients.length} clients',
          );

          // Update client metrics from clients list
          clientMetrics.clear();
          for (var client in clients) {
            try {
              clientMetrics.add(
                ClientMetric(
                  name: client['name'] ?? 'Unknown Client',
                  progress: client['progress'] ?? 0,
                  lastSession: client['lastSession'] ?? 'Never',
                ),
              );
            } catch (e) {
              print(
                'DEBUG TrainerDashboardController: Error processing client: $e',
              );
            }
          }

          // Fetch trainer schedule
          final schedule = await _trainerService.getTrainerSchedule(trainerId);
          trainerSchedule.value = schedule;
          print('DEBUG TrainerDashboardController: Trainer schedule loaded');

          // Fetch trainer metrics
          final metrics = await _trainerService.getTrainerMetrics(trainerId);
          trainerMetrics.value = metrics;
          print('DEBUG TrainerDashboardController: Trainer metrics loaded');

          // Update dashboard metrics from API data
          clientCount.value = metrics['clientCount'] ?? 0;
          averageRating.value = (metrics['averageRating'] ?? 0.0).toDouble();
          completedSessions.value = metrics['completedConsultations'] ?? 0;

          print(
            'DEBUG TrainerDashboardController: Dashboard metrics updated - Clients: ${clientCount.value}, Rating: ${averageRating.value}, Sessions: ${completedSessions.value}',
          );

          // Generate some sample weekly earnings data (not from API)
          _generateSampleEarnings();
        } catch (e, stackTrace) {
          print(
            'DEBUG TrainerDashboardController: Error fetching trainer data: $e',
          );
          print('Stack trace: $stackTrace');

          // Provide a more user-friendly error message
          String userMessage = 'Failed to load your data';

          if (e.toString().contains('timed out')) {
            userMessage =
                'Connection timed out. Please check your internet connection.';
          } else if (e.toString().contains('404')) {
            userMessage = 'Your profile data could not be found.';
          } else if (e.toString().contains('401') ||
              e.toString().contains('403')) {
            userMessage = 'You do not have permission to access this data.';
          }

          hasError.value = true;
          errorMessage.value = userMessage;
        }
      } else {
        print('DEBUG TrainerDashboardController: No user ID available');
        hasError.value = true;
        errorMessage.value = 'User not authenticated';
      }

      isLoading.value = false;
    } catch (e) {
      print('DEBUG TrainerDashboardController: Error in fetchTrainerData: $e');
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error loading dashboard data';
    }
  }

  // Helper method to get day of week
  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  // Generate sample weekly earnings data
  void _generateSampleEarnings() {
    // Just for demonstration - in a real app this would come from API
    weeklyEarnings.value = [120.0, 250.0, 200.0, 300.0, 150.0, 220.0, 180.0];
  }

  void navigateToClientDetails(String clientName) {
    // In a real app, you would navigate to client details
    Get.snackbar('Client Selected', 'Viewing $clientName\'s details');
  }

  void navigateToSchedule() {
    // Navigate to schedule screen
    Get.snackbar('Schedule', 'Viewing full schedule');
  }

  // Refresh dashboard data
  Future<void> refreshData() async {
    print('DEBUG TrainerDashboardController: Refreshing data');

    // Clear any previous error state
    hasError.value = false;
    errorMessage.value = '';

    await fetchTrainerData();
  }
}

class ClientMetric {
  final String name;
  final int progress;
  final String lastSession;

  ClientMetric({
    required this.name,
    required this.progress,
    required this.lastSession,
  });
}

class ScheduleItem {
  final String clientName;
  final String time;
  final String day;
  final String type;
  final String status;

  ScheduleItem({
    required this.clientName,
    required this.time,
    required this.day,
    required this.type,
    this.status = 'Scheduled',
  });
}
