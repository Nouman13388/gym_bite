// import 'package:flutter/material.dart';
// import 'package:gym_bite/core/constants/app_constants.dart';
// import 'package:http/http.dart' as http;

// class ProgressService {
//   final String progerssEndPoint = AppConstants.progressEndpoint;
//   // Add methods to interact with the progress endpoint
//   // For example, you can create, update, or delete progress records
//   // Example method to create a new progress record
//   Future<void> getProgressByClientId(int clientId) async {
//     // Implement the logic to fetch progress records for a specific client
//     // You can use http package to make API calls
//     final response = await http.get(
//       Uri.parse('$progerssEndPoint/client/$clientId'),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       // Parse the response and return the progress records
//       // For example, you can use json.decode to parse the response
//       // and return a list of progress records
//       final List<dynamic> data = json.decode(response.body);
//       // Assuming you have a ProgressModel class to parse the data
//       // return data.map((json) => ProgressModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load progress records');
//     }

//   }
// }
