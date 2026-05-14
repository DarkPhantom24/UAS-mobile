import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/app_bindings.dart';
import 'app/services/supabase_service.dart';
import 'app/utils/constants.dart';

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
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const CineVaultApp());
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
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
