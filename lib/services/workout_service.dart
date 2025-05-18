import 'dart:convert';
import 'package:gym_bite/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../models/workout_model.dart';

class WorkoutService {
  final String apiUrl = AppConstants.baseUrl;
  final String workoutEndpoint = AppConstants.workoutPlanEndpoint;
  // Get all workout plans
  Future<List<WorkoutPlanModel>> getAllWorkoutPlans() async {
    try {
      print(
        'DEBUG WorkoutService: Fetching all workout plans from $workoutEndpoint',
      );
      final response = await http
          .get(
            Uri.parse(workoutEndpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG WorkoutService: Get all workout plans - Status code: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('DEBUG WorkoutService: Received ${data.length} workout plans');
        return data.map((json) => WorkoutPlanModel.fromJson(json)).toList();
      } else {
        print(
          'DEBUG WorkoutService: Failed to load workout plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load workout plans. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG WorkoutService: Error fetching workout plans: $e');
      throw Exception('Error fetching workout plans: ${e.toString()}');
    }
  } // Get workout plans created by a specific trainer

  Future<List<WorkoutPlanModel>> getTrainerWorkoutPlans(int trainerId) async {
    try {
      print(
        'DEBUG WorkoutService: Fetching trainer workout plans for trainer ID: $trainerId',
      );
      // Using general endpoint and filtering by userId in the code
      final endpoint = workoutEndpoint;
      print('DEBUG WorkoutService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      print(
        'DEBUG WorkoutService: Get trainer workout plans - Status code: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG WorkoutService: Received ${data.length} total workout plans, filtering for trainer ID $trainerId',
        );

        // Filter workout plans by userId to get only those created by this trainer
        final trainerPlans =
            data
                .map((json) => WorkoutPlanModel.fromJson(json))
                .where((plan) => plan.userId == trainerId)
                .toList();

        print(
          'DEBUG WorkoutService: Found ${trainerPlans.length} workout plans for trainer ID $trainerId',
        );

        return trainerPlans;
      } else {
        print(
          'DEBUG WorkoutService: Failed to load trainer workout plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load trainer workout plans. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG WorkoutService: Error fetching trainer workout plans: $e');
      throw Exception('Error fetching trainer workout plans: ${e.toString()}');
    }
  } // Get workout plans assigned to a specific client

  Future<List<WorkoutPlanModel>> getClientWorkoutPlans(int clientId) async {
    try {
      print(
        'DEBUG WorkoutService: Fetching client workout plans for client ID: $clientId',
      );
      // Using general endpoint and filtering by userId in the code
      final endpoint = workoutEndpoint;
      print('DEBUG WorkoutService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      print(
        'DEBUG WorkoutService: Get client workout plans - Status code: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG WorkoutService: Received ${data.length} total workout plans, filtering for client ID $clientId',
        );

        // Filter workout plans by userId to get only those assigned to this client
        // For now, since we don't have a proper assignment mechanism in the API,
        // we'll show plans created by this client
        final clientPlans =
            data
                .map((json) => WorkoutPlanModel.fromJson(json))
                .where((plan) => plan.userId == clientId)
                .toList();

        print(
          'DEBUG WorkoutService: Found ${clientPlans.length} workout plans for client ID $clientId',
        );

        return clientPlans;
      } else {
        print(
          'DEBUG WorkoutService: Failed to load client workout plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load client workout plans. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG WorkoutService: Error fetching client workout plans: $e');
      throw Exception('Error fetching client workout plans: ${e.toString()}');
    }
  }

  // Create a new workout plan (trainer only)
  Future<WorkoutPlanModel> createWorkoutPlan(
    WorkoutPlanModel workoutPlan,
  ) async {
    try {
      print(
        'DEBUG WorkoutService: Creating workout plan with API endpoint: $workoutEndpoint',
      );
      print(
        'DEBUG WorkoutService: Request body: ${json.encode(workoutPlan.toJson())}',
      );

      final response = await http
          .post(
            Uri.parse(workoutEndpoint),
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
      print(
        'DEBUG WorkoutService: Updating workout plan with ID: ${workoutPlan.id}',
      );
      final endpoint = '$workoutEndpoint/${workoutPlan.id}';
      print('DEBUG WorkoutService: Using endpoint: $endpoint');

      final response = await http
          .put(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(workoutPlan.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG WorkoutService: Update workout plan response - Status: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        print('DEBUG WorkoutService: Workout plan updated successfully');
        return WorkoutPlanModel.fromJson(json.decode(response.body));
      } else {
        print(
          'DEBUG WorkoutService: Failed to update workout plan - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to update workout plan. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG WorkoutService: Error updating workout plan: $e');
      throw Exception('Error updating workout plan: ${e.toString()}');
    }
  }

  // Delete a workout plan (trainer only)
  Future<bool> deleteWorkoutPlan(int workoutPlanId) async {
    try {
      print(
        'DEBUG WorkoutService: Deleting workout plan with ID: $workoutPlanId',
      );
      final endpoint = '$workoutEndpoint/$workoutPlanId';
      print('DEBUG WorkoutService: Using endpoint: $endpoint');

      final response = await http
          .delete(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG WorkoutService: Delete workout plan response - Status: ${response.statusCode}',
      );
      final success = response.statusCode == 204 || response.statusCode == 200;
      print(
        'DEBUG WorkoutService: Delete operation ${success ? "succeeded" : "failed"}',
      );
      return success;
    } catch (e) {
      print('DEBUG WorkoutService: Error deleting workout plan: $e');
      throw Exception('Error deleting workout plan: ${e.toString()}');
    }
  }

  // Assign workout plan to client (trainer only)
  Future<bool> assignWorkoutPlanToClient(
    int workoutPlanId,
    int clientId,
  ) async {
    try {
      print(
        'DEBUG WorkoutService: Assigning workout plan ID: $workoutPlanId to client ID: $clientId',
      );
      final endpoint = '$workoutEndpoint/$workoutPlanId/assign/$clientId';
      print('DEBUG WorkoutService: Using endpoint: $endpoint');

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG WorkoutService: Assign workout plan response - Status: ${response.statusCode}',
      );
      final success = response.statusCode == 200;
      print(
        'DEBUG WorkoutService: Assign operation ${success ? "succeeded" : "failed"}',
      );

      if (!success) {
        print('DEBUG WorkoutService: Error response body: ${response.body}');
      }

      return success;
    } catch (e) {
      print('DEBUG WorkoutService: Error assigning workout plan: $e');
      throw Exception('Error assigning workout plan: ${e.toString()}');
    }
  }

  // Create a new workout plan using structured data for API endpoint
  Future<WorkoutPlanModel?> createNewWorkoutPlan(
    Map<String, dynamic> workoutPlanData,
  ) async {
    try {
      print(
        'DEBUG WorkoutService: Creating workout plan with data: $workoutPlanData',
      );
      print('DEBUG WorkoutService: Using endpoint: $workoutEndpoint');

      final response = await http
          .post(
            Uri.parse(workoutEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(workoutPlanData),
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG WorkoutService: Create workout plan response - Status: ${response.statusCode}',
      );
      print('DEBUG WorkoutService: Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(
          'DEBUG WorkoutService: Successfully created workout plan: $responseData',
        );
        return WorkoutPlanModel.fromJson(responseData);
      } else {
        print(
          'DEBUG WorkoutService: Failed to create workout plan. Status: ${response.statusCode}, Response: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Exception caught in WorkoutService.createNewWorkoutPlan: $e');
      return null;
    }
  }
}
