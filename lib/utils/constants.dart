// utils/constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String apiUsername = dotenv.env['API_USERNAME'] ?? 'default_username';
  static String apiPassword = dotenv.env['API_PASSWORD'] ?? 'default_password';
}
