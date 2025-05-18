import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_dashboard_controller.dart';
import '../controllers/client_dashboard_controller.dart';
import 'client_dashboard_view.dart';
import '../../meal_plans/views/client_meal_plan_view_embedded.dart';
import '../../workout_plans/views/client_workout_plan_view_embedded.dart';
import '../../profile/views/client_profile_view.dart';
import '../../profile/controllers/client_profile_controller.dart';
import '../../workout_plans/controllers/client_workout_plan_controller.dart';

class ClientMainDashboardView extends GetView<MainDashboardController> {
  const ClientMainDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Image.asset('assets/images/gymBite logo.png', height: 50),
        ),
        actions: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Show confirmation dialog
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, right: 10.0),
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  // Show user info when tapping the avatar
                  final user = controller.user.value;
                  if (user != null) {
                    Get.snackbar(
                      'Client Account',
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
          ),
        ],
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
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Meals',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center),
              label: 'Workouts',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Progress',
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
  }

  // Method to build the appropriate body content based on the selected index
  Widget _buildBody() {
    switch (controller.selectedIndex.value) {
      case 0: // Home
        return _buildHomeContent();
      case 1: // Meal Plans
        return const ClientMealPlanViewEmbedded();
      case 2: // Workout Plans
        return _buildWorkoutContent();
      case 3: // Progress
        return _buildComingSoonContent('Progress Tracking Feature');
      case 4: // Profile
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  // Widget for the profile content
  Widget _buildProfileContent() {
    // Lazily load the profile controller if needed
    if (!Get.isRegistered<ClientProfileController>()) {
      Get.put(ClientProfileController());
    }
    // Return the client profile view
    return const ClientProfileView();
  }

  // Widget for the workout plans content
  Widget _buildWorkoutContent() {
    // Lazily load the workout controller if needed
    if (!Get.isRegistered<ClientWorkoutPlanController>()) {
      Get.put(ClientWorkoutPlanController());
    }
    // Return the client workout plan view
    return const ClientWorkoutPlanViewEmbedded();
  }

  // Widget for the home tab content
  Widget _buildHomeContent() {
    // Lazily load the ClientDashboardController if it's not already registered
    if (!Get.isRegistered<ClientDashboardController>()) {
      Get.put(ClientDashboardController());
    }

    // Show the ClientDashboardView as the home content
    return const ClientDashboardView();
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
