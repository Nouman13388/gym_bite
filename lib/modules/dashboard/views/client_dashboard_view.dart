import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';


class ClientDashboardView extends GetView<DashboardController> {
  const ClientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Welcome User",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fitness Score Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(169, 169, 169, 0.2),
                border: Border.all(
                  color: Colors.grey,  // Grey border color
                  width: 1.0,          // Border width
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
                  const Text("82.5",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
                  const Text("Your Fitness Score", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  SizedBox(height: 100, child: LineChart(_lineChartData())),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("-12% vs last week", style: TextStyle(color: Colors.red)),
                      Text("💡 8 suggestions", style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Calories Chart Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("2300 Kcalories spend",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(height: 100, child: BarChart(_barChartData())),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Workout Plan Card
            Container(
              height: 140,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/muscle.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF21AEC7),
                        border: Border.all(
                          color: Colors.grey,  // Grey border color
                          width: 1.0,          // Border width
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Upper Body", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: const Text(
                      "Workout Plans\n⏱ 50 min",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.bookmark_border, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _lineChartData() {
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
          spots: [
            FlSpot(0, 50),
            FlSpot(1, 80),
            FlSpot(2, 60),
            FlSpot(3, 100),
            FlSpot(4, 70),
            FlSpot(5, 60),
            FlSpot(6, 50),
          ],
          color: Colors.orange,
          barWidth: 3,
        )
      ],
    );
  }


  BarChartData _barChartData() {
    return BarChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        8,
            (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (i % 2 == 0 ? 8 : 4) + i.toDouble(),
              color: Colors.white,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            )
          ],
        ),
      ),
    );
  }
}
