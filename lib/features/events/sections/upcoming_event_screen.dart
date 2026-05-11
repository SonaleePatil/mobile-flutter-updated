import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:flutter/material.dart';

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

  final List<_UpcomingCategory> categories = const [
    _UpcomingCategory(
      label: 'Races',
      filter: 'Races',
      imagePath: 'assets/images/racing.png',
    ),
    _UpcomingCategory(
      label: 'Community\nRides',
      filter: 'Community Rides',
      imagePath: 'assets/images/community_ride.png',
    ),
    _UpcomingCategory(
      label: 'Training &\nClinics',
      filter: 'Training & Clinics',
      imagePath: 'assets/images/bike_experience.png',
    ),
    _UpcomingCategory(
      label: 'Awareness\nRides',
      filter: 'Awareness Rides',
      imagePath: 'assets/images/community_ride1.png',
    ),
    _UpcomingCategory(
      label: 'Corporate\nEvents',
      filter: 'Corporate Events',
      imagePath: 'assets/images/cycling_1.png',
    ),
    _UpcomingCategory(
      label: 'National\nEvents',
      filter: 'National Events',
      imagePath: 'assets/images/events.png',
    ),
  ];

  String _getImagePath(Event event) {
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return 'assets/images/cycling_1.png';
  }

  String _formatParticipants(Event event) {
    return '${event.currentParticipants ?? 0}'
        '${event.maxParticipants != null ? '/${event.maxParticipants}' : ''}'
        ' riders';
  }

  String _derivedCategory(Event e) {
    final text =
        '${e.category ?? ''} ${e.title} ${e.description ?? ''} ${e.city ?? ''}'
            .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['national', 'uae national', 'flag'])) {
      return 'National Events';
    }
    if (hasAny([
      'corporate',
      'company',
      'business',
      'enterprise',
      'team building',
      'teambuilding',
    ])) {
      return 'Corporate Events';
    }
    if (hasAny(['awareness', 'cause', 'charity', 'campaign', 'fundraiser'])) {
      return 'Awareness Rides';
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop', 'session'])) {
      return 'Training & Clinics';
    }
    if (hasAny(['race', 'racing', 'series', 'competition', 'championship'])) {
      return 'Races';
    }
    return 'Community Rides';
  }

  String _badgeLabel(Event event) {
    switch (_derivedCategory(event)) {
      case 'Races':
        return 'Race';
      case 'Community Rides':
        return 'Community Ride';
      case 'Awareness Rides':
        return 'Awareness';
      case 'Training & Clinics':
        return 'Community Ride';
      case 'Corporate Events':
        return 'Corporate';
      case 'National Events':
        return 'National';
      default:
        return _derivedCategory(event);
    }
  }

  List<Event> get _filteredEvents {
    if (widget.events.isEmpty) return const [];

    final selected = categories[selectedCategoryIndex].filter;
    final filtered =
        widget.events.where((e) => _derivedCategory(e) == selected).toList();
    return filtered.isNotEmpty ? filtered : widget.events;
  }

  void _openEvent(Event event) {
    if (event.id.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: event.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredEvents;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
          children: [
            const _UpcomingHero(),
            const SizedBox(height: 30),
            _UpcomingCategoryRail(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() => selectedCategoryIndex = index);
              },
            ),
            const SizedBox(height: 27),
            Text(
              '${list.length} communities found',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 17),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    'No events found',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              )
            else
              ...List.generate(list.length, (index) {
                final event = list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SpecialRideCard(
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
                    eventType: _badgeLabel(event),
                    groupName: event.createdBy?['name']?.toString() ??
                        event.createdBy?['groupName']?.toString(),
                    eventId: event.id,
                    width: double.infinity,
                    badgeColor: const Color(0xFF5262EF),
                    badgeTextColor: const Color(0xFFFFF4E3),
                    shareBackgroundColor: const Color(0xFF5262EF),
                    shareIconColor: Colors.white,
                    onShare: () => debugPrint('Share tapped: ${event.id}'),
                    onOpen: () => _openEvent(event),
                    onTap: () => _openEvent(event),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _UpcomingHero extends StatelessWidget {
  const _UpcomingHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 299,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/cycling_1.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF7BCBC),
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.black38),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black,
                    ],
                    stops: const [0, 0.72, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 18,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF5262EF),
                    size: 18,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 45,
              child: Text(
                'Upcoming Events',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.11,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 28,
              child: Text(
                'Competitive cycling events organized by ADCC communities',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingCategory {
  final String label;
  final String filter;
  final String imagePath;

  const _UpcomingCategory({
    required this.label,
    required this.filter,
    required this.imagePath,
  });
}

class _UpcomingCategoryRail extends StatelessWidget {
  final List<_UpcomingCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _UpcomingCategoryRail({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 74,
              height: 118,
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 6),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFF1F5F9)
                    : const Color(0x123F6DB2),
                borderRadius: BorderRadius.circular(7),
                border: selected
                    ? Border.all(color: const Color(0xFF5262EF), width: 1)
                    : null,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 64,
                      height: 75,
                      child: Image.asset(
                        category.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE5E7EB),
                          child: const Icon(
                            Icons.image,
                            size: 16,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Center(
                      child: Text(
                        category.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11.37,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: Color(0xFF484A4D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
