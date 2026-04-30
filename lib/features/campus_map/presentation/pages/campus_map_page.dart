import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';

class CampusMapPage extends ConsumerStatefulWidget {
  const CampusMapPage({super.key});

  @override
  ConsumerState<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends ConsumerState<CampusMapPage> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'building':
        return Icons.business_rounded;
      case 'library':
        return Icons.local_library_rounded;
      case 'department':
        return Icons.school_rounded;
      case 'sports':
        return Icons.sports_soccer_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'hostel':
        return Icons.hotel_rounded;
      case 'venue':
        return Icons.theater_comedy_rounded;
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'maintenance':
        return Icons.engineering_rounded;
      case 'union':
        return Icons.groups_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'building':
        return const Color(0xFF6C63FF);
      case 'library':
        return const Color(0xFFFFB74D);
      case 'department':
        return const Color(0xFF4FC3F7);
      case 'sports':
        return const Color(0xFF81C784);
      case 'food':
        return const Color(0xFFFF6584);
      case 'hostel':
        return const Color(0xFFAB47BC);
      case 'venue':
        return const Color(0xFF03DAC6);
      case 'admin':
        return const Color(0xFF1E88E5);
      case 'maintenance':
        return const Color(0xFFF4511E);
      case 'union':
        return const Color(0xFF00897B);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapNotifierProvider);
    final theme = Theme.of(context);
    final center = state.userLocation ?? const LatLng(6.0636, 80.5408);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        actions: [
          IconButton(
            icon: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_rounded),
            tooltip: 'My Location',
            onPressed: state.isLoading
                ? null
                : () {
                    ref.read(mapNotifierProvider.notifier).getCurrentLocation();
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          // ─── Map ────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 17.0,
              onTap: (_, _) {
                ref.read(mapNotifierProvider.notifier).selectLandmark(null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.smartcampus.app',
              ),

              // Landmark markers
              MarkerLayer(
                markers: state.landmarks.map((landmark) {
                  final color = _getCategoryColor(landmark.category);
                  final isSelected = state.selectedLandmark == landmark;

                  return Marker(
                    point: landmark.position,
                    width: isSelected ? 56 : 44,
                    height: isSelected ? 56 : 44,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(mapNotifierProvider.notifier)
                            .selectLandmark(landmark);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: isSelected ? 12 : 6,
                              spreadRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          _getCategoryIcon(landmark.category),
                          color: Colors.white,
                          size: isSelected ? 24 : 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // User location marker
              if (state.userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: state.userLocation!,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ─── Landmark Detail Card ───────────────
          if (state.selectedLandmark != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              state.selectedLandmark!.category,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _getCategoryIcon(state.selectedLandmark!.category),
                            color: _getCategoryColor(
                              state.selectedLandmark!.category,
                            ),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.selectedLandmark!.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.selectedLandmark!.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            ref
                                .read(mapNotifierProvider.notifier)
                                .selectLandmark(null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ─── Error Snackbar ─────────────────────
          if (state.error != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
