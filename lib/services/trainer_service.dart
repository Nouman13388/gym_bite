import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class TrainerService {
  final String apiUrl = AppConstants.baseUrl;
  final String trainerEndpoint = AppConstants.trainerEndpoint;

  // New method: Get trainer ID by user ID
  Future<int?> getTrainerIdByUserId(int userId) async {
    try {
      print('DEBUG TrainerService: Finding trainer ID for user ID: $userId');
      final endpoint = '${AppConstants.trainerEndpoint}/user/$userId';
      print('DEBUG TrainerService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG TrainerService: Found trainer data: $data');

        if (data != null && data['id'] != null) {
          return data['id'];
        } else {
          print('DEBUG TrainerService: Trainer ID not found in response');
          return null;
        }
      } else if (response.statusCode == 404) {
        print(
          'DEBUG TrainerService: No trainer record found for user ID: $userId',
        );
        return null;
      } else {
        print(
          'DEBUG TrainerService: Error finding trainer - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to find trainer. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG TrainerService: Error in getTrainerIdByUserId: $e');
      throw Exception('Error finding trainer ID: $e');
    }
  }

  // Get trainer complete profile information including consultations, appointments, and feedbacks
  Future<Map<String, dynamic>> getTrainerCompleteProfile(int trainerId) async {
    try {
      print(
        'DEBUG TrainerService: Fetching trainer complete profile for ID: $trainerId',
      );
      final endpoint = '$trainerEndpoint/$trainerId/complete';
      print('DEBUG TrainerService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG TrainerService: Get trainer profile - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
          'DEBUG TrainerService: Trainer profile data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG TrainerService: Failed to load trainer profile - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load trainer profile. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG TrainerService: Error fetching trainer profile: $e');
      throw Exception('Error fetching trainer profile: ${e.toString()}');
    }
  }

  // Get trainer's clients
  Future<List<dynamic>> getTrainerClients(int trainerId) async {
    try {
      print(
        'DEBUG TrainerService: Fetching trainer clients for ID: $trainerId',
      );
      final endpoint = '$trainerEndpoint/$trainerId/clients';
      print('DEBUG TrainerService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG TrainerService: Get trainer clients - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(
          'DEBUG TrainerService: Trainer clients data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG TrainerService: Failed to load trainer clients - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load trainer clients. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG TrainerService: Error fetching trainer clients: $e');
      throw Exception('Error fetching trainer clients: ${e.toString()}');
    }
  }

  // Get trainer schedule (consultations and appointments)
  Future<Map<String, dynamic>> getTrainerSchedule(int trainerId) async {
    try {
      print(
        'DEBUG TrainerService: Fetching trainer schedule for ID: $trainerId',
      );
      final endpoint = '$trainerEndpoint/$trainerId/schedule';
      print('DEBUG TrainerService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG TrainerService: Get trainer schedule - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(
          'DEBUG TrainerService: Trainer schedule data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG TrainerService: Failed to load trainer schedule - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load trainer schedule. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG TrainerService: Error fetching trainer schedule: $e');
      throw Exception('Error fetching trainer schedule: ${e.toString()}');
    }
  }

  // Get trainer metrics (client count, average rating, etc.)
  Future<Map<String, dynamic>> getTrainerMetrics(int trainerId) async {
    try {
      print(
        'DEBUG TrainerService: Fetching trainer metrics for ID: $trainerId',
      );
      final endpoint = '$trainerEndpoint/$trainerId/metrics';
      print('DEBUG TrainerService: Using endpoint: $endpoint');

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print(
        'DEBUG TrainerService: Get trainer metrics - Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(
          'DEBUG TrainerService: Trainer metrics data received successfully',
        );
        return data;
      } else {
        print(
          'DEBUG TrainerService: Failed to load trainer metrics - Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to load trainer metrics. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG TrainerService: Error fetching trainer metrics: $e');
      throw Exception('Error fetching trainer metrics: ${e.toString()}');
    }
  }
}
