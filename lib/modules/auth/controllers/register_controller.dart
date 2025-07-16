import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../core/constants/app_constants.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordVisible = false.obs;
  final isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final specialtyController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();
  final fitnessGoalsController = TextEditingController();
  final dietaryPreferencesController = TextEditingController();
  final selectedRole = 'CLIENT'.obs;
  final AuthService authService = Get.find<AuthService>();

  Future<void> register() async {
    isLoading.value = true;
    // Check if user exists in backend
    final checkResponse = await http.get(
      Uri.parse('${AppConstants.userEndpoint}/email/${emailController.text}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (checkResponse.statusCode == 200) {
      final existingUser = jsonDecode(checkResponse.body);
      if (existingUser != null) {
        Get.snackbar(
          'Error',
          'Email is already registered. Please login or recover your account.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }
    }
    // Proceed with Firebase signup
    try {
      await authService.createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
        selectedRole.value,
      );
      final user = authService.userModel;
      if (user != null && user.firebaseUid != null) {
        try {
          if (selectedRole.value == 'TRAINER') {
            final trainerRequestBody = {
              'userId': user.id,
              'specialty': specialtyController.text,
              'experienceYears':
                  int.tryParse(experienceYearsController.text) ?? 0,
            };
            final trainerResponse = await http.post(
              Uri.parse(AppConstants.trainerEndpoint),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(trainerRequestBody),
            );
            if (trainerResponse.statusCode != 200 &&
                trainerResponse.statusCode != 201) {
              Get.snackbar(
                'Error',
                'Failed to register trainer.',
                snackPosition: SnackPosition.BOTTOM,
              );
              isLoading.value = false;
              return;
            }
          } else {
            final clientRequestBody = {
              'userId': user.id,
              'weight': double.tryParse(weightController.text) ?? 0.0,
              'height': double.tryParse(heightController.text) ?? 0.0,
              'BMI': double.tryParse(bmiController.text) ?? 0.0,
              'fitnessGoals': fitnessGoalsController.text,
              'dietaryPreferences': dietaryPreferencesController.text,
            };
            final clientResponse = await http.post(
              Uri.parse(AppConstants.clientEndpoint),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(clientRequestBody),
            );
            if (clientResponse.statusCode != 200 &&
                clientResponse.statusCode != 201) {
              Get.snackbar(
                'Error',
                'Failed to register client.',
                snackPosition: SnackPosition.BOTTOM,
              );
              isLoading.value = false;
              return;
            }
          }
          Get.snackbar(
            'Success',
            'Registration successful! Please login.',
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading.value = false;
          Get.offAllNamed(Routes.LOGIN);
        } catch (apiError) {
          Get.snackbar(
            'Error',
            'Failed to complete registration. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to create user in Firebase. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    specialtyController.dispose();
    experienceYearsController.dispose();
    weightController.dispose();
    heightController.dispose();
    bmiController.dispose();
    fitnessGoalsController.dispose();
    dietaryPreferencesController.dispose();
    super.onClose();
  }
}
