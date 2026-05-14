import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../theme/app_theme.dart';
import 'home_view.dart';
import 'search_view.dart';
import 'loved_view.dart';
import 'profile_view.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final MainController _mainController = Get.find<MainController>();

  final List<Widget> _pages = [
    HomeView(),
    SearchView(),
    LovedView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(
            index: _mainController.selectedIndex.value,
            children: _pages,
          )),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.search_rounded, 'label': 'Search'},
      {'icon': Icons.favorite_rounded, 'label': 'Loved'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          border: Border(top: BorderSide(color: AppTheme.glassBorder)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = _mainController.selectedIndex.value == index;
              return GestureDetector(
                onTap: () => _mainController.changeTab(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.accentBlue.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item['icon'] as IconData, color: selected ? AppTheme.accentBlue : AppTheme.textMuted),
                      if (selected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            color: AppTheme.accentBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

