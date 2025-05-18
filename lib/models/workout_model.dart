class WorkoutPlanModel {
  final int id;
  final int userId;
  final String title; // Changed from name to title
  final String description;
  final String category;
  final int duration; // in minutes
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final String imageUrl; // Asset path or network URL
  final List<Exercise> exercises; // Changed from String to List<Exercise>
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutPlanModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    required this.exercises,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    // Parse exercises from the exercises field if it exists as a list
    List<Exercise> parsedExercises = [];
    if (json['exercises'] != null && json['exercises'] is List) {
      parsedExercises =
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList();
    } else if (json['exercises'] != null && json['exercises'] is String) {
      // For backward compatibility with the old API
      final exercisesStr = json['exercises'] as String;
      final sets = json['sets'] as int? ?? 3;
      final reps = json['reps'] as int? ?? 10;
      parsedExercises = parseExercises(exercisesStr, sets, reps);
    }

    return WorkoutPlanModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Unnamed Workout',
      description: json['description'] ?? 'No description available',
      category:
          json['category'] ??
          determineCategory(json['exercises']?.toString() ?? ''),
      duration: json['duration'] ?? 30,
      difficulty: json['difficulty'] ?? 'Intermediate',
      imageUrl: json['imageUrl'] ?? 'assets/images/workout.png',
      exercises: parsedExercises,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  static String determineCategory(String exercises) {
    final lowerCaseExercises = exercises.toLowerCase();

    if (lowerCaseExercises.contains('bench') ||
        lowerCaseExercises.contains('push') ||
        lowerCaseExercises.contains('curl')) {
      return 'Upper Body';
    } else if (lowerCaseExercises.contains('squat') ||
        lowerCaseExercises.contains('deadlift') ||
        lowerCaseExercises.contains('leg')) {
      return 'Lower Body';
    } else if (lowerCaseExercises.contains('plank') ||
        lowerCaseExercises.contains('crunch')) {
      return 'Core';
    }

    return 'Full Body';
  }

  static List<Exercise> parseExercises(
    String exercisesStr,
    int sets,
    int reps,
  ) {
    final exerciseNames = exercisesStr.split(',').map((e) => e.trim()).toList();
    return exerciseNames
        .map(
          (name) => Exercise(
            name: name,
            description: 'Perform $name with proper form',
            sets: sets,
            reps: reps,
            restTime: 60,
            imageUrl: 'assets/images/workout.png',
          ),
        )
        .toList();
  }
}

class Exercise {
  final String name;
  final String description;
  final int sets;
  final int reps;
  final int restTime; // in seconds
  final String? videoUrl; // Optional URL to demonstration video
  final String imageUrl; // Asset path or network URL

  Exercise({
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    required this.restTime,
    this.videoUrl = '',
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      description: json['description'] ?? 'Perform with proper form',
      sets: json['sets'] ?? 3,
      reps: json['reps'] ?? 10,
      restTime: json['restTime'] ?? 60,
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'] ?? 'assets/images/workout.png',
    );
  }
}
