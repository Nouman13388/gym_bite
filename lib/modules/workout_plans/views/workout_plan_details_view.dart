import 'package:flutter/material.dart';

class WorkoutPlanDetailsView extends StatelessWidget {
  const WorkoutPlanDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Workout Plan Image
            Container(
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/Workout_plan.jpg', // replace with your image
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Workout Plan Title & Details
            const Text(
              'Upper Body Strength',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Focus: Upper Body | Level: Intermediate\nGoal: Muscle Gain – 5 days/week',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Warm-Up
            const Text(
              'Warm-Up (10 mins):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jumping jacks, arm circles, shoulder rolls, dynamic stretches',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Main Workout
            const Text(
              'Main Workout (40 mins):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Bench Press: 4 sets x 10 reps\n'
                  '- Overhead Press: 3 sets x 12 reps\n'
                  '- Dumbbell Rows: 4 sets x 10 reps\n'
                  '- Push-ups: 3 sets to failure\n'
                  '- Lat Pulldowns: 3 sets x 12 reps',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Cool Down
            const Text(
              'Cool Down (10 mins):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Static stretches for chest, shoulders, and back. Deep breathing exercises.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Select Button
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700, width: 1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 11),
                    backgroundColor: const Color.fromARGB(255, 33, 174, 199),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Handle workout selection
                  },
                  child: const Text(
                    'Select',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: WorkoutPlanDetailsView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
