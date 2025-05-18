import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/workout_model.dart';
import '../models/meal_plan_model.dart';

class ClientService {
  final String apiUrl = AppConstants.baseUrl;
  final String clientEndpoint = AppConstants.clientEndpoint;

  // New method: Get client ID by user ID
  Future<int?> getClientIdByUserId(int userId) async {
    try {
      print('DEBUG ClientService: Finding client ID for user ID: $userId');
      final endpoint = '${AppConstants.clientEndpoint}/user/$userId';
      print('DEBUG ClientService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG ClientService: Found client data: $data');

        if (data != null && data['id'] != null) {
          return data['id'];
        } else {
          print('DEBUG ClientService: Client ID not found in response');
          return null;
        }
      } else if (response.statusCode == 404) {
        print(
          'DEBUG ClientService: No client record found for user ID: $userId',
        );
        return null;
      } else {
        print(
          'DEBUG ClientService: Error finding client - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to find client. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG ClientService: Error in getClientIdByUserId: $e');
      throw Exception('Error finding client ID: $e');
    }
  }

  // Get client complete profile information including consultations, appointments, and progress
  Future<Map<String, dynamic>> getClientCompleteProfile(int clientId) async {
    try {
      print(
        'DEBUG ClientService: Fetching client complete profile for ID: $clientId',
      );
      final endpoint = '$clientEndpoint/$clientId/complete';
      print('DEBUG ClientService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG ClientService: Get client profile - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG ClientService: Client profile data received successfully');
        return data;
      } else {
        print(
          'DEBUG ClientService: Failed to load client profile - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load client profile. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG ClientService: Error fetching client profile: $e');
      throw Exception('Error fetching client profile: ${e.toString()}');
    }
  }

  // Get client plans (workout plans and meal plans)
  Future<Map<String, dynamic>> getClientPlans(int clientId) async {
    try {
      print('DEBUG ClientService: Fetching client plans for ID: $clientId');
      final endpoint = '$clientEndpoint/$clientId/plans';
      print('DEBUG ClientService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG ClientService: Get client plans - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG ClientService: Client plans data received successfully');
        return data;
      } else {
        print(
          'DEBUG ClientService: Failed to load client plans - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load client plans. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG ClientService: Error fetching client plans: $e');
      throw Exception('Error fetching client plans: ${e.toString()}');
    }
  }

  // Get client progress
  Future<List<dynamic>> getClientProgress(int clientId) async {
    try {
      print('DEBUG ClientService: Fetching client progress for ID: $clientId');
      final endpoint = '$clientEndpoint/$clientId/progress';
      print('DEBUG ClientService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG ClientService: Get client progress - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG ClientService: Client progress data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG ClientService: Failed to load client progress - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load client progress. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG ClientService: Error fetching client progress: $e');
      throw Exception('Error fetching client progress: ${e.toString()}');
    }
  }

  // Get client activities
  Future<List<dynamic>> getClientActivities(int clientId) async {
    try {
      print(
        'DEBUG ClientService: Fetching client activities for ID: $clientId',
      );
      final endpoint = '$clientEndpoint/$clientId/activities';
      print('DEBUG ClientService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG ClientService: Get client activities - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG ClientService: Client activities data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG ClientService: Failed to load client activities - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load client activities. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG ClientService: Error fetching client activities: $e');
      throw Exception('Error fetching client activities: ${e.toString()}');
    }
  }
}
