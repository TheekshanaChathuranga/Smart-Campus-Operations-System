import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/shared/widgets/empty_state.dart';
import 'package:smart_campus_operations_system/shared/widgets/error_widget.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventNotifierProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: state.isLoading && state.events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.events.isEmpty
          ? AppErrorWidget(
              message: state.error!,
              onRetry: () =>
                  ref.read(eventNotifierProvider.notifier).loadEvents(),
            )
          : state.events.isEmpty
          ? const EmptyStateWidget(
              title: 'No Events',
              subtitle: 'There are no upcoming events right now.',
              icon: Icons.event_busy_rounded,
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(eventNotifierProvider.notifier).loadEvents(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  final dateFormatted = DateFormat(
                    'MMM dd, yyyy • h:mm a',
                  ).format(event.date);
                  final isUpcoming = event.date.isAfter(DateTime.now());

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + (index * 80)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go('/events/${event.id}'),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title row
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  if (isUpcoming)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Upcoming',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Description
                              Text(
                                event.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Meta info
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: [
                                  _MetaChip(
                                    icon: Icons.calendar_today_rounded,
                                    label: dateFormatted,
                                    theme: theme,
                                  ),
                                  _MetaChip(
                                    icon: Icons.location_on_outlined,
                                    label: event.location,
                                    theme: theme,
                                  ),
                                  _MetaChip(
                                    icon: Icons.people_outline_rounded,
                                    label: '${event.spotsLeft} spots left',
                                    theme: theme,
                                    color: event.isFull
                                        ? theme.colorScheme.error
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final Color? color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.theme,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: chipColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
