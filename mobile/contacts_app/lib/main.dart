import 'package:contacts_app/presentation/api_config/cubit/api_config_cubit.dart';
import 'package:contacts_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:contacts_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'injection_container.dart' as di;
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/MaterialIcons-Regular.ttf');
    yield LicenseEntryWithLineBreaks(['Material Icons'], license);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => di.sl<ContactCubit>()),
        BlocProvider(create: (_) => di.sl<ApiConfigCubit>()..loadConfig())
      ],
      child: MaterialApp(
        title: 'Contacts App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}