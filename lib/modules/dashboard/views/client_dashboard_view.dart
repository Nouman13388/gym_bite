import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/client_dashboard_controller.dart';

class ClientDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientDashboardController>(() => ClientDashboardController());
    // Ensure DashboardController is available
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(() => DashboardController());
    }
  }
}

class ClientDashboardView extends GetView<ClientDashboardController> {
  const ClientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Image.asset(
            'assets/images/gymBite logo.png',
            height: 50, // adjust based on your image size
          ),
        ),
        actions: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Get.back(),
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () {
                          Get.find<DashboardController>().signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          SizedBox(width: 25),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today, $formattedDate",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fitness Score Card
            Obx(
              () => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(169, 169, 169, 0.2),
                  border: Border.all(
                    color: Colors.grey, // Grey border color
                    width: 1.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/Monotone add.png', // Replace with your image path
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${controller.fitnessScore}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Your Fitness Score",
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey, // Grey border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Text(
                            "View More",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: LineChart(_lineChartData(controller)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.fitnessScoreChange}% vs last week",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          "💡 ${controller.suggestions} suggestions",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Calories Chart Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.black],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Your calories Trend",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 1.0, // Border width
                          ),
                        ),
                        child: Text(
                          "View More",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: BarChart(_barChartData(controller)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Workout Plan & Meal Plan Card
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 150,
                    height: 140,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/workout_plans.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: const Text(
                            "Workout Plans\n⏱ 50 min",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 150,
                    height: 140,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/meal plan 4.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: const Text(
                            "Meal Plans\n⏱ 30 min",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _lineChartData(ClientDashboardController controller) {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return Text(
                value.toInt() >= 0 && value.toInt() < days.length
                    ? days[value.toInt()]
                    : '',
                style: TextStyle(fontSize: 12),
              );
            },
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: List.generate(
            controller.weeklyScores.length,
            (i) => FlSpot(i.toDouble(), controller.weeklyScores[i]),
          ),
          color: Colors.orange,
          barWidth: 3,
        ),
      ],
    );
  }

  BarChartData _barChartData(ClientDashboardController controller) {
    return BarChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        controller.caloriesData.length,
        (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: controller.caloriesData[i],
              color: Colors.white,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  // Manually inject the controller for testing
  Get.put(ClientDashboardController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClientDashboardView(), // Directly running the screen
    ),
  );
}
