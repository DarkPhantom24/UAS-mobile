import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final AuthController _ac = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              const SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cardDark,
                  border: Border.all(color: AppTheme.accentBlue, width: 3),
                ),
                child: const Icon(Icons.person_rounded, size: 60, color: AppTheme.accentBlue),
              ),
              const SizedBox(height: 24),
              Obx(() => Text(
                _ac.userEmail.value,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
              )),
              const SizedBox(height: 8),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _ac.isAdmin.value ? AppTheme.accentCrimson.withValues(alpha: 0.2) : AppTheme.accentBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _ac.isAdmin.value ? 'Admin' : 'User',
                  style: TextStyle(
                    color: _ac.isAdmin.value ? AppTheme.accentCrimson : AppTheme.accentBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _ac.logout(),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentCrimson,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
