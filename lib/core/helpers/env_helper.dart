import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  static String? get mainApiUrl => dotenv.env['main_api'];
  static set mainApiUrl(String? value) => dotenv.env['main_api'] = value ?? '';

  static String? get devApiUrl => dotenv.env['dev_api'];
  static String? get productApiUrl => dotenv.env['product_api'];
}
