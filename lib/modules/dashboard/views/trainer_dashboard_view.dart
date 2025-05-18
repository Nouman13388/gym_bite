import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_bite/modules/dashboard/controllers/trainer_dashboard_controller.dart';

class TrainerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerDashboardController>(() => TrainerDashboardController());
  }
}

class TrainerDashboardView extends GetView<TrainerDashboardController> {
  const TrainerDashboardView({super.key});

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
                    onRefresh: () => controller.refreshData(),
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

                        // Trainer Metrics Card
                        _buildTrainerMetricsCard(),

                        const SizedBox(height: 20),

                        // Weekly Earnings Chart
                        _buildEarningsCard(),

                        const SizedBox(height: 20),

                        // Client List Card
                        _buildClientListCard(),

                        const SizedBox(height: 20),

                        // Schedule Card
                        _buildScheduleCard(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerMetricsCard() {
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
            "Your Performance Metrics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetricItem(
                "Clients",
                "${controller.clientCount.value}",
                Icons.people,
                Colors.blue,
              ),
              _buildMetricItem(
                "Rating",
                "${controller.averageRating.toStringAsFixed(1)}",
                Icons.star,
                Colors.amber,
              ),
              _buildMetricItem(
                "Sessions",
                "${controller.completedSessions.value}",
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.work, color: Colors.grey),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  "Specialty: ${controller.specialty.value}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.grey),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  "Experience: ${controller.experienceYears.value} years",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Weekly Earnings",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  "View More",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(height: 120, child: BarChart(_barChartData())),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Mon",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Tue",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Wed",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Thu",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Fri",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Sat",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Sun",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Total: ",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Obx(
                () => Text(
                  "\$${controller.weeklyEarnings.reduce((a, b) => a + b).toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartData _barChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        7,
        (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: controller.weeklyEarnings[i],
              color: Colors.cyanAccent.withOpacity(0.7),
              width: 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientListCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Your Client List",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          "(${controller.clientCount.value})",
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Image.asset(
                    'assets/images/Monotone add.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: const Text(
                  "View More",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Obx(
            () =>
                controller.clientMetrics.isEmpty
                    ? const Center(
                      child: Text(
                        "No clients found",
                        style: TextStyle(color: Colors.white60),
                      ),
                    )
                    : Column(
                      children: List.generate(
                        controller.clientMetrics.length > 3
                            ? 3 // Show only first 3 clients
                            : controller.clientMetrics.length,
                        (index) => _buildClientItem(
                          controller.clientMetrics[index],
                          index,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientItem(ClientMetric client, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: index < 2 ? 16.0 : 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      "Progress: ${client.progress}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Last: ${client.lastSession}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
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
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.cyanAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Upcoming Sessions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.navigateToSchedule(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: const Text(
                    "View Schedule",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () =>
                controller.weeklySchedule.isEmpty
                    ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "No upcoming sessions",
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    )
                    : Column(
                      children: List.generate(
                        controller.weeklySchedule.length > 3
                            ? 3 // Show only first 3 appointments
                            : controller.weeklySchedule.length,
                        (index) => _buildScheduleItem(
                          controller.weeklySchedule[index],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(ScheduleItem item) {
    // Get appropriate status color
    Color statusColor = Colors.blue; // Default scheduled
    if (item.status.toLowerCase() == 'completed') {
      statusColor = Colors.green;
    } else if (item.status.toLowerCase() == 'cancelled') {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  item.day.substring(0, 3), // First 3 letters of day
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.clientName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(color: statusColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.type,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// For standalone testing only - use proper routing in the app
// void main() {
//   Get.put(TrainerDashboardController());
//
//   runApp(
//     GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: TrainerDashboardView(),
//     ),
//   );
// }
