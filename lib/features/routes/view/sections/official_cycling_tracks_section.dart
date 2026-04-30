import 'package:adcc/features/routes/view/official_cycling_track_page.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../route_details/view/route_details_screen.dart';
import 'dart:ui';

class OfficialCyclingTracksSection extends StatefulWidget {
  const OfficialCyclingTracksSection({super.key});

  @override
  State<OfficialCyclingTracksSection> createState() =>
      _OfficialCyclingTracksSectionState();
}

class _OfficialCyclingTracksSectionState
    extends State<OfficialCyclingTracksSection> {
  final ScrollController _scrollController = ScrollController();
  final TracksService _tracksService = TracksService();
  late Future<List<TrackModel>> _futureTracks;

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      SectionHeader(
  title: 'Official Cycling Tracks',
  showViewAll: true,
  onViewAll: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OfficialCyclingTracksPage(),
      ),
    );
  },
),


        const SizedBox(height:20),


        SizedBox(
          height: 303,
          child: FutureBuilder<List<TrackModel>>(
            future: _futureTracks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load tracks'));
              }

              final tracks = snapshot.data ?? [];

              if (tracks.isEmpty) {
                return const Center(child: Text('No tracks found'));
              }

              return ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: (tracks.length / 2).ceil(),
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;

                  return Row(
                    children: [
                      _buildTrackCard(
                        context: context,
                        track: tracks[firstIndex],
                      ),
                      if (secondIndex < tracks.length) ...[
                        const SizedBox(width: 12),
                        _buildTrackCard(
                          context: context,
                          track: tracks[secondIndex],
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackCard({
    required BuildContext context,
    required TrackModel track,
  }) {
    final imagePath = track.image.isNotEmpty
        ? track.image
        : 'assets/images/cycling_1.png';
    final tag = track.trackType.isNotEmpty ? track.trackType : 'Track';
    final title = track.title;
    final date = track.city;
    final time = '${track.distance ?? 0} km';
    final riders = track.status;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 169,
        height: 303,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.cardLightBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    imagePath,
                    width:157,
                    height: 155,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/cycling_1.png',
                        width: 157,
                        height: 155,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                 Positioned(
  top: 12,
  left: 12,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
        decoration: BoxDecoration(
          color: const Color(0x54000000), // black 33%
          borderRadius: BorderRadius.circular(6),
        ),
       child: Text(
  tag,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33, // 16 / 12
    letterSpacing: 0,
    color: Color(0xFFFFF4E3),
  ),
),
      ),
    ),
  ),
)
                ],
              ),
            ),

            const SizedBox(height: 6),

           Expanded(
  child: Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Text(
  title,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                        const SizedBox(height: 8),
              
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                 Text(
  date,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
const SizedBox(height: 2),
Text(
  time,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
  riders,
  textAlign: TextAlign.right,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),
                            ),
                          ],
                        ),
                      ],
                    ),
                const SizedBox(height: 15),
                    Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 93,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
              builder: (context) => RouteDetailsScreen(
                routeData: {
                  "id": track.id,
                  "title": track.title,
                  "description": track.description,
                  "image": track.image,
                  "city": track.city,
                  "address": track.address,
                  "zipcode": track.zipcode,
                  "distance": track.distance,
                  "elevation": track.elevation,
                  "type": track.type,
                  "avgtime": track.avgtime,
                  "pace": track.pace,
                  "facilities": track.facilities,
                  "status": track.status,
                  "difficulty": track.difficulty,
                  "country": track.country,
                  "helmetRequired": track.helmetRequired,
                  "nightRidingAllowed": track.nightRidingAllowed,
                  "slug": track.slug,
                  "trackType": track.trackType,
                  "visibility": track.visibility,
                  "surfaceType": track.surfaceType,
                },
              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRed,
                      foregroundColor: Colors.white,
              
                     
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
              
                
                      
              
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.12),
                      ),
              
              
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0, 
                    ),
                    child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
  'View Tracks',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFFFFF4E3),
  ),
),
              ),
                  ),
                ),
              )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
