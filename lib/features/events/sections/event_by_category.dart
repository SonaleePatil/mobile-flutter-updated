import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:flutter/material.dart';

class EventsByCategoryViewAll extends StatefulWidget {
  final List<Event> events;
  final String? initialCategory; 
  const EventsByCategoryViewAll({
    super.key,
    required this.events,
     this.initialCategory,
  });

  @override
  State<EventsByCategoryViewAll> createState() =>
      _EventsByCategoryViewAllState();
}

class _EventsByCategoryViewAllState extends State<EventsByCategoryViewAll> {
  int selectedCategoryIndex = 0;
  String _searchQuery = '';

  final List<String> categories = const [
    "Races",
    "Community Rides",
    "Training & Clinics",
    "Awareness Rides",
    "Family & Kids",
    "Corporate",
  ];
@override
void initState() {
  super.initState();

  if (widget.initialCategory != null) {
    final index = categories.indexWhere(
      (c) => c.toLowerCase() == widget.initialCategory!.toLowerCase(),
    );

    if (index != -1) {
      selectedCategoryIndex = index;
    }
  }
}

 String _derivedCategory(Event e) {
  final title = e.title.toLowerCase();
  final desc = (e.description ?? '').toLowerCase();

  if (title.contains("race") ||
      title.contains("series") ||
      desc.contains("race")) {
    return "Races";
  }

  if (title.contains("training") ||
      title.contains("clinic") ||
      desc.contains("training") ||
      desc.contains("clinic")) {
    return "Training & Clinics";
  }

  if (title.contains("awareness") ||
      desc.contains("awareness")) {
    return "Awareness Rides";
  }

  if (title.contains("family") ||
      title.contains("kids") ||
      desc.contains("family") ||
      desc.contains("kids")) {
    return "Family & Kids";
  }

  if (title.contains("corporate") ||
      desc.contains("corporate")) {
    return "Corporate";
  }

return e.category ?? "Community Rides";
}

  /// Badge text ko screenshot ke hisab se short banaya
  String _badgeText(String category) {
    final t = category.toLowerCase();

    if (t.contains("race")) return "Race";
    if (t.contains("community")) return "Ride";
    if (t.contains("training")) return "Training";

    return "Event";
  }

  String _getImagePath(Event event) {
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return "assets/images/cycling_1.png";
  }

  String _formatParticipants(Event event) {
    return '${event.currentParticipants ?? 0}${event.maxParticipants != null ? '/${event.maxParticipants}' : ''} riders';
  }

List<Event> get _filteredEvents {
  final selectedCategory = categories[selectedCategoryIndex];
List<Event> list = widget.events.where((e) {
  final cat = (e.category ?? '').toLowerCase().trim();
  final selected = selectedCategory.toLowerCase().trim();
  return cat == selected;
}).toList();
  if (_searchQuery.trim().isNotEmpty) {
    final q = _searchQuery.toLowerCase();

    list = list.where((e) {
      final title = e.title.toLowerCase();
      final desc = (e.description ?? '').toLowerCase();
      final address = (e.address ?? '').toLowerCase();

      return title.contains(q) ||
          desc.contains(q) ||
          address.contains(q);
    }).toList();
  }

  return list;
}

  @override
  Widget build(BuildContext context) {
    final list = _filteredEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EF),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          children: [
            /// Header Banner
            BannerHeadder(
              imagePath: 'assets/images/cycling_1.png',
              title: 'Events by Category',
              subtitle:
                  'Competitive cycling events organized by ADCC communities',
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 16),

            /// Category Pills
            CategorySelector(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() => selectedCategoryIndex = index);
              },
            ),

            const SizedBox(height: 16),

          
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    "No events found",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              )
            else
              ...List.generate(list.length, (index) {
                final e = list[index];
                final derivedCategory = _derivedCategory(e);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: SpecialRideCard(
                    /// Full width in list screen
                    width: double.infinity,

                    /// Image
                    imagePath: _getImagePath(e),

                    /// Top-left badge
                    eventType: _badgeText(derivedCategory),

                    /// Chips row
                    city: "Abu Dhabi",
                    groupName: e.createdBy?['name']?.toString() ??
                        e.createdBy?['groupName']?.toString(),

                    /// Title + Info
                    title: e.title,
                    date: e.formattedDate ?? "TBD",
                    time: e.eventTime ?? "5:30 AM",
                    distance: e.additionalData?['distance']?.toString() ??
                        e.additionalData?['routeDistance']?.toString() ??
                        "—",
                    location: e.address ?? "Abu Dhabi",
                    venue: e.additionalData?['venue']?.toString() ??
                        e.additionalData?['circuit']?.toString() ??
                        "Yas Marina Circuit",
                    riders: _formatParticipants(e),

                    eventId: e.id,

                    /// Share
                    onShare: () {
                      debugPrint("Share tapped: ${e.id}");
                    },

                    /// Tap anywhere
                    onTap: () {
                      if (e.id.isEmpty) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailsScreen(eventId: e.id),
                        ),
                      );
                    },

               
                    onOpen: () {
                      if (e.id.isEmpty) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailsScreen(eventId: e.id),
                        ),
                      );
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
