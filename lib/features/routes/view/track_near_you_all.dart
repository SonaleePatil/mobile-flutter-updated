import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/Models/track_model.dart';

class TrackNearAllPage extends StatefulWidget {
  const TrackNearAllPage({super.key});

  @override
  State<TrackNearAllPage> createState() => _TrackNearAllPageState();
}

class _TrackNearAllPageState extends State<TrackNearAllPage> {
  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  int selectedFilterIndex = -1;

  final List<String> filters = const [
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Fullgas',
    'Yasi',
    'Saraab',
  ];

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilter(List<TrackModel> tracks) {
    if (selectedFilterIndex < 0) return tracks;

    final selectedCity = filters[selectedFilterIndex];
    return tracks
        .where((t) =>
            t.city.toLowerCase().trim() == selectedCity.toLowerCase().trim())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<TrackModel>>(
          future: _futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Failed to load tracks"),
              );
            }

            final allTracks = snapshot.data ?? [];
            final tracks = _applyFilter(allTracks);

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              children: [
                const _TracksNearHero(),
                const SizedBox(height: 30),
                _NearbyCityStrip(
                  categories: filters,
                  selectedIndex: selectedFilterIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedFilterIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  '${tracks.length} communities found',
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 17),
                if (tracks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No tracks found",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ...tracks.map((t) {
                  final subtitle =
                      "${t.trackType} • ${t.surfaceType} • ${t.facilities.join(", ")}";

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TrackCard(
                      width: double.infinity,
                      height: 374,
                      routeMapStyle: true,
                      imagePath: t.image,
                      title: t.title,
                      city: t.city,
                      distance: "${t.distance ?? 0} km",
                      subtitle: subtitle,
                      difficulty: t.difficulty,
                      status: t.status,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RouteDetailsScreen(
                              routeData: {
                                "id": t.id,
                                "title": t.title,
                                "description": t.description,
                                "image": t.image,
                                "city": t.city,
                                "address": t.address,
                                "zipcode": t.zipcode,
                                "distance": t.distance,
                                "elevation": t.elevation,
                                "type": t.type,
                                "avgtime": t.avgtime,
                                "pace": t.pace,
                                "facilities": t.facilities,
                                "status": t.status,
                                "difficulty": t.difficulty,
                                "country": t.country,
                                "helmetRequired": t.helmetRequired,
                                "nightRidingAllowed": t.nightRidingAllowed,
                                "slug": t.slug,
                                "trackType": t.trackType,
                                "visibility": t.visibility,
                                "surfaceType": t.surfaceType,
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TracksNearHero extends StatelessWidget {
  const _TracksNearHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 299,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/cycling_1.png',
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .02),
                      Colors.black.withValues(alpha: .72),
                    ],
                    stops: const [.58, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Color(0xFFF09902),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 27,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tracks Near You",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 20.1125,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Cycling tracks closest to your current location",
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyCityStrip extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _NearbyCityStrip({
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
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFF09902).withValues(alpha: .07),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color:
                      selected ? const Color(0xFFF09902) : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        index.isEven
                            ? 'assets/images/track.png'
                            : 'assets/images/cycling_1.png',
                        width: 64,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    categories[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 11.375,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: Color(0xFF484A4D),
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
