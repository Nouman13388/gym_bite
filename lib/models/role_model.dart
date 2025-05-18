enum UserRole {
  client,
  trainer,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'CLIENT';
      case UserRole.trainer:
        return 'TRAINER';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get isClient => this == UserRole.client;
  bool get isTrainer => this == UserRole.trainer;
  bool get isAdmin => this == UserRole.admin;
}
