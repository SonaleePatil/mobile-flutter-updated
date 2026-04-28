import 'package:adcc/features/route_details/view/sections/route_communities_section.dart';
import 'package:adcc/features/route_details/view/sections/route_events_section.dart';
import 'package:adcc/features/routes/Models/event_model.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'sections/route_header_section.dart';
import 'sections/route_title_section.dart';
import 'sections/route_description_section.dart';
import 'sections/route_details_grid_section.dart';
import 'sections/route_facilities_section.dart';
import 'sections/route_safety_section.dart';
import 'sections/route_photos_section.dart';
import 'sections/route_action_buttons_section.dart';

class RouteDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;

  const RouteDetailsScreen({
    super.key,
    required this.routeData,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final TracksService _tracksService = TracksService();

  TrackModel? _track;
  bool _isLoadingTrack = false;

  List<EventModel> _trackEvents = [];
  bool _isLoadingEvents = false;

  @override
  void initState() {
    super.initState();
    _loadTrackDetails();
    _loadTrackEvents();
  }

  Future<void> _loadTrackDetails() async {
    final trackId =
        widget.routeData['id']?.toString() ??
        widget.routeData['_id']?.toString();

    if (trackId == null || trackId.isEmpty) return;

    setState(() => _isLoadingTrack = true);

    try {
      final track = await _tracksService.getTrackById(trackId);
      if (mounted) {
        setState(() {
          _track = track;
          _isLoadingTrack = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTrack = false);
      }
    }
  }

  Future<void> _loadTrackEvents() async {
    final trackId =
        widget.routeData['id']?.toString() ??
        widget.routeData['_id']?.toString();

    if (trackId == null || trackId.isEmpty) return;

    setState(() => _isLoadingEvents = true);

    try {
      final events =
          await _tracksService.getTrackRelatedEvents(trackId);

      if (mounted) {
        setState(() {
          _trackEvents = events;
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingEvents = false);
      }
    }
  }

  String _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'water':
        return 'assets/icons/water.png';
      case 'toilets':
        return 'assets/icons/toilets.png';
      case 'parking':
        return 'assets/icons/parking.png';
      case 'cafes':
        return 'assets/icons/cafe.png';
      case 'lights':
        return 'assets/icons/light.png';
      default:
        return 'assets/icons/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
  
    if (_isLoadingTrack || _track == null) {
      return const Scaffold(
        backgroundColor: AppColors.softCream,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC12D32),
          ),
        ),
      );
    }

    final routeDetails = {
      'Distance': "${_track!.distance ?? 0} km",
      'Elevation': _track!.elevation,
      'Type': _track!.type,
      'Avg Time': _track!.avgtime,
      'Pace': _track!.pace,
    };

    final facilities = _track!.facilities
        .map((facility) => {
              "icon": _getFacilityIcon(facility),
              "label": facility,
            })
        .toList();

    final List<String> photos = [];

    if (_track!.galleryImages.isNotEmpty) {
      photos.addAll(_track!.galleryImages);
    } else if (_track!.image.isNotEmpty) {
      photos.add(_track!.image);
    }

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            RouteHeaderSection(
              imagePath: _track!.image,
              onBack: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),

            const SizedBox(height: 16),

            RouteTitleSection(
              title: _track!.title,
              status: _track!.status,
              onShare: () {},
            ),

            const SizedBox(height: 9),

            RouteDescriptionSection(
              description: _track!.description,
            ),

            const SizedBox(height: 24),

            RouteDetailsGridSection(routeDetails: routeDetails),

            const SizedBox(height: 50),

            RouteFacilitiesSection(facilities: facilities),

            const SizedBox(height: 30),

            RouteActionButtonsSection(
              onOpenLinkMyRide: () {},
              onOpenMaps: () {},
            ),

            const SizedBox(height: 50),

            RoutePhotosSection(photoPaths: photos),

            const SizedBox(height: 24),

            _buildEventsSection(),

            const SizedBox(height: 24),

            RouteCommunitiesSection(
              trackId: _track!.id,
            ),

            const SizedBox(height: 24),

            RouteSafetySection(
              safetyMessage: _track!.safetyNotes,
              helmetRequired: _track!.helmetRequired,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsSection() {
    if (_isLoadingEvents) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC12D32),
          ),
        ),
      );
    }

    if (_trackEvents.isEmpty) return const SizedBox.shrink();

    return RouteEventsSection(events: _trackEvents);
  }
}