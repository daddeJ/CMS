import 'package:contacts_app/presentation/api_config/pages/api_config_page.dart';
import 'package:flutter/material.dart';

import '../domain/entities/contact.dart';
import '../presentation/splash/splash_page.dart';
import '../presentation/api_config/pages/api_config_page.dart';
import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/register_page.dart';
import '../presentation/contact/pages/contact_list_page.dart';
import '../presentation/contact/pages/add_contact_page.dart';
import '../presentation/contact/pages/update_contact_page.dart';


class AppRouter {
  static const String splash = '/';
  static const String apiconfig = '/api_config';
  static const String login = '/login';
  static const String register = '/register';
  static const String contactList = '/contacts';
  static const String addContact = '/contacts/add';
  static const String updateContact = '/contacts/update';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case apiconfig:
        return MaterialPageRoute(builder: (_) => ApiConfigPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case contactList:
        return MaterialPageRoute(builder: (_) => ContactListPage());
      case addContact:
        return MaterialPageRoute(builder: (_) => AddContactPage());
      case updateContact:
        final contact = settings.arguments as Contact;
        return MaterialPageRoute(
          builder: (_) => UpdateContactPage(contact: contact),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}