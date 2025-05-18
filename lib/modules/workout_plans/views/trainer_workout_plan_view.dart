import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_workout_plan_controller.dart';
import 'trainer_workout_plan_view_embedded.dart';

class TrainerWorkoutPlanView extends GetView<TrainerWorkoutPlanController> {
  const TrainerWorkoutPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workout Plans'),
        backgroundColor: Colors.black,
      ),
      body: const TrainerWorkoutPlanViewEmbedded(),
    );
  }
}
