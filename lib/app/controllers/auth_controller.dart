import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';

/// Handles Supabase authentication: login, register, logout, session persistence.
/// Role is read from user_metadata/app_metadata in Supabase Auth.
class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final errorMessage = ''.obs;

  final isLoggedIn = false.obs;
  final isAdmin = false.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
    // Listen for auth state changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        isLoggedIn.value = true;
        userEmail.value = SupabaseService.userEmail;
        _fetchRole(); // Fetch role from user metadata
      } else {
        isLoggedIn.value = false;
        isAdmin.value = false;
        userEmail.value = '';
      }
    });
  }

  void _checkSession() {
    final session = SupabaseService.client.auth.currentSession;
    if (session != null) {
      isLoggedIn.value = true;
      userEmail.value = SupabaseService.userEmail;
      _fetchRole();
    }
  }

  /// Fetch role from user metadata
  void _fetchRole() {
    final role = SupabaseService.fetchUserRole();
    isAdmin.value = (role == AppConstants.roleAdmin);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Register with email and password
  Future<void> register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      errorMessage.value = 'Please fill in all fields.';
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }
    if (passwordController.text.length < AppConstants.minPasswordLength) {
      errorMessage.value =
          'Password must be at least ${AppConstants.minPasswordLength} characters.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await SupabaseService.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.snackbar(
        'Success',
        'Registration successful! You can now sign in.',
        backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
      _clearFields();
      Get.offAllNamed('/login');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with email and password
  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      errorMessage.value = 'Please fill in all fields.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await SupabaseService.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Fetch role from user metadata
      isLoggedIn.value = true;
      userEmail.value = SupabaseService.userEmail;
      _fetchRole();

      _clearFields();
      Get.offAllNamed('/home');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await SupabaseService.client.auth.signOut();
      isLoggedIn.value = false;
      isAdmin.value = false;
      _clearFields();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout.',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.3),
        colorText: Colors.white,
      );
    }
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
