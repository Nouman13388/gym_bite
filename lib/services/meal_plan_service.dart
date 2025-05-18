import 'dart:convert';
import 'package:gym_bite/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../models/meal_plan_model.dart';

class MealPlanService {
  final String apiUrl = AppConstants.baseUrl;

  // Get all meal plans
  Future<List<MealPlanModel>> getAllMealPlans() async {
    try {
      final response = await http
          .get(
            Uri.parse('$apiUrl/meal-plans'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MealPlanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meal plans');
      }
    } catch (e) {
      throw Exception('Error fetching meal plans: ${e.toString()}');
    }
  }

  // Get meal plans created by a specific trainer
  Future<List<MealPlanModel>> getTrainerMealPlans(int trainerId) async {
    try {
      print(
        'DEBUG MealPlanService: Fetching trainer meal plans for trainer ID: $trainerId',
      );
      // Using general endpoint and filtering by trainerId in the code
      final endpoint = '$apiUrl/meal-plans';
      print('DEBUG MealPlanService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG MealPlanService: Get trainer meal plans - Status code: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG MealPlanService: Received ${data.length} total meal plans, filtering for trainer ID $trainerId',
        );

        // Filter meal plans by trainerId to get only those created by this trainer
        final trainerPlans =
            data
                .map((json) => MealPlanModel.fromJson(json))
                .where((plan) => plan.trainerId == trainerId)
                .toList();

        print(
          'DEBUG MealPlanService: Found ${trainerPlans.length} meal plans for trainer ID $trainerId',
        );

        return trainerPlans;
      } else {
        print(
          'DEBUG MealPlanService: Failed to load trainer meal plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception('Failed to load trainer meal plans');
      }
    } catch (e) {
      print('DEBUG MealPlanService: Error fetching trainer meal plans: $e');
      throw Exception('Error fetching trainer meal plans: ${e.toString()}');
    }
  } // Get meal plans assigned to a specific client

  Future<List<MealPlanModel>> getClientMealPlans(int clientId) async {
    try {
      print(
        'DEBUG MealPlanService: Fetching client meal plans for client ID: $clientId',
      );
      // Using general endpoint and filtering by assigned clients in the code
      final endpoint = '$apiUrl/meal-plans';
      print('DEBUG MealPlanService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG MealPlanService: Get client meal plans - Status code: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG MealPlanService: Received ${data.length} total meal plans',
        );

        // In a real app with proper client-trainer assignments,
        // we would filter for plans assigned to this client
        // For development purposes, we'll show all meal plans
        final plans = data.map((json) => MealPlanModel.fromJson(json)).toList();

        print(
          'DEBUG MealPlanService: Returning ${plans.length} meal plans for client ID $clientId',
        );

        return plans;
      } else {
        print(
          'DEBUG MealPlanService: Failed to load client meal plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception('Failed to load client meal plans');
      }
    } catch (e) {
      print('DEBUG MealPlanService: Error fetching client meal plans: $e');
      throw Exception('Error fetching client meal plans: ${e.toString()}');
    }
  }

  // Create a new meal plan (trainer only)
  Future<MealPlanModel> createMealPlan(MealPlanModel mealPlan) async {
    try {
      final response = await http
          .post(
            Uri.parse('$apiUrl/meal-plans'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(mealPlan.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return MealPlanModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create meal plan');
      }
    } catch (e) {
      throw Exception('Error creating meal plan: ${e.toString()}');
    }
  }

  // Update an existing meal plan (trainer only)
  Future<MealPlanModel> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      final response = await http
          .put(
            Uri.parse('$apiUrl/meal-plans/${mealPlan.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(mealPlan.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return MealPlanModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update meal plan');
      }
    } catch (e) {
      throw Exception('Error updating meal plan: ${e.toString()}');
    }
  }

  // Delete a meal plan (trainer only)
  Future<bool> deleteMealPlan(int mealPlanId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$apiUrl/meal-plans/$mealPlanId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting meal plan: ${e.toString()}');
    }
  }

  // Assign meal plan to client (trainer only)
  Future<bool> assignMealPlanToClient(int mealPlanId, int clientId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$apiUrl/meal-plans/$mealPlanId/assign/$clientId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error assigning meal plan: ${e.toString()}');
    }
  }

  // Create a new meal plan using the structured data for API endpoint
  Future<MealPlanModel?> createNewMealPlan(
    Map<String, dynamic> mealPlanData,
  ) async {
    try {
      print('MealPlanService - createNewMealPlan');
      print('Original meal plan data received: $mealPlanData');
      print(
        'User ID being sent: ${mealPlanData['userId']}',
      ); // Ensure userId is not 0 or null before sending to server
      if (mealPlanData['userId'] == 0 || mealPlanData['userId'] == null) {
        print('ERROR: User ID is 0 or null. This will cause a server error.');

        // Attempt to provide more context about the issue
        print('Auth state investigation:');
        print(
          '- Does mealPlanData contain userId? ${mealPlanData.containsKey('userId')}',
        );
        print('- What is the raw value of userId? ${mealPlanData['userId']}');
        print('- Is userId of type int? ${mealPlanData['userId'] is int}');

        // You could choose to throw an exception here instead of proceeding with the request
        // throw Exception('Cannot create meal plan: Invalid user ID');
      }

      print('Final data being sent to API: ${json.encode(mealPlanData)}');

      final response = await http
          .post(
            Uri.parse('$apiUrl/meal-plans'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(mealPlanData),
          )
          .timeout(const Duration(seconds: 10));

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Successfully created meal plan. Response data: $responseData');

        // Convert the API response to a MealPlanModel
        return MealPlanModel.fromJson(responseData);
      } else {
        print(
          'Failed to create meal plan. Status: ${response.statusCode}, Response: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Exception caught in MealPlanService.createNewMealPlan: $e');
      return null;
    }
  }
}
