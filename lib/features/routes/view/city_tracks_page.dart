import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:adcc/shared/widgets/track_card.dart';

class CityTracksPage extends StatefulWidget {
  final String cityName;

  const CityTracksPage({
    super.key,
    required this.cityName,
  });

  @override
  State<CityTracksPage> createState() =>
      _CityTracksPageState();
}

class _CityTracksPageState
    extends State<CityTracksPage> {
  final TracksService _tracksService =
      TracksService();

  late Future<List<TrackModel>>
      _futureTracks;

  int selectedFilterIndex = 0;

  final List<String> filters = const [
    'All',
    'Open',
    'Limited',
    'Closed'
  ];

  @override
  void initState() {
    super.initState();
    _futureTracks =
        _tracksService.getAllTracks();
  }


  List<TrackModel> _applyFilters(
      List<TrackModel> tracks) {
    return tracks.where((t) {

      final cityMatch = t.city
          .toLowerCase()
          .trim() ==
          widget.cityName
              .toLowerCase()
              .trim();

   
      final statusMatch =
          selectedFilterIndex == 0 ||
              t.status.toLowerCase() ==
                  filters[selectedFilterIndex]
                      .toLowerCase();

      return cityMatch && statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: AppColors.softCream,
      body: SafeArea(
        child:
            FutureBuilder<List<TrackModel>>(
          future: _futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                      "Failed to load tracks"));
            }

            final allTracks =
                snapshot.data ?? [];

            final tracks =
                _applyFilters(allTracks);

            return ListView(
              physics:
                  const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(
                      16, 24, 16, 20),
              children: [
                const SizedBox(height: 6),

                BannerHeadder(
                  imagePath:
                      'assets/images/cycling_1.png',
                  title:
                      'Cycling Tracks in ${widget.cityName}',
                  subtitle:
                      'Explore official and community cycling tracks across ${widget.cityName}',
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
                      selectedFilterIndex =
                          index;
                    });
                  },
                ),

                const SizedBox(height: 35),

             
                Text(
                  '${tracks.length} communities found',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                    color:
                        AppColors.charcoal,
                  ),
                ),

                const SizedBox(height: 24),

            
                if (tracks.isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.only(
                            top: 40),
                    child: Center(
                      child: Text(
                        "No tracks found",
                        style: TextStyle(
                            fontSize: 14),
                      ),
                    ),
                  ),

        
                ...tracks.map(
                  (t) => Padding(
                    padding:
                        const EdgeInsets.only(
                            bottom: 14),
                    child: TrackCard(
                      width:
                          double.infinity,
                      height: 281,
                      imagePath:
                          t.image,
                      title: t.title,
                      city: t.city,
                      distance:
                          "${t.distance ?? 0} km",
                      subtitle:
                          "${t.trackType} • ${t.surfaceType} • ${t.facilities.join(", ")}",
                      difficulty:
                          t.difficulty,
                      status:
                          t.status,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RouteDetailsScreen(
                              routeData: {
                                "id": t.id,
                                "title":
                                    t.title,
                                "description":
                                    t.description,
                                "image":
                                    t.image,
                                "city":
                                    t.city,
                                "address":
                                    t.address,
                                "zipcode":
                                    t.zipcode,
                                "distance":
                                    t.distance,
                                "elevation":
                                    t.elevation,
                                "type":
                                    t.type,
                                "avgtime":
                                    t.avgtime,
                                "pace":
                                    t.pace,
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
                                "slug":
                                    t.slug,
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
                  ),
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}