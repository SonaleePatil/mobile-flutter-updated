import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/home/view/horizontal_rideList.dart';
import 'package:adcc/features/home/viewmodels/home_view_model.dart';
import 'package:adcc/features/home/view/community_updates_section.dart';
import 'package:adcc/features/home/view/join_community_card.dart';
import 'package:adcc/features/home/view/near_by_track.dart';
import 'package:adcc/features/home/view/quick_actions_section.dart';
import 'package:adcc/features/home/view/promo_carousel.dart';
import 'package:adcc/features/home/view/promo_card.dart';
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

  void _redirectGuestToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feed = _viewModel.feed;
    final isLoading = _viewModel.isLoading;
    final error = _viewModel.error;

    final featured = feed?.featuredEvent;

    final upcomingEvents = feed?.upcomingEvents ?? const [];
    final communities = feed?.popularCommunities ?? const [];
    final promoItems = (feed?.promoBanners ?? const [])
        .map(
          (e) => PromoData(
            image: e.image,
            title: e.title,
            subtitle: e.subtitle,
            highlight: e.highlight,
            buttonText: e.buttonText,
          ),
        )
        .toList();

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
                  padding: const EdgeInsets.only(bottom: 34),
                  children: [
                    const SizedBox(height: 12),
                    const _SearchWeatherBar(),
                    const SizedBox(height: 24),
                    PromoCarousel(
                      items: promoItems,
                      showFallback: true,
                    ),
                    const SizedBox(height: 26),
                    const WeatherScreen(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: QuickActionsSection(
                        onTabChange: widget.onTabChange,
                        fromGuest: widget.fromGuest,
                        onGuestRestrictedTap: _redirectGuestToLogin,
                      ),
                    ),
                    const SizedBox(height: 40),
                    HorizontalRideList(
                      communities: communities,
                      showFallback: true,
                      onCommunityTap: (id) {
                        if (widget.fromGuest) {
                          _redirectGuestToLogin();
                          return;
                        }
                        debugPrint('Community tapped: $id');
                      },
                    ),
                    const SizedBox(height: 40),
                    if (featured != null) ...[
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
                        image: featured.image,
                        title: featured.title,
                        date: featured.date,
                        distance: featured.distance,
                        onTap: () => _goToEvent(featured.id),
                      ),
                    ] else ...[
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
                        image: 'assets/images/night-ride.png',
                        title: 'Abu Dhabi Night Race Series',
                        date: '18 July 2026',
                        distance: '42 km',
                        onTap: () {},
                      ),
                    ],
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(title: 'Upcoming Events'),
                    ),
                    const SizedBox(height: 22),
                    UpcomingTracksList(
                      events: upcomingEvents,
                      onEventTap: _goToEvent,
                      showFallback: true,
                    ),
                    const SizedBox(height: 40),
                    NearbyTracksSection(
                      tracks: feed?.nearbyTracks ?? const [],
                      showFallback: true,
                    ),
                    const SizedBox(height: 40),
                    RecentlyPost(
                      items: feed?.recentItems ?? const [],
                      showFallback: true,
                    ),
                    const SizedBox(height: 40),
                    CommunityUpdatesSection(
                      updates: feed?.communityUpdates ?? const [],
                      showFallback: true,
                    ),
                    const SizedBox(height: 40),
                    RideInfoSection(
                      rideInfos: feed?.rideInfos ?? const [],
                      sectionTitle:
                          feed?.rideInfoSectionTitle ?? 'Ride in Abu Dhabi',
                      showFallback: true,
                    ),
                    const SizedBox(height: 24),
                    JoinCommunityCard(
                      onJoinTap: () {
                        if (widget.fromGuest) {
                          _redirectGuestToLogin();
                        }
                      },
                    ),
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
                          const Text(
                            'Could not load feed',
                            style: TextStyle(
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

class _SearchWeatherBar extends StatelessWidget {
  const _SearchWeatherBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => debugPrint('Search clicked'),
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E5FB),
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Image.asset(
            'assets/images/weather_cloud.png',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 2),
          const Text(
            '20℃',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
