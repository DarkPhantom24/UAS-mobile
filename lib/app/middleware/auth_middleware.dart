import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../controllers/auth_controller.dart';

/// Middleware to protect routes based on authentication and role.
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // If not logged in, redirect to login
    if (!SupabaseService.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}

/// Middleware to restrict access to admin-only routes.
class AdminMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    if (!SupabaseService.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    // Check role from AuthController (fetched from user metadata)
    final authCtrl = Get.find<AuthController>();
    if (!authCtrl.isAdmin.value) {
      Get.snackbar(
        'Access Denied',
        'Admin privileges required.',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.3),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return const RouteSettings(name: '/home');
    }
    return null;
  }
}
