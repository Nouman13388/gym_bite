import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  // Get the API base URL with fallback
  static String get apiBaseUrl {
    // Read from .env file, or fall back to localhost if not found
    final url = dotenv.env['BASE_URL'];

    if (url != null && url.isNotEmpty) {
      return url;
    } else if (kIsWeb) {
      // Default to localhost for web
      return 'http://localhost:3000/api';
    } else {
      // Default to emulator IP for Android
      return 'http://10.0.2.2:3000/api';
    }
  }

  // Load the .env file
  static Future<void> loadEnvFile() async {
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Loaded .env file');
    } catch (e) {
      debugPrint('Failed to load .env file, using defaults: $e');
    }
  }
}
