import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/shared/widgets/empty_state.dart';
import 'package:smart_campus_operations_system/shared/widgets/error_widget.dart';
import 'package:smart_campus_operations_system/features/timetable/presentation/widgets/schedule_card.dart';


class TimetablePage extends ConsumerStatefulWidget {
  const TimetablePage({super.key});

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends ConsumerState<TimetablePage> {
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    // Load today's schedule
    final today = DateFormat('EEEE').format(DateTime.now());
    final initialDay = _days.contains(today) ? today : 'Monday';
    Future.microtask(() {
      ref.read(timetableNotifierProvider.notifier).loadSchedule(initialDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timetableNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        actions: [
          // User avatar / menu
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  authState.user?.name.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authState.user?.name ?? 'User',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      authState.user?.email ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      authState.user?.role.displayName ?? '',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: theme.colorScheme.error, size: 20),
                    const SizedBox(width: 12),
                    Text('Log Out', style: TextStyle(color: theme.colorScheme.error)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authNotifierProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Day Selector ─────────────────────
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = state.selectedDay == day;
                final isToday = DateFormat('EEEE').format(DateTime.now()) == day;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    child: ChoiceChip(
                      label: Text(
                        day.substring(0, 3),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary,
                      avatar: isToday && !isSelected
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                      onSelected: (_) {
                        ref.read(timetableNotifierProvider.notifier).selectDay(day);
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── Content ──────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? AppErrorWidget(
                        message: state.error!,
                        onRetry: () => ref
                            .read(timetableNotifierProvider.notifier)
                            .loadSchedule(state.selectedDay),
                      )
                    : state.entries.isEmpty
                        ? const EmptyStateWidget(
                            title: 'No Classes',
                            subtitle: 'No classes scheduled for this day.\nEnjoy your free time! 🎉',
                            icon: Icons.free_breakfast_rounded,
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.entries.length,
                            itemBuilder: (context, index) {
                              return ScheduleCard(
                                entry: state.entries[index],
                                index: index,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
