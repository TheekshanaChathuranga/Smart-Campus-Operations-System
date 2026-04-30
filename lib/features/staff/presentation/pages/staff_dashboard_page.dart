import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/core/router/app_router.dart';

class StaffDashboardPage extends ConsumerStatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  ConsumerState<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends ConsumerState<StaffDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(eventNotifierProvider.notifier).loadEvents());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final eventState = ref.watch(eventNotifierProvider);
    final user = authState.user;
    final events = eventState.events;
    final totalRegistrations = events.fold<int>(0, (sum, e) => sum + e.registeredCount);
    final today = DateTime.now();
    final todayEvents = events.where((e) =>
        e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ─── Header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withValues(alpha: 0.25),
                              child: Text(
                                user?.name.substring(0, 1).toUpperCase() ?? 'S',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  Text(
                                    user?.name ?? 'Staff',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_user_rounded, size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('STAFF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Stats Row ──────────────────────────
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.event_rounded,
                        label: 'Total Events',
                        value: '${events.length}',
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        icon: Icons.today_rounded,
                        label: 'Today',
                        value: '$todayEvents',
                        color: const Color(0xFF03DAC6),
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        icon: Icons.how_to_reg_rounded,
                        label: 'Registrations',
                        value: '$totalRegistrations',
                        color: const Color(0xFFFF6584),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Quick Actions ───────────────────────
                  Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _ActionCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan Check-in',
                        subtitle: 'Verify attendance',
                        gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9C94FF)]),
                        onTap: () => context.pushNamed(AppRoutes.qrScanner, extra: true),
                      ),
                      _ActionCard(
                        icon: Icons.event_note_rounded,
                        label: 'Manage Events',
                        subtitle: 'Create, edit, delete',
                        gradient: const LinearGradient(colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)]),
                        onTap: () => context.goNamed(AppRoutes.staffEvents),
                      ),
                      _ActionCard(
                        icon: Icons.campaign_rounded,
                        label: 'Post Announcement',
                        subtitle: 'Broadcast news',
                        gradient: const LinearGradient(colors: [Color(0xFF03DAC6), Color(0xFF4EEEE0)]),
                        onTap: () => context.pushNamed(AppRoutes.staffAnnouncementCreate),
                      ),
                      _ActionCard(
                        icon: Icons.map_rounded,
                        label: 'Campus Map',
                        subtitle: 'View landmarks',
                        gradient: const LinearGradient(colors: [Color(0xFFFFB74D), Color(0xFFFFCC80)]),
                        onTap: () => context.goNamed(AppRoutes.staffMap),
                      ),
                      _ActionCard(
                        icon: Icons.schedule_rounded,
                        label: 'Manage Timetable',
                        subtitle: 'Add/Edit classes',
                        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)]),
                        onTap: () => context.pushNamed(AppRoutes.staffTimetable),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Upcoming Events Preview ─────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming Events', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => context.goNamed(AppRoutes.staffEvents),
                        child: const Text('Manage All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (eventState.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (events.isEmpty)
                    _EmptyEventsCard()
                  else
                    ...events.take(3).map((event) => _EventPreviewCard(
                          title: event.title,
                          date: event.date,
                          registered: event.registeredCount,
                          capacity: event.capacity,
                        )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventPreviewCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final int registered;
  final int capacity;

  const _EventPreviewCard({required this.title, required this.date, required this.registered, required this.capacity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = capacity > 0 ? registered / capacity : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 13, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              Text('$registered/$capacity', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: pct.clamp(0, 1), minHeight: 4),
          ),
        ],
      ),
    );
  }
}

class _EmptyEventsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('No events yet. Tap "Manage Events" to create one!',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }
}
