import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import 'package:intl/intl.dart';

class TrainerProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  // Trainer statistics
  final activeClients = 12.obs;
  final totalSessions = 86.obs;
  final mealPlans = 8.obs;

  // Expertise and certifications
  final expertise =
      <String>[
        'Strength Training',
        'Weight Loss',
        'Nutrition',
        'Functional Training',
        'Bodybuilding',
      ].obs;

  final certifications =
      <String>[
        'Certified Personal Trainer (CPT)',
        'Nutrition Specialist',
        'Functional Training Expert',
        'Sports Performance Coach',
      ].obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.userModel;
    // In a real app, you would load these from a database
    loadTrainerData();
  }

  void loadTrainerData() {
    // Simulate fetching data from backend
    // In a real app, you would make API calls to get this data
    // For now, we'll use demo data
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  void showUpdateExpertiseDialog() {
    final expertiseController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Update Expertise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Current Expertise:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  expertise
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          onDeleted: () {
                            expertise.remove(skill);
                            expertise.refresh();
                          },
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: expertiseController,
              decoration: const InputDecoration(labelText: 'Add new expertise'),
            ),
          ],
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (expertiseController.text.isNotEmpty) {
                expertise.add(expertiseController.text);
                expertiseController.clear();
                expertise.refresh();
              }
            },
          ),
          TextButton(
            child: const Text('Done'),
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Updated',
                'Your expertise has been updated',
                snackPosition: SnackPosition.BOTTOM,
              );
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
