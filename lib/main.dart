import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/app_bindings.dart';
import 'app/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.scaffoldBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Supabase
  // ⚠️ Replace with your actual Supabase URL and Anon Key
  await Supabase.initialize(
    url: 'https://hbdvrcexdvhucqbvfeqo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhiZHZyY2V4ZHZodWNxYnZmZXFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MTI2MjksImV4cCI6MjA5NDI4ODYyOX0.M5nW2OHF_aXuGhi6Q405ddz5ZZ5P2ciMbh5iaw_DmKQ',
  );

  runApp(const CineVaultApp());
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: AppBindings(),
      initialRoute: SupabaseService.isLoggedIn
          ? AppRoutes.home
          : AppRoutes.login,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
