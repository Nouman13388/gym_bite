import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class ClientDashboardView extends GetView<DashboardController> {
  const ClientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildDashboardItem(
            icon: Icons.fitness_center,
            title: 'My Workout Plan',
            onTap: () => Get.toNamed(Routes.PLANS),
          ),
          _buildDashboardItem(
            icon: Icons.calendar_today,
            title: 'Book Session',
            onTap: () => Get.toNamed(Routes.APPOINTMENTS),
          ),
          _buildDashboardItem(
            icon: Icons.chat,
            title: 'Chat with Trainer',
            onTap: () => Get.toNamed(Routes.CHAT),
          ),
          _buildDashboardItem(
            icon: Icons.track_changes,
            title: 'Track Progress',
            onTap: () => Get.toNamed(Routes.PROGRESS),
          ),
          _buildDashboardItem(
            icon: Icons.restaurant_menu,
            title: 'Meal Plan',
            onTap: () => Get.toNamed(Routes.MEAL_PLAN),
          ),
          _buildDashboardItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () => Get.toNamed(Routes.PROFILE),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
