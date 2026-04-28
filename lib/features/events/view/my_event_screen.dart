import 'dart:convert';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:flutter/material.dart';

class MYEVENET extends StatefulWidget {
  const MYEVENET({super.key});

  @override
  State<MYEVENET> createState() => _MYEVENETState();
}

class _MYEVENETState extends State<MYEVENET> {
  int selectedTab = 0;

  final EventsService _eventsService = EventsService();

  bool _loading = false;
  String? _error;

  List<Event> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final res = await _eventsService.getEvents();

    if (!mounted) return;

    if (res.success && res.data != null) {
      setState(() {
        _allEvents = res.data!;
        _loading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? "Failed to load events";
        _loading = false;
      });
    }
  }

List<Event> _filterByStatus(String status) {
  final target = status.toLowerCase().trim();

  return _allEvents.where((e) {
    final s = (e.status ?? "").toLowerCase().trim();
    return s == target;
  }).toList();
}


  List<Event> get _completedEvents => _filterByStatus("completed");
  List<Event> get _upcomingEvents => _filterByStatus("upcoming");
  List<Event> get _cancelledEvents => _filterByStatus("cancelled");

  List<Event> get _activeList {
    if (selectedTab == 0) return _completedEvents;
    if (selectedTab == 1) return _upcomingEvents;
    return _cancelledEvents;
  }

  String get _emptyText {
    if (selectedTab == 0) return "No completed events";
    if (selectedTab == 1) return "No upcoming events";
    return "No cancelled events";
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final d = DateTime.parse(isoDate).toLocal();
      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      return "${d.day} ${months[d.month - 1]} ${d.year}";
    } catch (_) {
      return isoDate;
    }
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "-";
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final tabWidth = (MediaQuery.of(context).size.width - 32) / 3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _BackCircleButton(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "My Events",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 46),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _TabText(
                        title: "Completed",
                        isSelected: selectedTab == 0,
                        onTap: () => setState(() => selectedTab = 0),
                      ),
                      _TabText(
                        title: "Upcoming",
                        isSelected: selectedTab == 1,
                        onTap: () => setState(() => selectedTab = 1),
                      ),
                      _TabText(
                        title: "Cancelled",
                        isSelected: selectedTab == 2,
                        onTap: () => setState(() => selectedTab = 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        height: 1.2,
                        width: double.infinity,
                        color: AppColors.lightBeige,
                      ),
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        alignment: selectedTab == 0
                            ? Alignment.centerLeft
                            : selectedTab == 1
                                ? Alignment.center
                                : Alignment.centerRight,
                        child: Container(
                          height: 2.4,
                          width: tabWidth,
                          color: AppColors.deepRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: RefreshIndicator(
                color: AppColors.deepRed,
                onRefresh: _fetchEvents,
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : (_error != null)
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.charcoal
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Center(
                                child: GestureDetector(
                                  onTap: _fetchEvents,
                                  child: const Text(
                                    "Retry",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.deepRed,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (_activeList.isEmpty)
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  _EmptyState(text: _emptyText),
                                  const SizedBox(height: 14),

                                
                                ],
                              )
                            : ListView.separated(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 18),
                                itemCount: _activeList.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final event = _activeList[index];

                                  final tag = selectedTab == 0
                                      ? "Completed"
                                      : selectedTab == 1
                                          ? "Upcoming"
                                          : "Cancelled";

                                  return _MyEventCard(
                                    imageBase64: event.mainImage,
                                    tagText: tag,
                                    title: event.title,
                                    date: _formatDate(event.eventDate),
                                    time: _formatTime(event.eventTime),
                                    onTap: () {
                                      debugPrint("Tapped event: ${event.id}");
                                    },
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightDeepRed.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 38,
          width: 38,
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: AppColors.deepRed,
          ),
        ),
      ),
    );
  }
}

class _TabText extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabText({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.8,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              color: isSelected
                  ? AppColors.deepRed
                  : AppColors.charcoal.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyEventCard extends StatelessWidget {
  final String? imageBase64;
  final String tagText;
  final String title;
  final String date;
  final String time;
  final VoidCallback onTap;

  const _MyEventCard({
    required this.imageBase64,
    required this.tagText,
    required this.title,
    required this.date,
    required this.time,
    required this.onTap,
  });

  ImageProvider _getImageProvider() {
    if (imageBase64 == null || imageBase64!.isEmpty) {
      return const AssetImage("assets/images/cycling_1.png");
    }

    try {
      final raw = imageBase64!;
      final cleaned = raw.contains("base64,")
          ? raw.split("base64,").last
          : raw;

      final bytes = base64Decode(cleaned);
      return MemoryImage(bytes);
    } catch (_) {
      return const AssetImage("assets/images/cycling_1.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 131,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.fromLTRB(10, 10, 24.834, 10),
            decoration: BoxDecoration(
              color: AppColors.buttonGuest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 111,
                    width: 110,
                    color: AppColors.lightBeige,
                    child: Image(
                      image: _getImageProvider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            tagText,
                            style: const TextStyle(
                              fontSize: 10.8,
                              fontWeight: FontWeight.w900,
                              color: AppColors.charcoal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 14,
                              color: AppColors.charcoal.withValues(alpha: 0.55),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.6,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.charcoal
                                      .withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.charcoal.withValues(alpha: 0.55),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 11.6,
                                fontWeight: FontWeight.w800,
                                color: AppColors.charcoal
                                    .withValues(alpha: 0.55),
                              ),
                            ),
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
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.charcoal.withValues(alpha: 0.50),
          ),
        ),
      ),
    );
  }
}
