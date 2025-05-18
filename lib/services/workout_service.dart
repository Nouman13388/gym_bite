import 'dart:convert';
import 'package:gym_bite/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../models/workout_model.dart';

class WorkoutService {
  final String apiUrl = AppConstants.baseUrl;

  // Get all workout plans
  Future<List<WorkoutPlanModel>> getAllWorkoutPlans() async {
    try {
      final response = await http
          .get(
            Uri.parse('$apiUrl/workout-plans'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workout plans');
      }
    } catch (e) {
      throw Exception('Error fetching workout plans: ${e.toString()}');
    }
  }

  // Get workout plans created by a specific trainer
  Future<List<WorkoutPlanModel>> getTrainerWorkoutPlans(int trainerId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$apiUrl/workout-plans/trainer/$trainerId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trainer workout plans');
      }
    } catch (e) {
      throw Exception('Error fetching trainer workout plans: ${e.toString()}');
    }
  }

  // Get workout plans assigned to a specific client
  Future<List<WorkoutPlanModel>> getClientWorkoutPlans(int clientId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$apiUrl/workout-plans/client/$clientId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load client workout plans');
      }
    } catch (e) {
      throw Exception('Error fetching client workout plans: ${e.toString()}');
    }
  }

  // Create a new workout plan (trainer only)
  Future<WorkoutPlanModel> createWorkoutPlan(
    WorkoutPlanModel workoutPlan,
  ) async {
    try {
      print(
        'DEBUG WorkoutService: Creating workout plan with API endpoint: $apiUrl/workout-plans',
      );
      print(
        'DEBUG WorkoutService: Request body: ${json.encode(workoutPlan.toJson())}',
      );

      final response = await http
          .post(
            Uri.parse('$apiUrl/workout-plans'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(workoutPlan.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('DEBUG WorkoutService: Response status: ${response.statusCode}');
      print('DEBUG WorkoutService: Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkoutPlanModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to create workout plan. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('DEBUG WorkoutService: Error creating workout plan: $e');
      throw Exception('Error creating workout plan: ${e.toString()}');
    }
  }

  // Update an existing workout plan (trainer only)
  Future<WorkoutPlanModel> updateWorkoutPlan(
    WorkoutPlanModel workoutPlan,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$apiUrl/workout-plans/${workoutPlan.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(workoutPlan),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return WorkoutPlanModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update workout plan');
      }
    } catch (e) {
      throw Exception('Error updating workout plan: ${e.toString()}');
    }
  }

  // Delete a workout plan (trainer only)
  Future<bool> deleteWorkoutPlan(int workoutPlanId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$apiUrl/workout-plans/$workoutPlanId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting workout plan: ${e.toString()}');
    }
  }

  // Assign workout plan to client (trainer only)
  Future<bool> assignWorkoutPlanToClient(
    int workoutPlanId,
    int clientId,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$apiUrl/workout-plans/$workoutPlanId/assign/$clientId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error assigning workout plan: ${e.toString()}');
    }
  }

  // Create a new workout plan using structured data for API endpoint
  Future<WorkoutPlanModel?> createNewWorkoutPlan(
    Map<String, dynamic> workoutPlanData,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$apiUrl/workout-plans'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(workoutPlanData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return WorkoutPlanModel.fromJson(responseData);
      } else {
        print(
          'Failed to create workout plan. Status: ${response.statusCode}, Response: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Exception caught in WorkoutService.createNewWorkoutPlan: $e');
      return null;
    }
  }
}
