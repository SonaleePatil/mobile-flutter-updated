import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/routes/Models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';


class RouteEventsSection extends StatelessWidget {
  final List<EventModel> events;

  const RouteEventsSection({super.key, required this.events});

  String _formatEventDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final eventDate = DateTime(date.year, date.month, date.day);

    if (eventDate == DateTime(now.year, now.month, now.day)) return "Today";
    if (eventDate == tomorrow) return "Tomorrow";
    return DateFormat('EEE, MMM d').format(date);
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming': return 'Open';
      case 'ongoing': return 'Live';
      case 'completed': return 'Completed';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming': return const Color(0xFF328700);
      case 'ongoing': return AppColors.deepRed;
      case 'completed': return Colors.grey;
      case 'cancelled': return Colors.red;
      default: return const Color(0xFF328700);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Events on this track", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final event = events[index];
                final isFeatured = event.category.toLowerCase().contains('featured') || event.rank <= 3;
                return _EventCard(
                  imageUrl: event.mainImage.isNotEmpty ? event.mainImage : event.eventImage,
                  title: event.title,
                  status: _getStatusText(event.status),
                  statusColor: _getStatusColor(event.status),
                  frequency: _formatEventDate(event.eventDate),
                  location: event.address.split(',').first,
                  distance: "${event.distance} km",
                  featured: isFeatured,
                  onShareTap: () {},
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String status;
  final Color statusColor;
  final String frequency;
  final String location;
  final String distance;
  final bool featured;
  final VoidCallback onTap;
  final VoidCallback onShareTap;

  const _EventCard({
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.frequency,
    required this.location,
    required this.distance,
    required this.featured,
    required this.onTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 210,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(child: _buildImage()),
                Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.12))),
                if (featured)
                  const Positioned(top: 12, left: 12, child: _MiniChip(text: "Featured", isFeatured: true)),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onShareTap,
                      child: Center(
                        child: Image.asset(
                          "assets/icons/share.png",
                          width: 25,
                          height: 25,
                          errorBuilder: (_, __, ___) => const Icon(Icons.share, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MiniChip(text: status, statusColor: statusColor, isRegistered: status.toLowerCase() == 'open'),
                        const SizedBox(height: 6),
                        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildMetaItem("assets/icons/lighting.png", frequency),
                            const SizedBox(width: 12),
                            _buildMetaItem("assets/icons/water_statoins.png", location),
                            const SizedBox(width: 12),
                            _buildMetaItem("assets/icons/restrooms.png", distance),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(String iconPath, String text) {
    return Expanded(
      child: Row(
        children: [
          Image.asset(iconPath, width: 14, height: 14, errorBuilder: (_, __, ___) => const SizedBox(width: 14, height: 14)),
          const SizedBox(width: 6),
          Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary))),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) return _buildPlaceholder();

    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Data = imageUrl.contains('base64,') ? imageUrl.split('base64,').last : imageUrl;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder());
      } catch (e) {
        return _buildPlaceholder();
      }
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder());
    }

    return Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder());
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.softCream,
      child: const Center(child: Icon(Icons.event, size: 40, color: Colors.grey)),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  final Color? statusColor;
  final bool isRegistered;
  final bool isFeatured;

  const _MiniChip({required this.text, this.statusColor, this.isRegistered = false, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    final Color bg = isFeatured
        ? AppColors.deepRed
        : isRegistered
            ? const Color(0xFF3EE606).withValues(alpha: 0.33)
            : (statusColor?.withValues(alpha: 0.33) ?? const Color(0xFF328700).withValues(alpha: 0.33));

    final Color fg = isFeatured ? Colors.white : (isRegistered ? const Color(0xFF328700) : (statusColor ?? const Color(0xFF328700)));

    return Container(
      height: isRegistered ? 20 : 24,
      width: isRegistered ? 74 :74,
      padding: EdgeInsets.fromLTRB(9, isRegistered ? 3 : 5, 9, isRegistered ? 4 : 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(isRegistered ? 4.969 : 7.52)),
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: isRegistered ? 9.983 : 11, fontWeight: FontWeight.w600, height: 1, color: fg),
        ),
      ),
    );
  }
}