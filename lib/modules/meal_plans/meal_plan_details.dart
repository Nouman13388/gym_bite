import 'package:flutter/material.dart';

class MealPlanDetails extends StatelessWidget {
  const MealPlanDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            // Meal Plan Image
            Container(
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/Meal_plan1.png'), // replace with your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Meal Plan Title & Details
            Text(
              'Meal Plan 1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Diet Type: High Protein, Non-Vegetarian\nGoal: Muscle Gain – 2500 kcal/day',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),

            // Breakfast
            Text(
              'Breakfast (08:00 AM):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '3 scrambled eggs, 2 slices whole grain toast, 1 avocado, 1 banana, 1 glass of whole milk',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),

            // Lunch
            Text(
              'Lunch (01:00 PM):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Grilled chicken breast (200g), brown rice (1 cup), steamed broccoli and carrots, olive oil dressing',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),

            // Dinner
            Text(
              'Dinner (08:00 PM):',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Grilled salmon (150g), quinoa (1/2 cup), sautéed spinach, sweet potato wedges (100g)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),

            // Select Button
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade700,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 11),
                    backgroundColor: Color.fromARGB(255, 33, 174, 199),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // action here
                  },
                  child: Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
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
