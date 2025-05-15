import 'package:flutter/material.dart';
//import 'meal_plan_screen2.dart';

class MealPlanScreen1 extends StatelessWidget {
  const MealPlanScreen1({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select your Meal plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Get personalized meal plans and nutrition insights from your Trainers',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            Image.asset('assets/images/Meal_plan1.png'),
            SizedBox(height: 30),
            Container(
              width: 85,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.grey.shade600, // Grey border color
                  width: 1.0, // Border width
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.cyanAccent,
                    size: 40,
                  ),
                  onPressed: () {
                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(builder: (context) => MealPlanScreen2()),
                    //);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: MealPlanScreen1(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
