import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'core/constants/app_constants.dart';

Future<void> main() async {
  // Create Users
  final user1RequestBody = {
    'firebaseUid': 'firebase-uid-trainer',
    'name': 'John Trainer',
    'email': 'john.trainer@example.com',
    'role': 'TRAINER',
    'password': 'password123', // Updated password to meet minimum length
  };
  final user1Response = await http.post(
    Uri.parse(AppConstants.userEndpoint),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user1RequestBody),
  );
  log('User 1 Request Body: $user1RequestBody');
  log('User 1 Response: ${user1Response.body}');

  final user2RequestBody = {
    'firebaseUid': 'firebase-uid-client',
    'name': 'Jane Client',
    'email': 'jane.client@example.com',
    'role': 'CLIENT',
    'password': 'password123', // Updated password to meet minimum length
  };
  final user2Response = await http.post(
    Uri.parse(AppConstants.userEndpoint),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user2RequestBody),
  );
  log('User 2 Request Body: $user2RequestBody');
  log('User 2 Response: ${user2Response.body}');

  if (user1Response.statusCode == 201 && user2Response.statusCode == 201) {
    final trainerUser = jsonDecode(user1Response.body);
    final clientUser = jsonDecode(user2Response.body);

    print('Trainer User Created: $trainerUser');
    print('Client User Created: $clientUser');

    // Create Trainer
    final trainerResponse = await http.post(
      Uri.parse(AppConstants.trainerEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': trainerUser['id'],
        'specialty': 'Weight Training',
        'experienceYears': 5,
      }),
    );

    // Create Client
    final clientResponse = await http.post(
      Uri.parse(AppConstants.clientEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': clientUser['id'],
        'weight': 70.0,
        'height': 175.0,
        'BMI': 22.9,
        'fitnessGoals': 'Build muscle',
        'dietaryPreferences': 'High protein',
      }),
    );

    if (trainerResponse.statusCode == 201 && clientResponse.statusCode == 201) {
      print('Trainer Created: ${jsonDecode(trainerResponse.body)}');
      print('Client Created: ${jsonDecode(clientResponse.body)}');

      // Populate Workout Plans
      final workoutPlanResponse = await http.post(
        Uri.parse(AppConstants.workoutPlanEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': clientUser['id'],
          'name': 'Strength Training',
          'exercises': 'Bench Press, Squats, Deadlifts',
          'sets': 3,
          'reps': 10,
        }),
      );

      // Populate Meal Plans
      final mealPlanResponse = await http.post(
        Uri.parse(AppConstants.mealPlanEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': clientUser['id'],
          'name': 'High Protein Diet',
          'description': 'Meal plan for muscle gain',
          'calories': 2500,
          'protein': 180.0,
          'fat': 80.0,
          'carbs': 250.0,
        }),
      );

      if (workoutPlanResponse.statusCode == 201 &&
          mealPlanResponse.statusCode == 201) {
        print('Workout Plan Created: ${jsonDecode(workoutPlanResponse.body)}');
        print('Meal Plan Created: ${jsonDecode(mealPlanResponse.body)}');
      } else {
        print('Failed to create workout or meal plans.');
      }
    } else {
      print('Failed to create trainer or client.');
    }
  } else {
    print('Failed to create users.');
    print('User 1 Status Code: ${user1Response.statusCode}');
    print('User 1 Response: ${user1Response.body}');
    print('User 2 Status Code: ${user2Response.statusCode}');
    print('User 2 Response: ${user2Response.body}');
  }
}
