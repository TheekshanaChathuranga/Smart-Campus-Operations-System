import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/shared/widgets/empty_state.dart';
import 'package:smart_campus_operations_system/shared/widgets/error_widget.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(announcementNotifierProvider.notifier).loadAnnouncements();
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school_rounded;
      case 'it services':
        return Icons.computer_rounded;
      case 'library':
        return Icons.local_library_rounded;
      case 'financial aid':
        return Icons.account_balance_rounded;
      case 'campus life':
        return Icons.park_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    switch (category.toLowerCase()) {
      case 'academic':
        return const Color(0xFF6C63FF);
      case 'it services':
        return const Color(0xFF03DAC6);
      case 'library':
        return const Color(0xFFFFB74D);
      case 'financial aid':
        return const Color(0xFF4FC3F7);
      case 'campus life':
        return const Color(0xFF81C784);
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: state.isLoading && state.announcements.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.announcements.isEmpty
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () =>
                      ref.read(announcementNotifierProvider.notifier).loadAnnouncements(),
                )
              : state.announcements.isEmpty
                  ? const EmptyStateWidget(
                      title: 'No Announcements',
                      subtitle: 'Nothing new right now. Check back later!',
                      icon: Icons.notifications_off_rounded,
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(announcementNotifierProvider.notifier).loadAnnouncements(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.announcements.length,
                        itemBuilder: (context, index) {
                          final announcement = state.announcements[index];
                          return _AnnouncementCard(
                            announcement: announcement,
                            index: index,
                            categoryIcon: _getCategoryIcon(announcement.category),
                            categoryColor: _getCategoryColor(announcement.category, theme),
                            timeAgo: _formatTimeAgo(announcement.publishedAt),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _AnnouncementCard extends StatefulWidget {
  final Announcement announcement;
  final int index;
  final IconData categoryIcon;
  final Color categoryColor;
  final String timeAgo;

  const _AnnouncementCard({
    required this.announcement,
    required this.index,
    required this.categoryIcon,
    required this.categoryColor,
    required this.timeAgo,
  });

  @override
  State<_AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<_AnnouncementCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final announcement = widget.announcement;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (widget.index * 80)),
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
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    // Category icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.categoryIcon,
                        size: 20,
                        color: widget.categoryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                announcement.category,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: widget.categoryColor,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (announcement.isNew) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onError,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.timeAgo,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  announcement.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // Expandable body
                AnimatedCrossFade(
                  firstChild: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      announcement.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      announcement.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
