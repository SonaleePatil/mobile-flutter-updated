import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/event_details/view/sections/event_header_section.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/sections/event_by_category.dart';
import 'package:adcc/features/events/sections/event_categories_grid.dart';
import 'package:adcc/features/events/sections/purpose_based_event_card.dart';
import 'package:adcc/features/events/sections/upcoming_event_screen.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  int selectedCategoryIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';

  List<Event> _events = [];
  final EventsService _eventsService = EventsService();

  final List<String> categories = [
    'All',
    'Races',
    'Community Rides',
    'Training & Clinics',
   
  ];

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

  if (title.contains("community") ||
      title.contains("ride") ||
      desc.contains("community")) {
    return "Community Rides";
  }

  return "Community Rides";
}
  static final List<Map<String, String>> _purposeBasedEvents = [
    {
      'imagePath': 'assets/images/ride_events.png',
      'title': 'UAE National Day Community Ride',
      'date': '2 Dec 2026',
      'groupName': 'Abu Dhabi Road Racers',
    },
    {
      'imagePath': 'assets/images/community_ride.png',
      'title': 'Cycling for a Cause',
      'date': '15 Dec 2026',
      'groupName': 'Dubai Cycling Club',
    },
    {
      'imagePath': 'assets/images/cycling_1.png',
      'title': 'Charity Ride 2026',
      'date': '20 Dec 2026',
      'groupName': 'Yas Island Riders',
    },
    {
      'imagePath': 'assets/images/family-rides.png',
      'title': 'Family Fun Ride',
      'date': '25 Dec 2026',
      'groupName': 'Family Cycling Group',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _eventsService.getEvents();

    if (!mounted) return;

    setState(() {
      _isLoading = false;

      if (response.success && response.data != null && response.data!.isNotEmpty) {
        _events = response.data!;
        _errorMessage = null;
        debugPrint('Loaded ${_events.length} events successfully');
      } else {
        _errorMessage = response.message ?? 'Failed to load events';
        _events = [];
        debugPrint('Error loading events: $_errorMessage');
        debugPrint('Response success: ${response.success}');
        debugPrint('Response data: ${response.data}');
      }
    });
  }

  /// Local filter (API me category nahi aa rahi)
  List<Event> get _filteredEvents {
    List<Event> list = _events;

    // 1) Category filter
    if (selectedCategoryIndex != 0) {
      final selected = categories[selectedCategoryIndex];

      list = list.where((event) {
      final eventCategory = _derivedCategory(event);
        return eventCategory.toLowerCase() == selected.toLowerCase();
      }).toList();
    }

    // 2) Search filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();

      list = list.where((event) {
        final title = event.title.toLowerCase();
        final desc = (event.description ?? '').toLowerCase();
        final address = (event.address ?? '').toLowerCase();

        return title.contains(q) || desc.contains(q) || address.contains(q);
      }).toList();
    }

    return list;
  }

  String _getImagePath(Event event) {
   
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return 'assets/images/ride_events.png';
  }

  String _formatParticipants(Event event) {
    return '${event.currentParticipants ?? 0}${event.maxParticipants != null ? '/${event.maxParticipants}' : ''} riders';
  }

  void _applyCategoryFilterFromGrid(String categoryTitle) {
    // Grid titles are different: Races, Community Rides, Training & Clinics...
    // API me category nahi, so hum local mapping use karenge.

    String mapped = 'All';

    final t = categoryTitle.toLowerCase();

    if (t.contains('community')) mapped = 'Community Rides';
    if (t.contains('family')) mapped = 'Family & Kids';
    if (t.contains('kids')) mapped = 'Family & Kids';
    if (t.contains('shop')) mapped = 'Shop';

    final index = categories.indexWhere(
      (c) => c.toLowerCase() == mapped.toLowerCase(),
    );

    setState(() {
      selectedCategoryIndex = index == -1 ? 0 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsToShow = _filteredEvents;

    // Convert filtered events to the format expected by the UI
    final List<Map<String, String>> rides = eventsToShow.map((event) {
      return {
        "image": _getImagePath(event),
        "title": event.title,
        "date": event.formattedDate ?? "TBD",
        "distance": event.address ?? "N/A",
        "riders": _formatParticipants(event),
        "eventId": event.id,
      };
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null && rides.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadEvents,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        children: [
                         

                        EventHeader(
  imagePath: 'assets/images/cycling_1.png',
  title: 'Events & Community Rides',
  subtitle:
      'Official cycling events organized by ADCC communities across the UAE',
  wantSearchBar: true,
  searchValue: _searchQuery,
  onChangeHandler: (value) {
    setState(() {
      _searchQuery = value;
    });
  },
  placeholder: 'Search events, communities, cities, or tracks...',
),


                          const SizedBox(height: 35),

                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: CategorySelector(
                              categories: categories,
                              selectedIndex: selectedCategoryIndex,
                              onSelected: (index) {
                                setState(() {
                                  selectedCategoryIndex = index;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 50),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SectionHeader(
  title: 'Upcoming Events',
  onViewAll: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Upcomingevent(
          events: _filteredEvents, 
        ),
      ),
    );
  },
),

                              ),
                              const SizedBox(height: 24),

                              rides.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                        ),
                                      child: Center(
                                        child: Text(
                                          'No events available',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height:
                                          319, 
                                          width: 365,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                        ),
                                        itemCount: rides.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(width: 6),
                                        itemBuilder: (context, index) {
                                          final event = eventsToShow[index];

                                          return SpecialRideCard(
                                            imagePath: _getImagePath(event),
                                            title: event.title,
                                            date: event.formattedDate ?? "TBD",
                                            time: event.eventTime,
                                            distance: event.additionalData?['distance']
                                                    ?.toString() ??
                                                event.additionalData?['routeDistance']
                                                    ?.toString(),
                                            location: event.address,
                                            venue: event.additionalData?['venue']
                                                    ?.toString() ??
                                                event.additionalData?['circuit']
                                                    ?.toString(),
                                            riders: _formatParticipants(event),
                                          eventType: _derivedCategory(event),
                                            groupName: event.createdBy?['name']
                                                    ?.toString() ??
                                                event.createdBy?['groupName']
                                                    ?.toString(),
                                            eventId: event.id,
                                            onShare: () {
                                              debugPrint('Share tapped');
                                            },
                                            onOpen: () {
                                              if (event.id.isNotEmpty) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        EventDetailsScreen(
                                                      eventId: event.id,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),

                          const SizedBox(height: 50),

                      
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SectionHeader(
  title: 'Events by Category',
  onViewAll: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventsByCategoryViewAll(
          events: _events, 
        ),
      ),
    );
  },
),

                              ),
                              const SizedBox(height: 19),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: EventCategoriesGrid(
  onCategoryTap: (category) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventsByCategoryViewAll(
          events: _events,
          initialCategory: category,
        ),
      ),
    );

  },
)
                              ),
                            ],
                          ),

                          const SizedBox(height: 50),

                         
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SectionHeader(
                                  title: 'Purpose Based Events',
                                  onViewAll: () {
                                    debugPrint(
                                        'View all purpose based events');
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                height: 320, // Match card height
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(
                                    left: 11,
                                  ),
                                  itemCount: _purposeBasedEvents.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 6),
                                  itemBuilder: (context, index) {
                                    final event = _purposeBasedEvents[index];
                                    return PurposeBasedEventCard(
                                      imagePath: event['imagePath']!,
                                      title: event['title']!,
                                      date: event['date']!,
                                      groupName: event['groupName']!,
                                      onTap: () {
                                        debugPrint(
                                            'Tapped on ${event['title']}');
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
