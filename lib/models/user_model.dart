import 'role_model.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Trainer specific fields
  final String? specialization;
  final String? bio;
  final double? rating;
  final List<String>? clientIds;

  // Client specific fields
  final String? assignedTrainerId;
  final Map<String, dynamic>? fitnessGoals;
  final Map<String, dynamic>? measurements;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    this.specialization,
    this.bio,
    this.rating,
    this.clientIds,
    this.assignedTrainerId,
    this.fitnessGoals,
    this.measurements,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.client,
      ),
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      specialization: json['specialization'],
      bio: json['bio'],
      rating: json['rating']?.toDouble(),
      clientIds:
          json['clientIds'] != null
              ? List<String>.from(json['clientIds'])
              : null,
      assignedTrainerId: json['assignedTrainerId'],
      fitnessGoals: json['fitnessGoals'],
      measurements: json['measurements'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'specialization': specialization,
      'bio': bio,
      'rating': rating,
      'clientIds': clientIds,
      'assignedTrainerId': assignedTrainerId,
      'fitnessGoals': fitnessGoals,
      'measurements': measurements,
    };
  }

  // Helper methods
  bool get isTrainer => role.isTrainer;
  bool get isClient => role.isClient;
  bool get isAdmin => role.isAdmin;

  // Create a copy of the model with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? specialization,
    String? bio,
    double? rating,
    List<String>? clientIds,
    String? assignedTrainerId,
    Map<String, dynamic>? fitnessGoals,
    Map<String, dynamic>? measurements,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      clientIds: clientIds ?? this.clientIds,
      assignedTrainerId: assignedTrainerId ?? this.assignedTrainerId,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      measurements: measurements ?? this.measurements,
    );
  }
}
