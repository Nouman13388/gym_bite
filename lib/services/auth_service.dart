import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import 'user_service.dart';

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
      _fetchUserData(user.uid);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      // Fetch user data from the API using the Firebase UID
      final response = await http.get(
        Uri.parse('${AppConstants.userEndpoint}?firebaseUid=$uid'),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        if (users.isNotEmpty) {
          final userData = users.first;
          _userModel.value = UserModel.fromJson(userData);
        } else {
          print('No user found for the given Firebase UID.');
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
      // Step 1: Sign in with Firebase
      final firebaseUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Fetch user data from backend
      final backendUser = await _userService.getUserByFirebaseUid(
        firebaseUser.user?.uid ?? '',
      );

      if (backendUser != null) {
        _userModel.value = backendUser;
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
