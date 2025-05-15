import 'package:get/get.dart';

class ClientDashboardController extends GetxController {
  var fitnessScore = 82.5.obs;
  var fitnessScoreChange = (-12).obs;
  var suggestions = 8.obs;
  final List<double> weeklyScores = [50, 80, 60, 100, 70, 60, 50];
  final List<double> caloriesData = [8, 5, 10, 7, 12, 6, 9, 11];
  // Add more observable properties and business logic as needed
}
