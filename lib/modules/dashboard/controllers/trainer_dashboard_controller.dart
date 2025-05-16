import 'package:get/get.dart';

class TrainerDashboardController extends GetxController {
  // Observable properties
  final clientCount = 12.obs;
  final pendingAppointments = 5.obs;
  final completedSessions = 142.obs;
  final averageRating = 4.8.obs;

  // Client metrics
  final List<ClientMetric> clientMetrics =
      [
        ClientMetric(name: 'John Doe', progress: 80, lastSession: '2 days ago'),
        ClientMetric(
          name: 'Jane Smith',
          progress: 65,
          lastSession: 'Yesterday',
        ),
        ClientMetric(
          name: 'Mike Johnson',
          progress: 92,
          lastSession: '1 week ago',
        ),
        ClientMetric(
          name: 'Sarah Williams',
          progress: 45,
          lastSession: 'Today',
        ),
      ].obs;

  // Weekly schedule
  final weeklySchedule =
      <ScheduleItem>[
        ScheduleItem(
          clientName: 'John Doe',
          time: '9:00 AM',
          day: 'Monday',
          type: 'Strength Training',
        ),
        ScheduleItem(
          clientName: 'Jane Smith',
          time: '11:00 AM',
          day: 'Monday',
          type: 'Weight Loss',
        ),
        ScheduleItem(
          clientName: 'Mike Johnson',
          time: '2:00 PM',
          day: 'Tuesday',
          type: 'Muscle Building',
        ),
        ScheduleItem(
          clientName: 'Sarah Williams',
          time: '4:00 PM',
          day: 'Wednesday',
          type: 'Cardio',
        ),
      ].obs;
  // Weekly earnings data for chart
  final weeklyEarnings =
      <double>[120.0, 250.0, 200.0, 300.0, 150.0, 220.0, 180.0].obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, you would fetch data from API
  }

  void navigateToClientDetails(String clientName) {
    // In a real app, you would navigate to client details
    Get.snackbar('Client Selected', 'Viewing $clientName\'s details');
  }

  void navigateToSchedule() {
    // Navigate to schedule screen
    Get.snackbar('Schedule', 'Viewing full schedule');
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

  ScheduleItem({
    required this.clientName,
    required this.time,
    required this.day,
    required this.type,
  });
}
