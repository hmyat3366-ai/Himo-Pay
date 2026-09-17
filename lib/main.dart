import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';
import 'core/storage/app_preferences.dart';
import 'core/supabase/supabase_config.dart';
import 'data/repositories/himo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before anything else
  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    anonKey: SupabaseConfig.anonKey,
  );

  await AppPreferences.init();
  if (AppPreferences.isLoggedIn && AppPreferences.activeUserId != null) {
    HimoRepository().setActiveUserId(AppPreferences.activeUserId!);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const HimoPayApp());
}


class HimoPayApp extends StatelessWidget {
  const HimoPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppPreferences.localeNotifier,
      builder: (context, localeCode, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppPreferences.themeModeNotifier,
          builder: (context, themeMode, _) {
            final isDark = themeMode == ThemeMode.dark;
            return MaterialApp(
              title: 'Himo Pay',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: '/splash',
              onGenerateRoute: (settings) => AppRouter.generateRoute(
                settings,
                onToggleTheme: AppPreferences.toggleTheme,
                isDark: isDark,
              ),
            );
          },
        );
      },
    );
  }
}

