import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideFeedScreen extends StatelessWidget {
  const RideFeedScreen({super.key});

  static const List<_RideFeedPost> _posts = [
    _RideFeedPost(
      author: 'Sara Al Ketbi',
      location: 'Dubai',
      timeAgo: '2h ago',
      imagePath: 'assets/images/route_preview.png',
      likes: '24 likes',
      caption: 'Sara Al Ketbi Amazing ride today!...',
    ),
    _RideFeedPost(
      author: 'Sara Al Ketbi',
      location: 'Dubai',
      timeAgo: '2h ago',
      imagePath: 'assets/images/ride_events.png',
      likes: '24 likes',
      caption: 'SheRides Weekend Success!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.softCream,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.softCream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _RideFeedHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: 25)),
              const SliverToBoxAdapter(child: _RideFeedHeroCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: _posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    return _RidePostCard(post: _posts[index]);
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RideFeedHeader extends StatelessWidget {
  const _RideFeedHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 28,
            top: 23,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: AppColors.deepRed.withValues(alpha: 0.36),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.deepRed,
                  size: 16,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 27,
            child: Text(
              'Ride Feed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.deepRed,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideFeedHeroCard extends StatelessWidget {
  const _RideFeedHeroCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/community_ride.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.goldenOchre.withValues(alpha: 0.68),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.goldenOchre,
                      AppColors.goldenOchre.withValues(alpha: 0.86),
                      AppColors.goldenOchre.withValues(alpha: 0.1),
                    ],
                    stops: const [0, 0.48, 1],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 39, 17, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 238,
                      child: Text(
                        'Join the Abu Dhabi\nCycling Community!',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 23.22,
                          fontWeight: FontWeight.w600,
                          height: 1.18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 112,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.softCream,
                        borderRadius: BorderRadius.circular(17.3),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Share Your Ride',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: AppColors.deepRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RidePostCard extends StatelessWidget {
  final _RideFeedPost post;

  const _RidePostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 433,
      decoration: BoxDecoration(
        color: AppColors.buttonGuest,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(post: post),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.4),
            child: SizedBox(
              height: 255,
              width: double.infinity,
              child: Image.asset(
                post.imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(height: 13),
          const _PostActions(),
          const SizedBox(height: 5),
          Text(
            post.likes,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 8,
              fontWeight: FontWeight.w400,
              height: 1.25,
              color: Color(0xFF121E3F),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            post.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final _RideFeedPost post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.goldenOchre,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_sara.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.28,
                  color: Color(0xFF3C3C3B),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '${post.location}  •  ${post.timeAgo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.8,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.more_horiz,
          color: Color(0xFF544179),
          size: 22,
        ),
      ],
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.favorite, color: AppColors.deepRed, size: 18),
        SizedBox(width: 16),
        Icon(Icons.chat_bubble_outline, color: Color(0xFF3C3C3B), size: 18),
        SizedBox(width: 16),
        Icon(Icons.send_outlined, color: Color(0xFF3C3C3B), size: 18),
      ],
    );
  }
}

class _RideFeedPost {
  final String author;
  final String location;
  final String timeAgo;
  final String imagePath;
  final String likes;
  final String caption;

  const _RideFeedPost({
    required this.author,
    required this.location,
    required this.timeAgo,
    required this.imagePath,
    required this.likes,
    required this.caption,
  });
}
