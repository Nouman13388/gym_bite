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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.cyanAccent,
                      ),
                    ),
                  )
                  : controller.hasError.value
                  ? _buildErrorState()
                  : RefreshIndicator(
                    onRefresh: () => controller.fetchClientData(),
                    backgroundColor: Colors.black,
                    color: Colors.cyanAccent,
                    child: ListView(
                      padding: const EdgeInsets.all(28),
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today, $formattedDate",
                              style: const TextStyle(
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
                              color: const Color.fromRGBO(169, 169, 169, 0.2),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Monotone add.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${controller.fitnessScore}",
                                      style: const TextStyle(
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
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: const Text(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${controller.fitnessScoreChange}% vs last week",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    Text(
                                      "💡 ${controller.suggestions} suggestions",
                                      style: const TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Upcoming Appointments
                        _buildAppointmentSection(),

                        const SizedBox(height: 20),

                        // Workout Plans
                        _buildWorkoutPlansSection(),

                        const SizedBox(height: 20),

                        // Meal Plans
                        _buildMealPlansSection(),

                        const SizedBox(height: 20),
                        // Progress Section
                        _buildProgressSection(),

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
                                    "Your Calories Trend",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const Text(
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
                      ],
                    ),
                  ),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchClientData(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.cyanAccent,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Helper method to build profile information rows
  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show upcoming appointments and consultations
  Widget _buildAppointmentSection() {
    return Obx(() {
      final hasAppointment = controller.nextAppointment.value.isNotEmpty;
      final hasConsultation = controller.nextConsultation.value.isNotEmpty;

      if (!hasAppointment && !hasConsultation) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(169, 169, 169, 0.2),
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upcoming Sessions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            if (hasAppointment) ...[
              _buildSessionCard(
                "Appointment",
                controller.nextAppointment.value['date'] ?? 'No date',
                controller.nextAppointment.value['time'] ?? 'No time',
                controller.nextAppointment.value['trainerName'] ?? 'No trainer',
                Icons.fitness_center,
              ),
            ],
            if (hasConsultation) ...[
              if (hasAppointment) const SizedBox(height: 8),
              _buildSessionCard(
                "Consultation",
                controller.nextConsultation.value['date'] ?? 'No date',
                controller.nextConsultation.value['time'] ?? 'No time',
                controller.nextConsultation.value['trainerName'] ??
                    'No trainer',
                Icons.health_and_safety,
              ),
            ],
          ],
        ),
      );
    });
  }

  // Helper method to build session cards (appointments and consultations)
  Widget _buildSessionCard(
    String type,
    String date,
    String time,
    String trainer,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Date: $date",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "Time: $time",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "Trainer: $trainer",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show workout plans
  Widget _buildWorkoutPlansSection() {
    return Obx(() {
      if (controller.workoutPlans.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(169, 169, 169, 0.2),
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              "No workout plans assigned yet",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(169, 169, 169, 0.2),
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Workout Plans",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  controller.workoutPlans.length > 3
                      ? 3
                      : controller.workoutPlans.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final plan = controller.workoutPlans[index];
                return _buildPlanCard(
                  plan['name'] ?? 'Unnamed Plan',
                  plan['description'] ?? 'No description',
                  plan['duration'] ?? 'Unknown duration',
                  'workout',
                );
              },
            ),
            if (controller.workoutPlans.length > 3) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to full workout plans list
                  },
                  child: const Text(
                    "View All Workout Plans",
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // Widget to show meal plans
  Widget _buildMealPlansSection() {
    return Obx(() {
      if (controller.mealPlans.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(169, 169, 169, 0.2),
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              "No meal plans assigned yet",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(169, 169, 169, 0.2),
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Meal Plans",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  controller.mealPlans.length > 3
                      ? 3
                      : controller.mealPlans.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final plan = controller.mealPlans[index];
                return _buildPlanCard(
                  plan['name'] ?? 'Unnamed Plan',
                  plan['description'] ?? 'No description',
                  plan['duration'] ?? 'Unknown duration',
                  'meal',
                );
              },
            ),
            if (controller.mealPlans.length > 3) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to full meal plans list
                  },
                  child: const Text(
                    "View All Meal Plans",
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // Helper method to build plan cards (workout and meal plans)
  Widget _buildPlanCard(
    String name,
    String description,
    String duration,
    String type,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(
                  type == 'workout'
                      ? 'assets/images/workout.png'
                      : 'assets/images/Meals.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description.length > 100
                      ? '${description.substring(0, 100)}...'
                      : description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "Duration: $duration",
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show client's progress data
  Widget _buildProgressSection() {
    return Obx(() {
      if (controller.clientProgress.value.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(169, 169, 169, 0.2),
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              "No progress data available",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(169, 169, 169, 0.2),
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Progress",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  controller.clientProgress.value.length > 3
                      ? 3
                      : controller.clientProgress.value.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final progress = controller.clientProgress.value[index];
                return _buildProgressCard(
                  progress['date'] ?? 'No date',
                  progress['weight']?.toString() ?? 'N/A',
                  progress['BMI']?.toString() ?? 'N/A',
                  progress['bodyFat']?.toString() ?? 'N/A',
                );
              },
            ),
            if (controller.clientProgress.value.length > 3) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to full progress history
                  },
                  child: const Text(
                    "View All Progress History",
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // Helper method to build progress cards
  Widget _buildProgressCard(
    String date,
    String weight,
    String bmi,
    String bodyFat,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.timeline, color: Colors.cyanAccent),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressMetric("Weight", weight),
              _buildProgressMetric("BMI", bmi),
              _buildProgressMetric("Body Fat", bodyFat),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build progress metrics
  Widget _buildProgressMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
