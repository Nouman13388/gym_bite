import 'user_model.dart';

class TrainerModel {
  final int id;
  final int userId;
  final String specialty;
  final int experienceYears;
  final UserModel? user;

  TrainerModel({
    required this.id,
    required this.userId,
    required this.specialty,
    required this.experienceYears,
    this.user,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'],
      userId: json['userId'],
      specialty: json['specialty'],
      experienceYears: json['experienceYears'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'specialty': specialty,
      'experienceYears': experienceYears,
      'user': user?.toJson(),
    };
  }
}
