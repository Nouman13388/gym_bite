import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import 'user_service.dart';
import 'dart:async';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final UserService _userService = UserService();

  User? get user => _firebaseUser.value;
  UserModel? get userModel => _userModel.value;

  Future<AuthService> init() async {
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _handleAuthChanged);
    return this;
  }

  void _handleAuthChanged(User? user) {
    if (user == null) {
      _userModel.value = null;
    } else {
      // Only fetch user data if we don't already have it or if it's a different user
      if (_userModel.value == null ||
          _userModel.value?.firebaseUid != user.uid) {
        _fetchUserData(user.uid);
      }
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      // Fetch user data from the API using the Firebase UID
      print('Fetching user data for Firebase UID: $uid');
      final response = await http
          .get(Uri.parse('${AppConstants.userEndpoint}?firebaseUid=$uid'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => throw TimeoutException('Network request timed out'),
          );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        if (users.isEmpty) {
          print('API returned empty user list for Firebase UID: $uid');
          return;
        }

        final userData = users.firstWhere(
          (user) => user['firebaseUid'] == uid,
          orElse: () => null,
        );
        if (userData != null) {
          print('User data found: $userData');
          _userModel.value = UserModel.fromJson(userData);
          print('Updated _userModel: ${_userModel.value?.toJson()}');
        } else {
          print('No user found for the given Firebase UID: $uid');
        }
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      // Step 1: Create user in Firebase
      final firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Send user data to backend
      final userData = {
        'firebaseUid': firebaseUser.user?.uid,
        'email': email,
        'name': name,
        'role': role,
      };
      final backendUser = await _userService.createUser(userData);

      if (backendUser != null) {
        _userModel.value = backendUser;
      }

      return firebaseUser;
    } catch (e) {
      print('Error during user creation: $e');
      rethrow;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('Attempting login for email: $email');
      // Step 1: Sign in with Firebase
      final firebaseUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Firebase login successful for user: ${firebaseUser.user?.uid}');

      // Step 2: Fetch user data from backend
      final backendUser = await _userService.getUserByFirebaseUid(
        firebaseUser.user?.uid ?? '',
      );

      if (backendUser != null) {
        print('Backend user data retrieved successfully');
        _userModel.value = backendUser;
        print(
          'UserModel updated with backend data: ${_userModel.value?.toJson()}',
        );

        // Important: Assign the Firebase UID to ensure proper identification
        if (_userModel.value?.firebaseUid == null) {
          print(
            'Warning: Backend user has null firebaseUid. Using current UID: ${firebaseUser.user?.uid}',
          );
          // Create a new UserModel with the Firebase UID added
          _userModel.value = UserModel(
            id: _userModel.value!.id,
            name: _userModel.value!.name,
            email: _userModel.value!.email,
            password: _userModel.value!.password,
            role: _userModel.value!.role,
            createdAt: _userModel.value!.createdAt,
            updatedAt: _userModel.value!.updatedAt,
            trainers: _userModel.value!.trainers,
            clients: _userModel.value!.clients,
            firebaseUid: firebaseUser.user?.uid,
          );
        }
      } else {
        print(
          'Warning: Backend user data not found for Firebase UID: ${firebaseUser.user?.uid}',
        );
      }

      return backendUser;
    } catch (e) {
      print('Error during sign-in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userModel.value = null;
    } catch (e) {
      print('Error during sign-out: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.authEndpoint}/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to send password reset email: ${response.body}',
        );
      }
    } catch (e) {
      print('Error during password reset: $e');
      rethrow;
    }
  }
}
