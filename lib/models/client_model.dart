import 'user_model.dart';

class ClientModel {
  final int id;
  final int userId;
  final double weight;
  final double height;
  final double BMI;
  final String? fitnessGoals;
  final String? dietaryPreferences;
  final UserModel? user;

  ClientModel({
    required this.id,
    required this.userId,
    required this.weight,
    required this.height,
    required this.BMI,
    this.fitnessGoals,
    this.dietaryPreferences,
    this.user,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      userId: json['userId'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      BMI: json['BMI'].toDouble(),
      fitnessGoals: json['fitnessGoals'],
      dietaryPreferences: json['dietaryPreferences'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'BMI': BMI,
      'fitnessGoals': fitnessGoals,
      'dietaryPreferences': dietaryPreferences,
      'user': user?.toJson(),
    };
  }
}
