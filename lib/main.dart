import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/l10n/app_localizations.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/features/child/screens/child_dashboard_screen.dart';
import 'presentation/features/parent/screens/parent_auth_screen.dart';
import 'presentation/features/parent/screens/parent_dashboard_screen.dart';
import 'presentation/onboarding/role_selection_screen.dart';
import 'providers/app_mode_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/child_telemetry_provider.dart';
import 'providers/parent_dashboard_provider.dart';
import 'providers/rules_provider.dart';
import 'providers/sos_alert_provider.dart';
import 'providers/web_activity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase safely (falls back to mock store if unconfigured)
  await FirebaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppModeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ParentDashboardProvider()),
        ChangeNotifierProvider(create: (_) => ChildTelemetryProvider()),
        ChangeNotifierProvider(create: (_) => RulesProvider()),
        ChangeNotifierProvider(create: (_) => SosAlertProvider()),
        ChangeNotifierProvider(create: (_) => WebActivityProvider()),
      ],
      child: const KidsSafetyApp(),
    ),
  );
}


class KidsSafetyApp extends StatelessWidget {
  const KidsSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modeProv = Provider.of<AppModeProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: modeProv.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Consumer2<AppModeProvider, AuthProvider>(
        builder: (context, mode, auth, _) {
          if (!mode.isInitialized) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          switch (mode.currentMode) {
            case AppMode.parent:
              return auth.isAuthenticated
                  ? const ParentDashboardScreen()
                  : const ParentAuthScreen();
            case AppMode.child:
              return const ChildDashboardScreen();
            case AppMode.none:
            default:
              return const RoleSelectionScreen();
          }
        },
      ),
    );
  }
}
