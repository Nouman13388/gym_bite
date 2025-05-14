import 'role_model.dart';
import 'trainer_model.dart';
import 'client_model.dart';

class UserModel {
  final int id; // Updated to match Prisma schema
  final String name;
  final String email;
  final String password; // Added to match Prisma schema
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? firebaseUid; // Added to store Firebase UID

  // Relationships
  final List<TrainerModel>? trainers;
  final List<ClientModel>? clients;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.trainers,
    this.clients,
    this.firebaseUid, // Added to constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.client,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      trainers:
          json['trainers'] != null
              ? (json['trainers'] as List)
                  .map((trainer) => TrainerModel.fromJson(trainer))
                  .toList()
              : null,
      clients:
          json['clients'] != null
              ? (json['clients'] as List)
                  .map((client) => ClientModel.fromJson(client))
                  .toList()
              : null,
      firebaseUid: json['firebaseUid'], // Added to fromJson
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'trainers': trainers?.map((trainer) => trainer.toJson()).toList(),
      'clients': clients?.map((client) => client.toJson()).toList(),
      'firebaseUid': firebaseUid, // Added to toJson
    };
  }

  // Helper methods
  bool get isTrainer => role == UserRole.trainer;
  bool get isClient => role == UserRole.client;
  bool get isAdmin => role == UserRole.admin;
}
