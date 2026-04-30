import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/core/router/app_router.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';

class StaffEventsPage extends ConsumerStatefulWidget {
  const StaffEventsPage({super.key});

  @override
  ConsumerState<StaffEventsPage> createState() => _StaffEventsPageState();
}

class _StaffEventsPageState extends ConsumerState<StaffEventsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(eventNotifierProvider.notifier).loadEvents());
  }

  void _confirmDelete(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(staffEventNotifierProvider.notifier).deleteEvent(event.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventNotifierProvider);
    final staffEventState = ref.watch(staffEventNotifierProvider);

    // Show messages
    ref.listen(staffEventNotifierProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.successMessage!)));
        ref.read(staffEventNotifierProvider.notifier).clearMessages();
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: Colors.red));
        ref.read(staffEventNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: Stack(
        children: [
          if (eventState.isLoading && eventState.events.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (eventState.events.isEmpty)
            const Center(child: Text('No events found. Create one!'))
          else
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventState.events.length,
              itemBuilder: (context, index) {
                final event = eventState.events[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 4),
                            Text(DateFormat('MMM d, yyyy • h:mm a').format(event.date)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 14),
                            const SizedBox(width: 4),
                            Text('${event.registeredCount} / ${event.capacity} Registrations'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => context.pushNamed(AppRoutes.staffEventEdit, pathParameters: {'eventId': event.id.toString()}),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, event),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          if (staffEventState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.staffEventCreate),
        child: const Icon(Icons.add),
      ),
    );
  }
}
