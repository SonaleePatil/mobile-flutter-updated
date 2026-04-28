import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
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

  int selectedFilterIndex = 0;

  final List<String> filters = const ['All', 'Open', 'Limited', 'Closed'];

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilter(List<TrackModel> tracks) {
    if (selectedFilterIndex == 0) return tracks;

    final selectedStatus = filters[selectedFilterIndex];

    return tracks
        .where((t) =>
            t.status.toLowerCase() ==
            selectedStatus.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: FutureBuilder<List<TrackModel>>(
          future: _futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
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
              padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 20),
              children: [
                BannerHeadder(
                  imagePath:
                      'assets/images/cycling_1.png',
                  title: 'Track Near You',
                  subtitle:
                      'Cycling tracks closest to your current location',
                  onBackTap: () =>
                      Navigator.pop(context),
                ),

                const SizedBox(height: 21),

                CategorySelector(
                  categories: filters,
                  selectedIndex:
                      selectedFilterIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedFilterIndex = index;
                    });
                  },
                ),

                const SizedBox(height: 35),

                Text(
                  '${tracks.length} communities found',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.charcoal,
                  ),
                ),

                const SizedBox(height: 24),

                if (tracks.isEmpty)
                  const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 40),
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
                    padding:
                        const EdgeInsets.only(
                            bottom: 14),
                    child: TrackCard(
                      width: double.infinity,
                      height: 281,
                      imagePath: t.image,
                      title: t.title,
                      city: t.city,
                      distance:
                          "${t.distance ?? 0} km",
                      subtitle: subtitle,
                      difficulty:
                          t.difficulty,
                      status: t.status,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RouteDetailsScreen(
                              routeData: {
                                "id": t.id,
                                "title": t.title,
                                "description":
                                    t.description,
                                "image": t.image,
                                "city": t.city,
                                "address":
                                    t.address,
                                "zipcode":
                                    t.zipcode,
                                "distance":
                                    t.distance,
                                "elevation":
                                    t.elevation,
                                "type": t.type,
                                "avgtime":
                                    t.avgtime,
                                "pace": t.pace,
                                "facilities":
                                    t.facilities,
                                "status":
                                    t.status,
                                "difficulty":
                                    t.difficulty,
                                "country":
                                    t.country,
                                "helmetRequired":
                                    t.helmetRequired,
                                "nightRidingAllowed":
                                    t.nightRidingAllowed,
                                "slug": t.slug,
                                "trackType":
                                    t.trackType,
                                "visibility":
                                    t.visibility,
                                "surfaceType":
                                    t.surfaceType,
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