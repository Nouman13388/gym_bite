import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../core/constants/app_constants.dart';

class RegisterController extends GetxController {
  final nameController = ''.obs;
  final emailController = ''.obs;
  final passwordController = ''.obs;
  final specialtyController = ''.obs;
  final experienceYearsController = ''.obs;
  final weightController = ''.obs;
  final heightController = ''.obs;
  final bmiController = ''.obs;
  final fitnessGoalsController = ''.obs;
  final dietaryPreferencesController = ''.obs;
  final selectedRole = 'CLIENT'.obs;
  final AuthService authService = Get.find<AuthService>();

  Future<void> register() async {
    // Check if user exists in backend
    final checkResponse = await http.get(
      Uri.parse('${AppConstants.userEndpoint}/email/${emailController.value}'),
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
        return;
      }
    }
    // Proceed with Firebase signup
    try {
      await authService.createUserWithEmailAndPassword(
        emailController.value,
        passwordController.value,
        nameController.value,
        selectedRole.value,
      );
      final user = authService.userModel;
      if (user != null && user.firebaseUid != null) {
        try {
          if (selectedRole.value == 'TRAINER') {
            final trainerRequestBody = {
              'userId': user.id,
              'specialty': specialtyController.value,
              'experienceYears':
                  int.tryParse(experienceYearsController.value) ?? 0,
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
              return;
            }
          } else {
            final clientRequestBody = {
              'userId': user.id,
              'weight': double.tryParse(weightController.value) ?? 0.0,
              'height': double.tryParse(heightController.value) ?? 0.0,
              'BMI': double.tryParse(bmiController.value) ?? 0.0,
              'fitnessGoals': fitnessGoalsController.value,
              'dietaryPreferences': dietaryPreferencesController.value,
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
              return;
            }
          }
          Get.snackbar(
            'Success',
            'Registration successful! Please login.',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAllNamed(Routes.LOGIN);
        } catch (apiError) {
          Get.snackbar(
            'Error',
            'Failed to complete registration. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to create user in Firebase. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
