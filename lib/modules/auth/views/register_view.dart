import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../core/constants/app_constants.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController experienceYearsController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController fitnessGoalsController = TextEditingController();
  final TextEditingController dietaryPreferencesController =
      TextEditingController();

  final AuthService authService = Get.find<AuthService>();

  String selectedRole = 'CLIENT';

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
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: 'CLIENT', child: Text('Client')),
                DropdownMenuItem(value: 'TRAINER', child: Text('Trainer')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedRole == 'TRAINER') ...[
              TextField(
                controller: specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Specialty',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: experienceYearsController,
                decoration: const InputDecoration(
                  labelText: 'Experience (Years)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            if (selectedRole == 'CLIENT') ...[
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bmiController,
                decoration: const InputDecoration(
                  labelText: 'BMI',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fitnessGoalsController,
                decoration: const InputDecoration(
                  labelText: 'Fitness Goals',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dietaryPreferencesController,
                decoration: const InputDecoration(
                  labelText: 'Dietary Preferences',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Check if user exists in backend
                if (kDebugMode) {
                  print(
                  'Checking if user exists in backend with email: ${emailController.text}',
                );
                }
                final checkResponse = await http.get(
                  Uri.parse(
                    '${AppConstants.userEndpoint}/email/${emailController.text}',
                  ),
                  headers: {'Content-Type': 'application/json'},
                );

                if (kDebugMode) {
                  print(
                  'Backend check response status: ${checkResponse.statusCode}',
                );
                }
                if (kDebugMode) {
                  print('Backend check response body: ${checkResponse.body}');
                }

                if (checkResponse.statusCode == 200) {
                  final existingUser = jsonDecode(checkResponse.body);
                  if (kDebugMode) {
                    print('Existing user data: $existingUser');
                  }
                  if (existingUser != null) {
                    // User exists in backend
                    Get.snackbar(
                      'Error',
                      'Email is already registered. Please login or recover your account.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                } else {
                  if (kDebugMode) {
                    print(
                    'Unexpected response from backend during user existence check.',
                  );
                  }
                }

                // Proceed with Firebase signup
                try {
                  await authService.createUserWithEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                    nameController.text,
                    selectedRole,
                  );

                  // Backend API Calls
                  final user = authService.userModel;
                  if (user != null && user.firebaseUid != null) {
                    if (kDebugMode) {
                      print('User created in Firebase: ${user.toJson()}');
                    }

                    try {
                      if (selectedRole == 'TRAINER') {
                        final trainerRequestBody = {
                          'userId': user.id,
                          'specialty': specialtyController.text,
                          'experienceYears': int.parse(
                            experienceYearsController.text,
                          ),
                        };
                        if (kDebugMode) {
                          print(
                          'Trainer API Request Body: $trainerRequestBody',
                        );
                        }

                        final trainerResponse = await http.post(
                          Uri.parse(AppConstants.trainerEndpoint),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(trainerRequestBody),
                        );

                        if (trainerResponse.statusCode == 200 ||
                            trainerResponse.statusCode == 201) {
                          if (kDebugMode) {
                            print(
                            'Trainer API Response: ${trainerResponse.body}',
                          );
                          }
                          // Check if the response body contains valid data
                          final responseBody = jsonDecode(trainerResponse.body);
                          if (responseBody != null &&
                              responseBody['id'] != null) {
                            if (kDebugMode) {
                              print(
                              'Trainer successfully registered with ID: ${responseBody['id']}',
                            );
                            }
                          } else {
                            if (kDebugMode) {
                              print(
                              'Unexpected response format from Trainer API: ${trainerResponse.body}',
                            );
                            }
                          }
                        } else {
                          if (kDebugMode) {
                            print(
                            'Trainer API Error: Status Code: ${trainerResponse.statusCode}, Body: ${trainerResponse.body}',
                          );
                          }
                          throw Exception('Failed to register trainer.');
                        }
                      } else {
                        final clientRequestBody = {
                          'userId': user.id,
                          'weight': double.parse(weightController.text),
                          'height': double.parse(heightController.text),
                          'BMI': double.parse(bmiController.text),
                          'fitnessGoals': fitnessGoalsController.text,
                          'dietaryPreferences':
                              dietaryPreferencesController.text,
                        };
                        if (kDebugMode) {
                          print('Client API Request Body: $clientRequestBody');
                        }

                        final clientResponse = await http.post(
                          Uri.parse(AppConstants.clientEndpoint),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(clientRequestBody),
                        );

                        if (clientResponse.statusCode == 200 ||
                            clientResponse.statusCode == 201) {
                          if (kDebugMode) {
                            print('Client API Response: ${clientResponse.body}');
                          }
                        } else {
                          if (kDebugMode) {
                            print(
                            'Client API Error: Status Code: ${clientResponse.statusCode}, Body: ${clientResponse.body}',
                          );
                          }
                          Get.snackbar(
                            'Error',
                            'Failed to register client. Please try again later.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                      }

                      // Notify user and navigate to login page
                      Get.snackbar(
                        'Success',
                        'Registration successful! Please login.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.offAllNamed(Routes.LOGIN);
                    } catch (apiError) {
                      if (kDebugMode) {
                        print('API Error: ${apiError.toString()}');
                      }
                      Get.snackbar(
                        'Error',
                        'Failed to complete registration. Please try again.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    if (kDebugMode) {
                      print('User creation failed in Firebase.');
                    }
                    Get.snackbar(
                      'Error',
                      'Failed to create user in Firebase. Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('Error during registration: $e');
                  }
                  Get.snackbar(
                    'Error',
                    'An unexpected error occurred: $e',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
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
