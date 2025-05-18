class MealPlanModel {
  final int id;
  final int trainerId; // ID of the trainer who created it
  final String title;
  final String description;
  final String category; // e.g., "Weight Loss", "Muscle Gain", "Maintenance"
  final List<Meal> meals;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MealPlanModel({
    required this.id,
    required this.trainerId,
    required this.title,
    required this.description,
    required this.category,
    required this.meals,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    List<Meal> parsedMeals = [];
    if (json['meals'] != null && json['meals'] is List) {
      parsedMeals =
          (json['meals'] as List).map((m) => Meal.fromJson(m)).toList();
    }

    return MealPlanModel(
      id: json['id'] ?? 0,
      trainerId: json['trainerId'] ?? 0,
      title: json['title'] ?? 'Unnamed Meal Plan',
      description: json['description'] ?? 'No description available',
      category: json['category'] ?? 'General',
      meals: parsedMeals,
      imageUrl: json['imageUrl'] ?? 'assets/images/Meals.png',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainerId': trainerId,
      'title': title,
      'description': description,
      'category': category,
      'meals': meals.map((m) => m.toJson()).toList(),
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Meal {
  final String name;
  final String description;
  final String type; // e.g., "Breakfast", "Lunch", "Dinner", "Snack"
  final List<String> ingredients;
  final int calories;
  final String imageUrl;
  final int protein; // Protein content in grams

  Meal({
    required this.name,
    required this.description,
    required this.type,
    required this.ingredients,
    required this.calories,
    required this.imageUrl,
    this.protein = 0, // Default value if not provided
  });
  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> parsedIngredients = [];
    if (json['ingredients'] != null && json['ingredients'] is List) {
      parsedIngredients =
          (json['ingredients'] as List).map((i) => i.toString()).toList();
    }

    return Meal(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'Other',
      ingredients: parsedIngredients,
      calories: json['calories'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'assets/images/Meals.png',
      protein: json['protein'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'ingredients': ingredients,
      'calories': calories,
      'imageUrl': imageUrl,
      'protein': protein,
    };
  }
}
