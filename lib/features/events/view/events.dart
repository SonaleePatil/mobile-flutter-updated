import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/sections/purpose_based_event_card.dart';
import 'package:adcc/features/events/sections/upcoming_event_screen.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
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
    'Awareness Rides',
    'Family & Kids',
    'Corporate',
  ];

  // ── Category icons mapping ────────────────────────────────────────────────
  static const Map<String, String> _categoryAssets = {
    'races': 'assets/icons/ra.png',
    'community rides': 'assets/icons/cf.png',
    'training & clinics': 'assets/icons/tc.png',
    'awareness rides': 'assets/icons/awareness.png',
    'family & kids': 'assets/icons/cf.png',
    'corporate': 'assets/icons/tc.png',
    'all': 'assets/icons/add_calendar.png',
  };

  String _derivedCategory(Event e) {
    final text =
        '${e.category ?? ''} ${e.title} ${e.description ?? ''} ${e.city ?? ''}'
            .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['race', 'racing', 'series', 'competition', 'championship'])) {
      return 'Races';
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop', 'session'])) {
      return 'Training & Clinics';
    }
    if (hasAny(['awareness', 'cause', 'charity', 'campaign', 'fundraiser'])) {
      return 'Awareness Rides';
    }
    if (hasAny(['family', 'kid', 'kids', 'children', 'youth', 'junior'])) {
      return 'Family & Kids';
    }
    if (hasAny([
      'corporate',
      'company',
      'business',
      'enterprise',
      'team building',
      'teambuilding',
    ])) {
      return 'Corporate';
    }
    if (hasAny(['community', 'ride', 'social', 'group ride', 'club ride'])) {
      return 'Community Rides';
    }
    return 'Community Rides';
  }

  List<Event> get _purposeBasedEventsDynamic {
    const purposeKeywords = [
      'community',
      'charity',
      'cause',
      'family',
      'kids',
    ];
    final filtered = _events.where((e) {
      final text = '${e.title} ${e.description ?? ''}'.toLowerCase();
      return purposeKeywords.any(text.contains);
    }).toList();
    return filtered.isNotEmpty ? filtered : _events;
  }

  List<Event> get _filteredEvents {
    List<Event> list = _events;
    if (selectedCategoryIndex != 0) {
      final selected = categories[selectedCategoryIndex].toLowerCase();
      list = list
          .where((e) => _derivedCategory(e).toLowerCase() == selected)
          .toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              (e.description ?? '').toLowerCase().contains(q) ||
              (e.address ?? '').toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

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
      if (response.success &&
          response.data != null &&
          response.data!.isNotEmpty) {
        _events = response.data!;
      } else {
        _errorMessage = response.message ?? 'Failed to load events';
        _events = [];
      }
    });
  }

  String _getImagePath(Event event) {
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return 'assets/images/ride_events.png';
  }

  String _formatParticipants(Event event) => '${event.currentParticipants ?? 0}'
      '${event.maxParticipants != null ? '/${event.maxParticipants}' : ''}'
      ' riders';

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final eventsToShow = _filteredEvents;
    final purposeEvents = _purposeBasedEventsDynamic;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (_errorMessage != null && eventsToShow.isEmpty)
                    ? _buildErrorState()
                    : _buildContent(eventsToShow, purposeEvents),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEvents,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<Event> eventsToShow, List<Event> purposeEvents) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ── Top section (header + search + categories) ──────────────────
        _EventsTopSection(
          title: 'Events',
          searchValue: _searchQuery,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          categories: categories,
          selectedIndex: selectedCategoryIndex,
          onCategorySelected: (i) => setState(
              () => selectedCategoryIndex = selectedCategoryIndex == i ? 0 : i),
          categoryAssets: _categoryAssets,
        ),

        const SizedBox(height: 33),

        // ── Upcoming Events ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: 'Upcoming Events',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Upcomingevent(events: _filteredEvents),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        eventsToShow.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    'No events available',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 15),
                  ),
                ),
              )
            : SizedBox(
                height: 319,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: eventsToShow.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final event = eventsToShow[i];
                    return SpecialRideCard(
                      imagePath: _getImagePath(event),
                      title: event.title,
                      date: event.formattedDate ?? 'TBD',
                      time: event.eventTime,
                      distance: event.additionalData?['distance']?.toString() ??
                          event.additionalData?['routeDistance']?.toString() ??
                          event.distance?.toString(),
                      location: event.address,
                      city: event.city,
                      venue: event.additionalData?['venue']?.toString() ??
                          event.additionalData?['circuit']?.toString(),
                      riders: _formatParticipants(event),
                      eventType: _derivedCategory(event),
                      groupName: event.createdBy?['name']?.toString() ??
                          event.createdBy?['groupName']?.toString(),
                      eventId: event.id,
                      width: 358,
                      onShare: () => debugPrint('Share tapped'),
                      onOpen: () {
                        if (event.id.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(eventId: event.id),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

        const SizedBox(height: 34),

        // ── Purpose Based Events ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: 'Purpose Based Events',
            onViewAll: () => debugPrint('View all purpose based events'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: purposeEvents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final event = purposeEvents[i];
              return PurposeBasedEventCard(
                imagePath: _getImagePath(event),
                title: event.title,
                date: event.formattedDate ?? 'TBD',
                groupName: event.createdBy?['name']?.toString() ??
                    event.createdBy?['groupName']?.toString() ??
                    'ADCC Community',
                onTap: () {
                  if (event.id.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(eventId: event.id),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Top Section
// ────────────────────────────────────────────────────────────────────────────

class _EventsTopSection extends StatefulWidget {
  final String title;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final Map<String, String> categoryAssets;

  const _EventsTopSection({
    required this.title,
    required this.searchValue,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.categoryAssets,
  });

  @override
  State<_EventsTopSection> createState() => _EventsTopSectionState();
}

class _EventsTopSectionState extends State<_EventsTopSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(covariant _EventsTopSection old) {
    super.didUpdateWidget(old);
    if (old.searchValue != widget.searchValue &&
        _controller.text != widget.searchValue) {
      _controller.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 357,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 289,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.8362, 1.0],
                colors: [
                  Color(0xFF5262EF),
                  Color(0xFF5262EF),
                  Colors.white,
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 36,
            child: SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 158,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.fromLTRB(11, 7, 12, 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.21),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.28),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: widget.onSearchChanged,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText:
                                'Search events, communities, cities, or tracks...',
                            hintStyle: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 216,
            child: Container(
              height: 136,
              padding: const EdgeInsets.fromLTRB(12, 16, 0, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1.16,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: _CategoryGrid(
                categories: widget.categories,
                selectedIndex: widget.selectedIndex,
                onSelected: widget.onCategorySelected,
                categoryAssets: widget.categoryAssets,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Category rail
// ────────────────────────────────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Map<String, String> categoryAssets;

  const _CategoryGrid({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    required this.categoryAssets,
  });

  String _labelFor(String category) => switch (category) {
        'Awareness Rides' => 'Awareness\nRides',
        'Training & Clinics' => 'Training &\nClinics',
        'Community Rides' => 'Community\nRides',
        'Family & Kids' => 'Family &\nKids',
        _ => category,
      };

  String _assetFor(String category) =>
      categoryAssets[category.toLowerCase()] ?? 'assets/icons/ra.png';

  @override
  Widget build(BuildContext context) {
    final visibleIndices = [
      for (int i = 0; i < categories.length; i++)
        if (categories[i].toLowerCase() != 'all') i,
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: visibleIndices.length,
      separatorBuilder: (_, __) => const SizedBox(width: 5),
      itemBuilder: (context, index) {
        final categoryIndex = visibleIndices[index];
        final isSelected = categoryIndex == selectedIndex;
        final category = categories[categoryIndex];

        return GestureDetector(
          onTap: () => onSelected(categoryIndex),
          child: AnimatedContainer(
            width: 74.4,
            height: 101.5,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFF1F5F9)
                  : const Color(0x123F6DB2),
              borderRadius: BorderRadius.circular(7),
              border: isSelected
                  ? Border.all(color: const Color(0xFF5262EF), width: 1)
                  : Border.all(color: Colors.transparent, width: 1),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: Center(
                    child: Text(
                      _labelFor(category),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11.37,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: Color(0xFF484A4D),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                    child: Image.asset(
                      _assetFor(category),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
