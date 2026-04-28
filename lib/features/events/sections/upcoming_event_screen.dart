import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:flutter/material.dart';

import 'package:adcc/features/events/view/special_ride_card.dart';

class Upcomingevent extends StatefulWidget {
  final List<Event> events;

  const Upcomingevent({
    super.key,
    required this.events,
  });

  @override
  State<Upcomingevent> createState() => _UpcomingeventState();
}

class _UpcomingeventState extends State<Upcomingevent> {
  int selectedCategoryIndex = 0;
  String _searchQuery = '';

  final List<String> categories = const [
    "All",
    "Races",
    "Community Rides",
    "Training & Clinics",
  ];

  String _getImagePath(Event event) {
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return "assets/images/cycling_1.png";
  }

  String _formatParticipants(Event event) {
    return '${event.currentParticipants ?? 0}${event.maxParticipants != null ? '/${event.maxParticipants}' : ''} riders';
  }

  // local derived category mapping
  String _derivedCategory(Event e) {
    final title = e.title.toLowerCase();
    final desc = (e.description ?? '').toLowerCase();

    if (title.contains("race") || title.contains("series") || desc.contains("race")) {
      return "Races";
    }

    if (title.contains("training") ||
        title.contains("clinic") ||
        desc.contains("training") ||
        desc.contains("clinic")) {
      return "Training & Clinics";
    }

    if (title.contains("community") ||
        title.contains("ride") ||
        desc.contains("community")) {
      return "Community Rides";
    }

    return "Community Rides";
  }

  List<Event> get _filteredEvents {
    List<Event> list = widget.events;

    // 1) category filter
    if (selectedCategoryIndex != 0) {
      final selected = categories[selectedCategoryIndex].toLowerCase().trim();

      list = list.where((e) {
        final cat = _derivedCategory(e).toLowerCase().trim();
        return cat == selected;
      }).toList();
    }

    // 2) search filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();

      list = list.where((e) {
        final title = e.title.toLowerCase();
        final desc = (e.description ?? '').toLowerCase();
        final address = (e.address ?? '').toLowerCase();

        return title.contains(q) || desc.contains(q) || address.contains(q);
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
            BannerHeadder(
              imagePath: 'assets/images/cycling_1.png',
              title: 'Upcoming Events',
              subtitle:
                  'Competitive cycling events organized by ADCC communities',
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 21),

            // CATEGORY SELECTOR
            CategorySelector(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() => selectedCategoryIndex = index);
              },
            ),

            const SizedBox(height: 36),

         
            Text(
              "${list.length} communities found",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B6B6B),
              ),
            ),

            const SizedBox(height: 18),

            // LIST
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

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SpecialRideCard(
                    imagePath: _getImagePath(e),
                    title: e.title,
                    date: e.formattedDate ?? "TBD",

                
                    time: e.eventTime,
                    distance: e.additionalData?['distance']?.toString() ??
                        e.additionalData?['routeDistance']?.toString(),
                    location: e.address,
                    venue: e.additionalData?['venue']?.toString() ??
                        e.additionalData?['circuit']?.toString(),

                  eventType: _derivedCategory(e),

           
                    groupName: e.createdBy?['name']?.toString() ??
                        e.createdBy?['groupName']?.toString(),

                    eventId: e.id,

                    width: 364,

                    onShare: () {
                      debugPrint("Share tapped: ${e.id}");
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

                  
                    onTap: () {
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
