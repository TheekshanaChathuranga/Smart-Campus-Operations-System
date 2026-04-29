import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation bar wrapping the ShellRoute's child.
class CampusBottomNav extends StatelessWidget {
  final Widget child;

  const CampusBottomNav({super.key, required this.child});

  static const _tabs = [
    _NavTab(path: '/timetable', icon: Icons.calendar_today_rounded, activeIcon: Icons.calendar_today, label: 'Timetable'),
    _NavTab(path: '/events', icon: Icons.event_outlined, activeIcon: Icons.event_rounded, label: 'Events'),
    _NavTab(path: '/announcements', icon: Icons.campaign_outlined, activeIcon: Icons.campaign_rounded, label: 'News'),
    _NavTab(path: '/map', icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: 'Map'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            context.go(_tabs[index].path);
          },
          animationDuration: const Duration(milliseconds: 400),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _tabs.map((tab) {
            return NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.activeIcon),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavTab {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavTab({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
