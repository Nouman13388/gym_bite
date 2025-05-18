import 'package:get/get.dart';
import '../../../services/client_service.dart';
import '../../../services/auth_service.dart';

class ClientDashboardController extends GetxController {
  final ClientService _clientService = ClientService();
  final AuthService _authService = Get.find<AuthService>();

  // Dashboard metrics
  var fitnessScore = 82.5.obs;
  var fitnessScoreChange = (-12).obs;
  var suggestions = 8.obs;

  // Chart data
  final List<double> weeklyScores = [50, 80, 60, 100, 70, 60, 50];
  final List<double> caloriesData = [8, 5, 10, 7, 12, 6, 9, 11];

  // Client data from API
  final clientProfile = Rx<Map<String, dynamic>>({});
  final clientPlans = Rx<Map<String, dynamic>>({});
  final clientProgress = Rx<List<dynamic>>([]);

  // Observable state
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Client info
  final weight = ''.obs;
  final height = ''.obs;
  final bmi = ''.obs;
  final fitnessGoals = ''.obs;
  final dietaryPreferences = ''.obs;
  final nextAppointment = Rx<Map<String, dynamic>>({});
  final nextConsultation = Rx<Map<String, dynamic>>({});
  final latestProgress = Rx<Map<String, dynamic>>({});

