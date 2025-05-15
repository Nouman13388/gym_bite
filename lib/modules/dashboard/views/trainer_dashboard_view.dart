import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class TrainerDashboardView extends GetView<DashboardController> {
  const TrainerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Dashboard'),
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
            icon: Icons.people,
            title: 'My Clients',
            onTap: () => Get.toNamed(Routes.CLIENTS),
          ),
          _buildDashboardItem(
            icon: Icons.fitness_center,
            title: 'Workout Plans',
            onTap: () => Get.toNamed(Routes.PLANS),
          ),
          _buildDashboardItem(
            icon: Icons.calendar_today,
            title: 'Schedule',
            onTap: () => Get.toNamed(Routes.APPOINTMENTS),
          ),
          _buildDashboardItem(
            icon: Icons.chat,
            title: 'Messages',
            onTap: () => Get.toNamed(Routes.CHAT),
          ),
          _buildDashboardItem(
            icon: Icons.restaurant_menu,
            title: 'Meal Plans',
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
