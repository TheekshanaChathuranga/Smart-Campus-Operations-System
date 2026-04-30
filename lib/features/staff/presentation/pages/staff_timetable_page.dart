import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/core/router/app_router.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';

class StaffTimetablePage extends ConsumerStatefulWidget {
  const StaffTimetablePage({super.key});

  @override
  ConsumerState<StaffTimetablePage> createState() => _StaffTimetablePageState();
}

class _StaffTimetablePageState extends ConsumerState<StaffTimetablePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(staffTimetableNotifierProvider.notifier).loadAllSchedule());
  }

  void _confirmDelete(BuildContext context, ScheduleEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text('Are you sure you want to delete "${entry.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(staffTimetableNotifierProvider.notifier).deleteSchedule(entry.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffTimetableNotifierProvider);

    ref.listen(staffTimetableNotifierProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.successMessage!)));
        ref.read(staffTimetableNotifierProvider.notifier).clearMessages();
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: Colors.red));
        ref.read(staffTimetableNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Timetable'),
      ),
      body: Stack(
        children: [
          if (staffState.isLoading && staffState.schedule.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (staffState.schedule.isEmpty)
            const Center(child: Text('No classes found.'))
          else
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: staffState.schedule.length,
              itemBuilder: (context, index) {
                final entry = staffState.schedule[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Color(entry.color),
                      child: Text(
                        entry.subject.substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(entry.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${entry.day} • ${entry.startTime} - ${entry.endTime}'),
                        Text('${entry.instructor} • ${entry.room}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => context.pushNamed(
                            AppRoutes.staffTimetableEdit,
                            pathParameters: {'entryId': entry.id.toString()},
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, entry),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (staffState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.staffTimetableCreate),
        child: const Icon(Icons.add),
      ),
    );
  }
}
