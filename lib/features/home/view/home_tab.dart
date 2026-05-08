import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/home/view/horizontal_rideList.dart';
import 'package:adcc/features/home/viewmodels/home_view_model.dart';
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
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 47,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8E5FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF0F0F0)),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 14),
                            Icon(
                              Icons.search,
                              size: 20,
                              color: Color(0xA6191A1C),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    PromoCarousel(
                      items: promoItems,
                      showFallback: false,
                    ),
                    const SizedBox(height: 28),
                    const WeatherScreen(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: QuickActionsSection(
                        onTabChange: widget.onTabChange,
                        fromGuest: widget.fromGuest,
                        onGuestRestrictedTap: _redirectGuestToLogin,
                      ),
                    ),
                    const SizedBox(height: 30),
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
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: HorizontalRideList(
                        communities: communities,
                        showFallback: false,
                        onCommunityTap: (id) {
                          if (widget.fromGuest) {
                            _redirectGuestToLogin();
                            return;
                          }
                          debugPrint('Community tapped: $id');
                        },
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
                      showFallback: false,
                    ),
                    const SizedBox(height: 50),
                    NearbyTracksSection(
                      tracks: feed?.nearbyTracks ?? const [],
                      showFallback: false,
                    ),
                    const SizedBox(height: 52),
                    RecentlyPost(
                      items: feed?.recentItems ?? const [],
                      showFallback: false,
                    ),
                    // const SizedBox(height: 50),
                    // const CommunityUpdatesSection(),
                    const SizedBox(height: 24),
                    RideInfoSection(
                      rideInfos: feed?.rideInfos ?? const [],
                      sectionTitle:
                          feed?.rideInfoSectionTitle ?? 'Ride in Abu Dhabi',
                      showFallback: false,
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
