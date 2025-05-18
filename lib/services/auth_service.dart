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

  // Flag to control whether to fetch user data on app startup
  final bool _initialDataFetchEnabled = false;
  // Flag to track if this is the first auth change event
  bool _isFirstAuthEvent = true;

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
      print('------------- FETCHING USER DATA -------------');
      print('Fetching user data for Firebase UID: $uid');
      final apiUrl = '${AppConstants.userEndpoint}?firebaseUid=$uid';
      print('API URL: $apiUrl');

      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => throw TimeoutException('Network request timed out'),
          );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        print('Number of users returned: ${users.length}');

        if (users.isEmpty) {
          print('API returned empty user list for Firebase UID: $uid');
          return;
        }

        final userData = users.firstWhere(
          (user) => user['firebaseUid'] == uid,
          orElse: () => null,
        );

        if (userData != null) {
          print('User data found in response:');
          print('- ID: ${userData['id']}');
          print('- Name: ${userData['name']}');
          print('- Email: ${userData['email']}');
          print('- Role: ${userData['role']}');
          print('- Firebase UID: ${userData['firebaseUid']}');

          _userModel.value = UserModel.fromJson(userData);
          print('UserModel created successfully:');
          print('- ID: ${_userModel.value?.id}');
          print('- Name: ${_userModel.value?.name}');
          print('- Email: ${_userModel.value?.email}');
          print('- Role: ${_userModel.value?.role}');
          print('- Firebase UID: ${_userModel.value?.firebaseUid}');
        } else {
          print('No user found for the given Firebase UID: $uid');
          print('Available users:');
          for (var user in users) {
            print(
              '- ID: ${user['id']}, Firebase UID: ${user['firebaseUid']}, Name: ${user['name']}',
            );
          }
        }
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
      print('------------- END FETCHING USER DATA -------------');
    } catch (e) {
      print('Exception in _fetchUserData: $e');
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

  // Force fetch user data from the backend
  Future<UserModel?> refreshUserData() async {
    print('AuthService - refreshUserData called');
    if (_firebaseUser.value == null) {
      print('Cannot refresh user data - Firebase user is null');
      return null;
    }

    print('Refreshing user data for Firebase UID: ${_firebaseUser.value?.uid}');
    await _fetchUserData(_firebaseUser.value!.uid);

    // Print current user model details
    if (_userModel.value != null) {
      print('User data refreshed:');
      print('ID: ${_userModel.value?.id}');
      print('Name: ${_userModel.value?.name}');
      print('Email: ${_userModel.value?.email}');
      print('Role: ${_userModel.value?.role}');
      print('FirebaseUID: ${_userModel.value?.firebaseUid}');
    } else {
      print('User data refresh failed - _userModel is still null');
    }

    return _userModel.value;
  }
}
