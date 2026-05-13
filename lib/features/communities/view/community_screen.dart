import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/features/communities/view/view_all_communities_screen.dart';
import 'package:adcc/features/communities/view/view_all_communities_type.dart';
import 'package:adcc/features/communities/view/view_all_purpose_based.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;

  final CommunitiesService _communitiesService = CommunitiesService();

  List<CommunityModel> _cityCommunities = [];
  List<CommunityModel> _groupCommunities = [];

  List<CommunityModel> _allCommunities = [];

  final List<String> filterPills = const [
    'All',
    'Abu Dhabi',
    'Al Ain',
    'Western Region',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllSections();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _communitiesService.getCityCommunities(),
        _communitiesService.getGroupCommunities(),
        _communitiesService.getAwarenessCommunities(),
      ]);

      if (!mounted) return;

      List<CommunityModel> parse(dynamic resData) {
        final raw = resData;

        List<dynamic> communitiesList = [];

        if (raw is Map<String, dynamic>) {
          if (raw['data'] is Map &&
              (raw['data'] as Map).containsKey('communities') &&
              (raw['data'] as Map)['communities'] is List) {
            communitiesList = (raw['data'] as Map)['communities'] as List;
          } else if (raw['communities'] is List) {
            communitiesList = raw['communities'] as List;
          }
        } else if (raw is List) {
          communitiesList = raw;
        }

        return communitiesList
            .whereType<Map<String, dynamic>>()
            .map((e) => CommunityModel.fromJson(e))
            .toList();
      }

      final cityRes = results[0];
      final groupRes = results[1];
      final awarenessRes = results[2];

      if (!cityRes.success || !groupRes.success || !awarenessRes.success) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load communities";
        });
        return;
      }

      final cityList = parse(cityRes.data);
      final groupList = parse(groupRes.data);
      final awarenessList = parse(awarenessRes.data);

      setState(() {
        _isLoading = false;

        _cityCommunities = cityList;
        _groupCommunities = groupList;

        _allCommunities = [
          ...cityList,
          ...groupList,
          ...awarenessList,
        ];

        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = "Unexpected error: $e";
      });
    }
  }

  List<String> get _backendTypes {
    final set = <String>{};

    for (final c in _allCommunities) {
      final t = c.type.trim();
      if (t.isNotEmpty) set.add(t);
    }

    final list = set.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<CommunityModel> _applySearch(List<CommunityModel> input) {
    if (searchQuery.trim().isEmpty) return input;

    final q = searchQuery.trim().toLowerCase();

    return input.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.category.any((cat) => cat.toLowerCase().contains(q)) ||
          c.type.toLowerCase().contains(q) ||
          (c.location ?? '').toLowerCase().contains(q) ||
          (c.trackName ?? '').toLowerCase().contains(q) ||
          (c.terrain ?? '').toLowerCase().contains(q) ||
          (c.distance?.toString() ?? '').contains(q);
    }).toList();
  }

  List<CommunityModel> _applyCityPills(List<CommunityModel> input) {
    if (selectedFilterIndex == 0) return input;

    final selected = filterPills[selectedFilterIndex].toLowerCase();

    return input.where((c) {
      return (c.location ?? '').toLowerCase().contains(selected);
    }).toList();
  }

  List<CommunityModel> get _filteredCityCommunities =>
      _applySearch(_applyCityPills(_cityCommunities));

  List<CommunityModel> get _filteredGroupCommunities =>
      _applySearch(_groupCommunities);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: _isLoading
            ? const _CommunitiesLoadingUI()
            : (_errorMessage != null
                ? _CommunitiesErrorUI(
                    message: _errorMessage!,
                    onRetry: _loadAllSections,
                  )
                : _buildMainUI(context)),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _CommunitiesTopBlock(
          searchValue: searchQuery,
          onSearchChanged: (value) => setState(() => searchQuery = value),
          types: _displayTypes,
          onTypeTap: _openTypeCommunities,
        ),
        const SizedBox(height: 32),
        _SectionTitleRow(
          title: 'Communities in Your City',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllCommunitiesScreen(
                  title: 'Communities in Your City',
                  communities: _filteredCityCommunities,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        _CityCommunitiesCarousel(
          communities: _displayCityCommunities,
          onExplore: (community) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityCityDetails(community: community),
              ),
            );
          },
        ),
        const SizedBox(height: 47),
        _SectionTitleRow(
          title: 'Purpose-Based Communities',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllPurposeCommunitiesScreen(
                  title: "Purpose-Based Communities",
                  communities: _filteredGroupCommunities,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 25),
        _buildGroupCommunitiesSection(),
        const SizedBox(height: 105),
      ],
    );
  }

  Widget _buildGroupCommunitiesSection() {
    final groupCommunities = _displayPurposeCommunities;

    if (groupCommunities.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No community groups found',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 218,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: groupCommunities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final community = groupCommunities[index];

          return _PurposeCommunityCard(
            community: community,
            accentColor:
                index == 0 ? const Color(0xFFD6F6FF) : const Color(0xFFE7E4DB),
            foregroundColor: index == 0 ? Colors.black : Colors.white,
            buttonColor:
                index == 0 ? const Color(0xFF02A1CE) : const Color(0xFFFFF5F3),
            buttonTextColor:
                index == 0 ? Colors.black : const Color(0xFF0359E8),
            onExplore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityCityDetails(community: community),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<CommunityModel> get _displayCityCommunities {
    final filtered = _filteredCityCommunities;
    return filtered.isNotEmpty ? filtered : _fallbackCityCommunities;
  }

  List<CommunityModel> get _displayPurposeCommunities {
    final filtered = _filteredGroupCommunities;
    return filtered.isNotEmpty ? filtered : _fallbackPurposeCommunities;
  }

  List<String> get _displayTypes {
    final types = <String>[..._communityTypeStripDefaults];
    final seen = types.map(_normalizeTypeLabel).toSet();

    for (final backendType in _backendTypes) {
      final normalized = _normalizeTypeLabel(backendType);
      if (normalized.isNotEmpty && seen.add(normalized)) {
        types.add(backendType);
      }
    }

    return types;
  }

  Future<void> _openTypeCommunities(String type) async {
    final localMatches = _applySearch(_allCommunities)
        .where((c) => _typeMatchesCommunity(type, c))
        .toList();

    if (localMatches.isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommunityTypeScreen(
            title: type,
            communities: localMatches,
          ),
        ),
      );
      return;
    }

    final res = await _communitiesService.getCommunitiesByType(type);
    if (!mounted) return;

    if (!res.success || res.data == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommunityTypeScreen(
            title: type,
            communities: _applySearch(_allCommunities),
          ),
        ),
      );
      return;
    }

    List<CommunityModel> list = [];
    final raw = res.data;

    if (raw is Map<String, dynamic> &&
        raw['data'] is Map &&
        (raw['data'] as Map)['communities'] is List) {
      list = ((raw['data'] as Map)['communities'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => CommunityModel.fromJson(e))
          .toList();
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommunityTypeScreen(
          title: type,
          communities: list.isNotEmpty ? list : _applySearch(_allCommunities),
        ),
      ),
    );
  }

  bool _typeMatchesCommunity(String type, CommunityModel community) {
    final selected = type.toLowerCase();
    final keys = <String>{
      selected,
      if (selected.contains('elite') || selected.contains('awareness')) ...[
        'elite',
        'awareness',
        'charity',
        'national',
        'performance',
      ],
      if (selected.contains('community')) ...['community', 'group', 'ride'],
      if (selected.contains('family')) ...['family', 'leisure'],
      if (selected.contains('women') || selected.contains('she')) ...[
        'women',
        'ladies',
        'she',
      ],
      if (selected.contains('youth')) ...['youth', 'kids'],
      if (selected.contains('racing') || selected.contains('performance')) ...[
        'racing',
        'performance',
      ],
      if (selected.contains('weekend') || selected.contains('social')) ...[
        'weekend',
        'social',
      ],
      if (selected.contains('night')) 'night',
      if (selected.contains('mtb') || selected.contains('trail')) ...[
        'mtb',
        'trail',
      ],
      if (selected.contains('training') || selected.contains('clinic')) ...[
        'training',
        'clinic',
      ],
      if (selected.contains('corporate')) ...['corporate', 'partner'],
    };

    bool containsKey(String value) {
      final lower = value.toLowerCase();
      return keys.any((key) => lower.contains(key));
    }

    return containsKey(community.type) ||
        containsKey(community.title) ||
        containsKey(community.description) ||
        community.category.any(containsKey);
  }
}

