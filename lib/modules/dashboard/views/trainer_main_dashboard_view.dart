import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_dashboard_controller.dart';

class TrainerMainDashboardView extends GetView<MainDashboardController> {
  const TrainerMainDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.pages,
        ),
      ),
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
              icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note),
              label: 'Sessions',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_books_outlined),
              selectedIcon: Icon(Icons.library_books),
              label: 'Plans',
            ),
          ],
        ),
      ),
    );
  }
}
