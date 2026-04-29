import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';

class TimetableFormPage extends ConsumerStatefulWidget {
  final int? entryId;

  const TimetableFormPage({super.key, this.entryId});

  @override
  ConsumerState<TimetableFormPage> createState() => _TimetableFormPageState();
}

class _TimetableFormPageState extends ConsumerState<TimetableFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  String _selectedDay = 'Monday';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  bool get _isEditing => widget.entryId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadEntryData();
    }
  }

  Future<void> _loadEntryData() async {
    await Future.microtask(() {});
    // Assuming the entry is already loaded in the schedule state since we came from the list
    final schedule = ref.read(staffTimetableNotifierProvider).schedule;
    final entry = schedule.firstWhere((e) => e.id == widget.entryId, orElse: () => throw Exception('Not found'));
    
    if (mounted) {
      setState(() {
        _subjectController.text = entry.subject;
        _instructorController.text = entry.instructor;
        _roomController.text = entry.room;
        _selectedDay = entry.day;
        _startTime = _parseTimeOfDay(entry.startTime);
        _endTime = _parseTimeOfDay(entry.endTime);
      });
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    // Basic parsing for "10:00 AM" format
    try {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
      if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    // Simple 12-hour format: 10:00 AM
    String hour = (time.hour == 0 || time.hour == 12) ? '12' : (time.hour % 12).toString();
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => _startTime = time);
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => _endTime = time);
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _startTime != null && _endTime != null) {
      final notifier = ref.read(staffTimetableNotifierProvider.notifier);

      if (_isEditing) {
        notifier.updateSchedule(
          widget.entryId!,
          subject: _subjectController.text,
          instructor: _instructorController.text,
          day: _selectedDay,
          startTime: _formatTimeOfDay(_startTime!),
          endTime: _formatTimeOfDay(_endTime!),
          room: _roomController.text,
        );
      } else {
        notifier.createSchedule(
          subject: _subjectController.text,
          instructor: _instructorController.text,
          day: _selectedDay,
          startTime: _formatTimeOfDay(_startTime!),
          endTime: _formatTimeOfDay(_endTime!),
          room: _roomController.text,
        );
      }
      context.pop();
    } else if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end times')),
      );
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _instructorController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Class' : 'Add Class'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructorController,
              decoration: const InputDecoration(labelText: 'Lecturer / Instructor'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedDay,
              decoration: const InputDecoration(labelText: 'Day of Week'),
              items: _days.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedDay = value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Time'),
                    subtitle: Text(_startTime == null ? 'Not set' : _startTime!.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _pickStartTime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    title: const Text('End Time'),
                    subtitle: Text(_endTime == null ? 'Not set' : _endTime!.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _pickEndTime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: 'Location / Room'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save Changes' : 'Add Class'),
            ),
          ],
        ),
      ),
    );
  }
}