class _CommunitiesTopBlock extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<String> types;
  final ValueChanged<String> onTypeTap;

  const _CommunitiesTopBlock({
    required this.searchValue,
    required this.onSearchChanged,
    required this.types,
    required this.onTypeTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 358,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _CommunitiesHero(
              searchValue: searchValue,
              onChanged: onSearchChanged,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 221,
            child: _CommunityTypeStrip(
              types: types,
              onTypeTap: onTypeTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunitiesHero extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onChanged;

  const _CommunitiesHero({
    required this.searchValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 289,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF02A1CE),
            Color(0xFF02A1CE),
            Color(0xFFFFFFFF),
          ],
          stops: [0, 0.82, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 54,
            left: 16,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 24,
                height: 24,
              ),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
          ),
          const Positioned(
            top: 58,
            left: 0,
            right: 0,
            child: Text(
              'Communities',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 124,
            child: _GlassSearchField(
              value: searchValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassSearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _GlassSearchField({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_GlassSearchField> createState() => _GlassSearchFieldState();
}

class _GlassSearchFieldState extends State<_GlassSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _GlassSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 38,
        color: Colors.white.withValues(alpha: 0.21),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Row(
          children: [
            Container(
              width: 23.5,
              height: 23.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.24),
              ),
              child: const Icon(Icons.search, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                cursorColor: Colors.white,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search events, communities, cities, or tracks...',
                  hintStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: -0.1,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityTypeStrip extends StatelessWidget {
  final List<String> types;
  final ValueChanged<String> onTypeTap;

  const _CommunityTypeStrip({
    required this.types,
    required this.onTypeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 17, 0, 17),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (context, index) {
          final type = types[index];
          return _CommunityTypeChip(
            title: type,
            imagePath: _typeImage(type),
            onTap: () => onTypeTap(type),
          );
        },
      ),
    );
  }

  static String _typeImage(String type) {
    final t = type.toLowerCase();
    if (t.contains('family')) return 'assets/images/family-rides.png';
    if (t.contains('elite') || t.contains('awareness')) {
      return 'assets/icons/awareness.png';
    }
    if (t.contains('community')) return 'assets/images/community_ride.png';
    if (t.contains('women') || t.contains('she')) {
      return 'assets/images/she-rides.png';
    }
    if (t.contains('youth')) return 'assets/images/youth.png';
    if (t.contains('race') || t.contains('performance')) {
      return 'assets/images/racing.png';
    }
    if (t.contains('night')) return 'assets/images/night-ride.png';
    if (t.contains('mtb') || t.contains('trail')) {
      return 'assets/images/mtb-ride.png';
    }
    if (t.contains('training') || t.contains('clinic')) {
      return 'assets/icons/tc.png';
    }
    if (t.contains('corporate')) return 'assets/icons/cf.png';
    return 'assets/images/community_ride.png';
  }
}

class _CommunityTypeChip extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _CommunityTypeChip({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74.38,
        height: 101.5,
        decoration: BoxDecoration(
          color: const Color(0x123F6DB2),
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 9),
        child: Column(
          children: [
            SizedBox(
              height: 29,
              child: Center(
                child: Text(
                  _compactTypeTitle(title),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.375,
                    fontWeight: FontWeight.w500,
                    height: 1.23,
                    color: Color(0xFF484A4D),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AdaptiveImage(
                imagePath: imagePath,
                fit: BoxFit.contain,
                placeholderColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _compactTypeTitle(String title) {
    final t = title.trim();
    if (t.toLowerCase().contains('women')) return 'Women\n(SheRides)';
    if (t.toLowerCase().contains('racing')) return 'Racing &\nPerformance';
    if (t.toLowerCase().contains('training')) return 'Training &\nClinics';
    if (t.toLowerCase().contains('community rides')) return 'Community\nRides';
    if (t.toLowerCase().contains('awareness')) return 'Awareness\nRides';
    return t;
  }
}

const List<String> _communityTypeStripDefaults = [
  'Family Rides',
  'Women (SheRides)',
  'Youth Cycling',
  'Racing & Performance',
  'Community Rides',
  'Awareness Rides',
  'Training & Clinics',
  'Corporate',
];

String _normalizeTypeLabel(String value) {
  final lower = value.trim().toLowerCase();
  if (lower.isEmpty) return '';
  if (lower.contains('family')) return 'family';
  if (lower.contains('women') || lower.contains('she')) return 'women';
  if (lower.contains('youth') || lower.contains('kids')) return 'youth';
  if (lower.contains('racing') || lower.contains('performance')) {
    return 'racing-performance';
  }
  if (lower.contains('elite') ||
      lower.contains('awareness') ||
      lower.contains('charity') ||
      lower.contains('national')) {
    return 'awareness-rides';
  }
  if (lower.contains('community')) return 'community-rides';
  if (lower.contains('training') || lower.contains('clinic')) {
    return 'training-clinics';
  }
  if (lower.contains('corporate')) return 'corporate';
  return lower;
}

class _SectionTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionTitleRow({
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF484A4D),
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF484A4D)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCommunitiesCarousel extends StatelessWidget {
  final List<CommunityModel> communities;
  final ValueChanged<CommunityModel> onExplore;

  const _CityCommunitiesCarousel({
    required this.communities,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'No communities found',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 363,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final community = communities[index];
          return _CityCommunityCard(
            community: community,
            onExplore: () => onExplore(community),
          );
        },
      ),
    );
  }
}

class _CityCommunityCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback onExplore;

  const _CityCommunityCard({
    required this.community,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onExplore,
      child: Container(
        width: 248,
        height: 363,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFA9907E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AdaptiveImage(
              imagePath: community.imageUrl ?? 'assets/images/cycling_1.png',
              fit: BoxFit.cover,
              placeholderColor: const Color(0xFFA9907E),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xCC000000),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 103,
              child: Text(
                community.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 73,
              child: _MetaText(
                icon: Icons.people_alt_rounded,
                text: '${_formatMembers(community.membersCount ?? 0)} Members',
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 16,
              bottom: 22,
              child: SizedBox(
                width: 143,
                height: 34,
                child: ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.1),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  child: const Text(
                    'Explore Community',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurposeCommunityCard extends StatelessWidget {
  final CommunityModel community;
  final Color accentColor;
  final Color foregroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onExplore;

  const _PurposeCommunityCard({
    required this.community,
    required this.accentColor,
    required this.foregroundColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onExplore,
      child: Container(
        width: 358,
        height: 218,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 14,
              top: 18,
              width: 170,
              child: Text(
                community.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                  color: foregroundColor,
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 116,
              child: _MetaText(
                icon: Icons.people_alt_rounded,
                text: '${_formatMembers(community.membersCount ?? 0)} members',
                color: foregroundColor,
              ),
            ),
            Positioned(
              left: 14,
              top: 141,
              child: _MetaText(
                icon: Icons.calendar_month_rounded,
                text: '${community.eventsCount ?? 0} events',
                color: foregroundColor,
              ),
            ),
            Positioned(
              left: 14,
              bottom: 15,
              child: SizedBox(
                width: 142,
                height: 29,
                child: ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.3),
                    ),
                  ),
                  child: Text(
                    'Explore Community +',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: buttonTextColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 141,
                height: 194,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AdaptiveImage(
                  imagePath:
                      community.imageUrl ?? 'assets/images/cycling_1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaText({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.23,
            color: color,
          ),
        ),
      ],
    );
  }
}

String _formatMembers(int number) {
  if (number <= 0) return '0';
  if (number >= 1000) {
    final short = number / 1000;
    if (short == short.roundToDouble()) return '${short.toInt()}K';
    return '${short.toStringAsFixed(1)}K';
  }
  return number.toString();
}

final List<CommunityModel> _fallbackCityCommunities = [
  CommunityModel(
    id: 'fallback-road-racers',
    title: 'Abu Dhabi Road Racers',
    description: 'Fast-paced city rides and weekly endurance challenges.',
    type: 'Racing & Performance',
    category: const ['City Communities'],
    imageUrl: 'assets/images/cycling_1.png',
    membersCount: 2800,
    eventsCount: 3,
  ),
  CommunityModel(
    id: 'fallback-hudayriyat',
    title: 'Hudayriyat Riders',
    description: 'Social group rides around Hudayriyat Island.',
    type: 'Weekend Social',
    category: const ['City Communities'],
    imageUrl: 'assets/images/community_ride.png',
    membersCount: 3800,
    eventsCount: 4,
  ),
  CommunityModel(
    id: 'fallback-sherides',
    title: 'SheRides Abu Dhabi',
    description: 'Women-led rides, clinics, and confidence-building events.',
    type: 'Women (SheRides)',
    category: const ['City Communities'],
    imageUrl: 'assets/images/she-rides.png',
    membersCount: 1700,
    eventsCount: 2,
  ),
  CommunityModel(
    id: 'fallback-youth',
    title: 'Youth Pedalers',
    description: 'Skills and safe group rides for young cyclists.',
    type: 'Youth Cycling',
    category: const ['City Communities'],
    imageUrl: 'assets/images/youth.png',
    membersCount: 1200,
    eventsCount: 2,
  ),
];

final List<CommunityModel> _fallbackPurposeCommunities = [
  CommunityModel(
    id: 'fallback-awareness',
    title: 'Awareness Rides Community',
    description: 'Cause-led rides supporting city-wide awareness programs.',
    type: 'Awareness',
    category: const ['Purpose-Based Communities'],
    imageUrl: 'assets/images/community_ride1.png',
    membersCount: 860,
    eventsCount: 3,
  ),
  CommunityModel(
    id: 'fallback-national',
    title: 'National Events Riders',
    description: 'Community rides around national moments and celebrations.',
    type: 'National Events',
    category: const ['Purpose-Based Communities'],
    imageUrl: 'assets/images/ride_events.png',
    membersCount: 1420,
    eventsCount: 4,
  ),
  CommunityModel(
    id: 'fallback-corporate',
    title: 'Corporate & Partners Community',
    description: 'Partner programs, team rides, and workplace cycling.',
    type: 'Corporate',
    category: const ['Purpose-Based Communities'],
    imageUrl: 'assets/images/bike_experience.png',
    membersCount: 530,
    eventsCount: 2,
  ),
];

class _CommunitiesLoadingUI extends StatelessWidget {
  const _CommunitiesLoadingUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        const SizedBox(height: 16),

        // Banner placeholder
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Section title placeholder
        Container(
          height: 18,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        // Big card placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Another section
        Container(
          height: 18,
          width: 260,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        Container(
          height: 18,
          width: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommunitiesErrorUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CommunitiesErrorUI({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenOchre,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Retry",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
