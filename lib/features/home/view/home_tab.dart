import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/home/view/horizontal_rideList.dart';
import 'package:adcc/features/home/viewmodels/home_view_model.dart';
import 'package:adcc/features/home/view/join_community_card.dart';
import 'package:adcc/features/home/view/near_by_track.dart';
import 'package:adcc/features/home/view/quick_actions_section.dart';
import 'package:adcc/features/home/view/community_updates_section.dart';
import 'package:adcc/features/home/view/promo_carousel.dart';
import 'package:adcc/features/home/view/random_card.dart';
import 'package:adcc/features/home/view/recently_posted_section.dart.dart';
import 'package:adcc/features/home/view/ride_info_section.dart';
import 'package:adcc/features/home/view/upcoming_tracks_list.dart';
import 'package:adcc/features/home/view/weather_screen.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'section/profile_header.dart';

// class HomeTab extends StatefulWidget {
//   final ValueChanged<int>? onTabChange;

//   const HomeTab({super.key, this.onTabChange});

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

class HomeTab extends StatefulWidget {
  final ValueChanged<int>? onTabChange;
  final bool fromGuest;

  const HomeTab({
    super.key,
    this.onTabChange,
    this.fromGuest = false,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeViewModel _viewModel = HomeViewModel();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    _viewModel.loadHome();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await TokenStorageService.getUserName();
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _goToEvent(String eventId) {
    if (eventId.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feed = _viewModel.feed;
    final isLoading = _viewModel.isLoading;
    final error = _viewModel.error;

    final featured = feed?.featuredEvent;
    final featuredTitle = featured?.title ?? 'Bike4 Abu Dhabi Gran Fondo 2025';
    final featuredDate = featured?.date ?? '21 Dec 2026';
    final featuredDistance = featured?.distance ?? '150 Km';
    final featuredImage = featured?.image ?? 'assets/images/cycling_1.png';

    final upcomingEvents = feed?.upcomingEvents ?? const [];
    final communities = feed?.popularCommunities ?? const [];

    return SafeArea(
      child: Column(
        children: [
          ProfileHeader(
            name: widget.fromGuest
                ? 'Welcome, Guest'
                : (_userName.isNotEmpty ? _userName : ''),
            onNotificationTap: () {},
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    const SizedBox(height: 34),
                    const PromoCarousel(),
                    const SizedBox(height: 30),
                    const WeatherScreen(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child:
                          QuickActionsSection(onTabChange: widget.onTabChange),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Featured Events',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1,
                          letterSpacing: 0,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FeaturedEventCard(
                      image: featuredImage,
                      title: featuredTitle,
                      date: featuredDate,
                      distance: featuredDistance,
                      onTap: featured != null
                          ? () => _goToEvent(featured.id)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: HorizontalRideList(
                        communities: communities,
                        onCommunityTap: (id) =>
                            debugPrint('Community tapped: $id'),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(title: 'Upcoming Events'),
                    ),
                    const SizedBox(height: 22),
                    UpcomingTracksList(
                      events: upcomingEvents,
                      onEventTap: _goToEvent,
                    ),
                    const SizedBox(height: 50),
                    const NearbyTracksSection(),
                    const SizedBox(height: 52),
                    const RecentlyPost(),
                    const SizedBox(height: 50),
                    const CommunityUpdatesSection(),
                    const SizedBox(height: 24),
                    const RideInfoSection(),
                    const SizedBox(height: 24),
                    JoinCommunityCard(onJoinTap: () {}),
                  ],
                ),

                // Loading overlay on first load
                if (isLoading && feed == null)
                  const Center(child: CircularProgressIndicator()),

                // Error banner with retry (only when no cached data)
                if (error != null && feed == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load feed',
                            style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _viewModel.loadHome,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
