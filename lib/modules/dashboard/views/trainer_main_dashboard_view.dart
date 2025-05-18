import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_dashboard_controller.dart';
import '../controllers/trainer_dashboard_controller.dart';
import 'trainer_dashboard_view.dart';
import '../../meal_plans/views/trainer_meal_plan_view_embedded.dart';
import '../../workout_plans/views/trainer_workout_plan_view_embedded.dart';
import '../../profile/views/trainer_profile_view.dart';
import '../../profile/controllers/trainer_profile_controller.dart';
import '../../workout_plans/controllers/trainer_workout_plan_controller.dart';

class TrainerMainDashboardView extends GetView<MainDashboardController> {
  const TrainerMainDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // We'll control layout manually with Row
        title: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            children: [
              // 👤 Account Avatar (Left)
              Obx(
                () => GestureDetector(
                  onTap: () {
                    final user = controller.user.value;
                    if (user != null) {
                      Get.snackbar(
                        'Trainer Account',
                        'Name: ${user.name}\nEmail: ${user.email}',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.black54,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child:
                        controller.user.value?.name != null
                            ? Text(
                              controller.user.value!.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 🖼 Logo (Center Expanded)
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/gymBite logo.png',
                    height: 50,
                  ),
                ),
              ),

              // 🚪 Logout Button (Right)
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Get.back(),
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            controller.signOut();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changePage,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Clients',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Meal Plans',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center),
              label: 'Workouts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  } // Method to build the appropriate body content based on the selected index

  Widget _buildBody() {
    switch (controller.selectedIndex.value) {
      case 0: // Home
        return _buildHomeContent();
      case 1: // Clients
        return _buildComingSoonContent('Client Management Feature');
      case 2: // Meal Plans
        return const TrainerMealPlanViewEmbedded();
      case 3: // Workout Plans
        return _buildWorkoutContent();
      case 4: // Profile
        // Import the TrainerProfileView and show it
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  // Widget for the profile content
  Widget _buildProfileContent() {
    // Lazily load the profile controller if needed
    if (!Get.isRegistered<TrainerProfileController>()) {
      Get.put(TrainerProfileController());
    }
    // Return the trainer profile view
    return const TrainerProfileView();
  }

  // Widget for the workout plans content
  Widget _buildWorkoutContent() {
    // Lazily load the workout controller if needed
    if (!Get.isRegistered<TrainerWorkoutPlanController>()) {
      Get.put(TrainerWorkoutPlanController());
    }
    // Return the trainer workout plan view
    return const TrainerWorkoutPlanViewEmbedded();
  }

  // Widget for the home tab content
  Widget _buildHomeContent() {
    // Lazily load the TrainerDashboardController if it's not already registered
    if (!Get.isRegistered<TrainerDashboardController>()) {
      Get.put(TrainerDashboardController());
    }

    // Show the TrainerDashboardView as the home content
    return const TrainerDashboardView();
  }

  // Widget for "Coming Soon" placeholder content
  Widget _buildComingSoonContent(String feature) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 80, color: Colors.cyanAccent),
          const SizedBox(height: 24),
          Text(
            '$feature Coming Soon!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We\'re working hard to bring this feature to you.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget for dashboard cards
  Widget _buildDashboardCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white10,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.cyanAccent, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.cyanAccent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
