import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String _baseUrl = 'http://localhost:5000';
  static String _apiVersion = 'v1';

  static String get baseUrl => _baseUrl;
  static String get apiBaseUrl => '$_baseUrl';

  static Future<void> configure({required String url, String version = 'v1'}) async {
    _baseUrl = url;
    _apiVersion = version;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', url);
    await prefs.setString('apiVersion', version);
  }

  static Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString('baseUrl') ?? _baseUrl;
    _apiVersion = prefs.getString('apiVersion') ?? _apiVersion;
  }
}
