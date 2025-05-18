import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/client_workout_plan_controller.dart';
import 'client_workout_plan_view_embedded.dart';

class ClientWorkoutPlanView extends GetView<ClientWorkoutPlanController> {
  const ClientWorkoutPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workout Plans'),
        backgroundColor: Colors.black,
      ),
      body: const ClientWorkoutPlanViewEmbedded(),
    );
  }
}
