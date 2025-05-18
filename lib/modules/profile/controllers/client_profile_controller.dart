import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import 'package:intl/intl.dart';

class ClientProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  // Body measurements
  final weight = 70.0.obs;
  final height = 175.0.obs;
  final bodyFat = 15.0.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
    // In a real app, you would load these from a database
    loadUserData();
  }

  void loadUserData() {
    // Simulate fetching data from backend
    // In a real app, you would make API calls to get this data
    // For now, we'll use demo data
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String calculateBMI() {
    double heightInMeters = height.value / 100;
    double bmi = weight.value / (heightInMeters * heightInMeters);
    return bmi.toStringAsFixed(1);
  }

  void showUpdateMeasurementsDialog() {
    final weightController = TextEditingController(
      text: weight.value.toString(),
    );
    final heightController = TextEditingController(
      text: height.value.toString(),
    );
    final bodyFatController = TextEditingController(
      text: bodyFat.value.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Update Measurements'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bodyFatController,
              decoration: const InputDecoration(labelText: 'Body Fat (%)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              // Validate and update measurements
              try {
                weight.value = double.parse(weightController.text);
                height.value = double.parse(heightController.text);
                bodyFat.value = double.parse(bodyFatController.text);
                Get.back();
                Get.snackbar(
                  'Updated',
                  'Your measurements have been updated',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Please enter valid numbers',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Change'),
            onPressed: () {
              // Validate passwords
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                Get.snackbar(
                  'Error',
                  'Passwords do not match',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // In a real app, you would call an API to change the password
              Get.back();
              Get.snackbar(
                'Success',
                'Password changed successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }
}