  // Workout and meal plans
  final workoutPlans = <dynamic>[].obs;
  final mealPlans = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClientData();
  }

  Future<void> fetchClientData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      // Check if user is logged in and has an ID
      final user = _authService.userModel;
      if (user != null && user.id > 0) {
        print('DEBUG ClientDashboardController: User ID found: ${user.id}');

        // Find client ID associated with the user
        int? clientId;
        try {
          clientId = await _clientService.getClientIdByUserId(user.id);

          if (clientId == null) {
            // Fallback to hardcoded ID only if needed (development/testing)
            clientId = 7; // Temporary fallback - remove in production
            print(
              'DEBUG ClientDashboardController: No client ID found for user, using fallback ID: $clientId',
            );
          } else {
            print(
              'DEBUG ClientDashboardController: Found client ID: $clientId for user ID: ${user.id}',
            );
          }
        } catch (e) {
          // If API endpoint doesn't exist yet, fallback to hardcoded ID
          clientId = 7; // Temporary fallback - remove in production
          print(
            'DEBUG ClientDashboardController: Error finding client ID, using fallback: $clientId. Error: $e',
          );
        }

        try {
          // Fetch client complete profile
          final profile = await _clientService.getClientCompleteProfile(
            clientId,
          );
          clientProfile.value = profile;
          print('DEBUG ClientDashboardController: Client profile loaded');
          // Extract basic client info
          weight.value = profile['weight']?.toString() ?? '';
          height.value = profile['height']?.toString() ?? '';
          bmi.value = profile['BMI']?.toString() ?? '';
          fitnessGoals.value = profile['fitnessGoals']?.toString() ?? '';
          dietaryPreferences.value =
              profile['dietaryPreferences']?.toString() ?? '';

          print(
            'DEBUG ClientDashboardController: Profile data extracted - Weight: ${weight.value}, Height: ${height.value}, BMI: ${bmi.value}',
          );

          // Get latest appointment if available
          if (profile['appointments'] != null &&
              profile['appointments'] is List &&
              profile['appointments'].isNotEmpty) {
            nextAppointment.value = Map<String, dynamic>.from(
              profile['appointments'][0],
            );
            print(
              'DEBUG ClientDashboardController: Next appointment found - Date: ${nextAppointment.value['date']}',
            );
          } else {
            print('DEBUG ClientDashboardController: No appointments found');
          }

          // Get latest consultation if available
          if (profile['consultations'] != null &&
              profile['consultations'] is List &&
              profile['consultations'].isNotEmpty) {
            nextConsultation.value = Map<String, dynamic>.from(
              profile['consultations'][0],
            );
            print(
              'DEBUG ClientDashboardController: Next consultation found - Date: ${nextConsultation.value['date']}',
            );
          } else {
            print('DEBUG ClientDashboardController: No consultations found');
          }

          // Get latest progress if available
          if (profile['progress'] != null &&
              profile['progress'] is List &&
              profile['progress'].isNotEmpty) {
            latestProgress.value = Map<String, dynamic>.from(
              profile['progress'][0],
            );
            print('DEBUG ClientDashboardController: Latest progress found');

            // Update fitness score based on BMI if available
            if (latestProgress.value['BMI'] != null) {
              final bmiValue =
                  double.tryParse(latestProgress.value['BMI'].toString()) ?? 0;
              if (bmiValue > 0) {
                // Calculate fitness score based on BMI
                fitnessScore.value = calculateFitnessScoreFromBMI(bmiValue);
                print(
                  'DEBUG ClientDashboardController: Updated fitness score to ${fitnessScore.value} based on BMI $bmiValue',
                );
              }
            }
          } else {
            print('DEBUG ClientDashboardController: No progress records found');
          }

          // Fetch client plans
          final plans = await _clientService.getClientPlans(clientId);
          clientPlans.value = plans;
          print(
            'DEBUG ClientDashboardController: Client plans loaded',
          ); // Extract workout and meal plans
          if (plans['workoutPlans'] != null) {
            workoutPlans.value = plans['workoutPlans'];
            print(
              'DEBUG ClientDashboardController: ${workoutPlans.length} workout plans loaded',
            );
          } else {
            workoutPlans.clear();
            print(
              'DEBUG ClientDashboardController: No workout plans available',
            );
          }

          if (plans['mealPlans'] != null) {
            mealPlans.value = plans['mealPlans'];
            print(
              'DEBUG ClientDashboardController: ${mealPlans.length} meal plans loaded',
            );
          } else {
            mealPlans.clear();
            print('DEBUG ClientDashboardController: No meal plans available');
          }

          // Fetch client progress data
          final progress = await _clientService.getClientProgress(clientId);
          clientProgress.value = progress;
          print(
            'DEBUG ClientDashboardController: Client progress loaded',
          ); // Update chart data based on progress if available
          if (progress.isNotEmpty) {
            updateChartDataFromProgress(progress);
          } else {
            print(
              'DEBUG ClientDashboardController: No progress data to update chart',
            );
          }
        } catch (e, stackTrace) {
          print(
            'DEBUG ClientDashboardController: Error fetching client data: $e',
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
        print('DEBUG ClientDashboardController: No user ID available');
        hasError.value = true;
        errorMessage.value = 'User not authenticated';
      }

      isLoading.value = false;
    } catch (e) {
      print('DEBUG ClientDashboardController: Error in fetchClientData: $e');
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error loading dashboard data';
    }
  }

  // Calculate a fitness score based on BMI
  // This is just an example calculation - adjust as needed
  double calculateFitnessScoreFromBMI(double bmi) {
    if (bmi < 16) return 60; // Severely underweight
    if (bmi < 18.5) return 75; // Underweight
    if (bmi < 25) return 90; // Normal weight
    if (bmi < 30) return 75; // Overweight
    if (bmi < 35) return 60; // Obese Class I
    if (bmi < 40) return 45; // Obese Class II
    return 30; // Obese Class III
  }

  // Update chart data from progress records
  void updateChartDataFromProgress(List<dynamic> progressData) {
    try {
      print(
        'DEBUG ClientDashboardController: Updating chart data from ${progressData.length} progress records',
      );

      // Sort the progress data by date (most recent first)
      progressData.sort((a, b) {
        try {
          final dateA =
              a['date'] != null
                  ? DateTime.parse(a['date'].toString())
                  : DateTime(1970);
          final dateB =
              b['date'] != null
                  ? DateTime.parse(b['date'].toString())
                  : DateTime(1970);
          return dateB.compareTo(dateA); // Most recent first
        } catch (e) {
          print('DEBUG ClientDashboardController: Error sorting dates: $e');
          return 0; // Keep original order if dates can't be parsed
        }
      });

      if (progressData.length >= 1) {
        List<double> newScores = [];
        for (var progress in progressData) {
          final bmiValue =
              double.tryParse(progress['BMI']?.toString() ?? '') ?? 0;
          if (bmiValue > 0) {
            // Convert BMI to a score between 0-100
            final score = calculateFitnessScoreFromBMI(bmiValue);
            newScores.add(score);
            print(
              'DEBUG ClientDashboardController: Added score $score from BMI $bmiValue',
            );
          }
        }

        // If we have new scores, update the chart data
        if (newScores.isNotEmpty) {
          // Calculate fitness score change if we have multiple records
          if (newScores.length >= 2) {
            final currentScore = newScores.first;
            final previousScore = newScores[1];
            final change =
                ((currentScore - previousScore) / previousScore * 100).round();
            fitnessScoreChange.value = change;
            print(
              'DEBUG ClientDashboardController: Updated fitness score change to ${fitnessScoreChange.value}%',
            );
          }

          // Pad with dummy data if less than 7 points
          while (newScores.length < 7) {
            newScores.add(newScores.isNotEmpty ? newScores.last : 50);
          }
          // Take last 7 points if more than 7
          if (newScores.length > 7) {
            newScores = newScores.sublist(0, 7); // Take most recent 7
          }
          // Update weekly scores
          weeklyScores.clear();
          weeklyScores.addAll(newScores);
          print(
            'DEBUG ClientDashboardController: Updated weekly scores chart data',
          );
        }
      }
    } catch (e) {
      print('DEBUG ClientDashboardController: Error updating chart data: $e');
    }
  }

  // Refresh dashboard data
  Future<void> refreshData() async {
    print('DEBUG ClientDashboardController: Refreshing data');

    // Clear any previous error state
    hasError.value = false;
    errorMessage.value = '';

    // No need to set loading to true if we're using RefreshIndicator
    // as it already shows its own loading indicator

    await fetchClientData();

    // Show a success message (optional)
    // You could use Get.snackbar() to show a success message when refresh is complete
  }
}
