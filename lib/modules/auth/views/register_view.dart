import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            TextField(
              onChanged: (val) => controller.nameController.value = val,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => controller.emailController.value = val,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => controller.passwordController.value = val,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: controller.selectedRole.value,
              items: const [
                DropdownMenuItem(value: 'CLIENT', child: Text('Client')),
                DropdownMenuItem(value: 'TRAINER', child: Text('Trainer')),
              ],
              onChanged: (value) {
                if (value != null) controller.selectedRole.value = value;
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () =>
                  controller.selectedRole.value == 'TRAINER'
                      ? Column(
                        children: [
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.specialtyController.value = val,
                            decoration: const InputDecoration(
                              labelText: 'Specialty',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.experienceYearsController.value =
                                        val,
                            decoration: const InputDecoration(
                              labelText: 'Experience (Years)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.weightController.value = val,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.heightController.value = val,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) => controller.bmiController.value = val,
                            decoration: const InputDecoration(
                              labelText: 'BMI',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.fitnessGoalsController.value =
                                        val,
                            decoration: const InputDecoration(
                              labelText: 'Fitness Goals',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller
                                        .dietaryPreferencesController
                                        .value = val,
                            decoration: const InputDecoration(
                              labelText: 'Dietary Preferences',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.register,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Register'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
