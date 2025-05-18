import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class UserService {
  Future<UserModel?> getUserByFirebaseUid(String firebaseUid) async {
    try {
      print('UserService - Fetching user by Firebase UID: $firebaseUid');
      final response = await http.get(
        Uri.parse('${AppConstants.userEndpoint}?firebaseUid=$firebaseUid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        if (users.isEmpty) {
          print('UserService - No users returned from API');
          return null;
        }

        // Find the user with matching Firebase UID
        final userData = users.firstWhere(
          (user) => user['firebaseUid'] == firebaseUid,
          orElse: () => null,
        );

        if (userData != null) {
          print('UserService - Found user data: $userData');
          return UserModel.fromJson(userData);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user by Firebase UID: $e');
      rethrow;
    }
  }

  Future<UserModel?> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.userEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
}
