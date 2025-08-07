import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/routes/app_router.dart';
import 'package:contacts_app/injection_container.dart';
import 'package:contacts_app/domain/usecases/get_cached_user.dart';
import 'package:contacts_app/domain/entities/user.dart';
import 'package:contacts_app/core/config/api_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Load saved API configuration
      await ApiConfig.loadConfig();

      // Check if API needs configuration
      if (_needsApiConfiguration()) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.apiconfig);
        }
        return;
      }

      // Update Dio instance with configured base URL
      _updateDioConfiguration();

      // Check auth status with minimum splash duration
      await _checkAuthStatus();
    } catch (e) {
      // Fallback to login if any error occurs
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  bool _needsApiConfiguration() {
    final url = ApiConfig.baseUrl.trim();
    return url.isEmpty ||
        url == 'http://localhost:5000' ||
        !url.startsWith('http');
  }

  void _updateDioConfiguration() {
    final dio = sl<Dio>();
    dio.options.baseUrl = ApiConfig.apiBaseUrl;
  }

  Future<void> _checkAuthStatus() async {
    await Future.wait([
      _performAuthCheck(),
      Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
    ]);
  }

  Future<void> _performAuthCheck() async {
    try {
      final getCachedUser = sl<GetCachedUser>();
      final User? user = await getCachedUser();

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        user != null ? AppRouter.contactList : AppRouter.login,
      );
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.contacts, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              'My Contact App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}