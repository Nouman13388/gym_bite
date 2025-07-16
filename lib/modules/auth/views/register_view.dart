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
      appBar: AppBar(
        title: const Text(''),
        titleTextStyle: TextStyle(fontSize: 25),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/gymBite logo.png', height: 80),
            const SizedBox(height: 32),
            TextField(
              onChanged: (val) => controller.nameController.value = val,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  color: Colors.white,
                ), // Label when not focused
                floatingLabelStyle: TextStyle(color: Colors.cyanAccent),
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => controller.emailController.value = val,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.white,
                ), // Label when not focused
                floatingLabelStyle: TextStyle(color: Colors.cyanAccent),
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => controller.passwordController.value = val,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.white,
                ), // Label when not focused
                floatingLabelStyle: TextStyle(
                  color: Colors.cyanAccent,
                ), // Label when focused
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
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
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(
                  color: Colors.white, // Label color when not focused
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.white, // Label color when focused (floating)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
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
                            decoration: InputDecoration(
                              labelText: 'Specialty',
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.experienceYearsController.value =
                                        val,
                            decoration: InputDecoration(
                              labelText: 'Experience (Years)',
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.fitness_center_outlined),
                              labelText: 'Weight (kg)',
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.heightController.value = val,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              prefixIcon: Icon(Icons.height_outlined),
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) => controller.bmiController.value = val,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calculate_outlined),
                              labelText: 'BMI',
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller.fitnessGoalsController.value =
                                        val,
                            decoration: InputDecoration(
                              labelText: 'Fitness Goals',
                              prefixIcon: Icon(Icons.directions_run_outlined),
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged:
                                (val) =>
                                    controller
                                        .dietaryPreferencesController
                                        .value = val,
                            decoration: InputDecoration(
                              labelText: 'Dietary Preferences',
                              prefixIcon: Icon(Icons.restaurant_menu_outlined),
                              labelStyle: TextStyle(
                                color:
                                    Colors
                                        .white, // Label color when not focused
                              ),
                              floatingLabelStyle: TextStyle(
                                color:
                                    Colors
                                        .cyanAccent, // Label color when focused (floating)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isLoading.value ? null : controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent, // Button background color
                  foregroundColor: Colors.white, // Text/icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ), // Optional padding
                  disabledBackgroundColor:
                      Colors.grey, // Color when button is disabled
                ),
                child:
                    controller.isLoading.value
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                        : const Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.cyanAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
