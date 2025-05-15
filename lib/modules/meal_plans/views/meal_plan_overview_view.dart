import 'package:flutter/material.dart';
import 'meal_plan_details_view.dart';

class MealPlanOverviewView extends StatelessWidget {
  const MealPlanOverviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                'Select your Meal plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'choose a meal plan to start',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 30),
              mealPlanTile(context, 'Meal Plan 1'),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget mealPlanTile(BuildContext context, String title) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(20),
        width: 90,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/Meal_plan2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'view details',
        style: TextStyle(color: Colors.white54, fontSize: 14),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanDetailsView(),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: MealPlanOverviewView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
