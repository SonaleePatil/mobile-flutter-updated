import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/event_details/view/sections/bike_question_card.dart';
import 'package:adcc/features/event_details/view/sections/event_facilities_section.dart';
import 'package:adcc/features/event_details/view/sections/event_image_banner.dart';
import 'package:adcc/features/event_details/view/sections/event_info.dart';
import 'package:adcc/features/event_details/view/sections/event_quick_info.dart';
import 'package:adcc/features/event_details/view/sections/event_rewards_section.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/features/events/view/cancel_registration.dart';
import 'package:adcc/features/events/view/join_event.dart';
import 'package:adcc/features/events/view/your_registered_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
bool isRegistered = false;
bool isStatusLoading = true;
bool isLoading = false;
Event? _event;
final EventsService _eventsService = EventsService();
@override
void initState() {
  super.initState();
  _checkMemberStatus();
    _fetchEventDetails();  
}
Future<void> _checkMemberStatus() async {
  setState(() => isStatusLoading = true);

  final result = await _eventsService.getMemberStatus(
    eventId: widget.eventId,
  );

  if (!mounted) return;

  if (result.success) {
    setState(() {
      isRegistered = result.data ?? false;
      isStatusLoading = false;
    });
  } else {
    setState(() {
      isRegistered = false;
      isStatusLoading = false;
    });
  }
}
Future<void> _fetchEventDetails() async {

  print("Event ID: ${widget.eventId}");

  final result = await _eventsService.getEventById(widget.eventId);

  if (!mounted) return;

  if (result.success && result.data != null) {
  setState(() {
    _event = result.data;
  });

  final prettyJson = const JsonEncoder.withIndent('  ')
      .convert(_event!.additionalData);
  debugPrint(prettyJson, wrapWidth: 1024);

}
}
String _getScheduleTime(int index) {
  if (_event?.schedule != null &&
      _event!.schedule!.length > index) {
    return _event!.schedule![index]["time"] ?? "00:00";
  }
  return "00:00";
}
List<Map<String, dynamic>> _buildFacilities() {
  if (_event?.amenities == null || _event!.amenities!.isEmpty) {
    return [];
  }


  final Map<String, String> iconMap = {
    "water": "assets/icons/water.png",
    "toilets": "assets/icons/toilets.png",
    "parking": "assets/icons/parking.png",
    "medical": "assets/icons/light.png",
    "first aid": "assets/icons/light.png",
    "food": "assets/icons/food.png",
  };

  return _event!.amenities!.map<Map<String, dynamic>>((amenity) {
    final key = amenity.toString().toLowerCase();

    return {
      "icon": iconMap[key] ?? "assets/icons/light.png", 
      "label": _capitalize(key),
    };
  }).toList();
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}


String _getScheduleTitle(int index) {
  if (_event?.schedule != null &&
      _event!.schedule!.length > index) {
    return _event!.schedule![index]["title"] ?? "-";
  }
  return "-";
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 22),
          children: [
       EventImageBanner(
  base64Image: _event?.mainImage,
  imagePath: 'assets/images/cycling_1.png',
  onBackTap: () => Navigator.pop(context),
),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                 _event?.title ?? "Loading...",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: AppColors.deepRed,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                         color: Color(0XFF1A1C20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Positioned(
  left: 12,
  top: 40, 
  child: Container(
    height: 20,
    padding: const EdgeInsets.fromLTRB(11, 4, 11, 3),
    decoration: BoxDecoration(
      color: const Color(0x54C12D32), 
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Center(
      child: Text(
        "AED 200",
        style: TextStyle(
          fontSize: 9.9,
          fontWeight: FontWeight.w600,
          height: 1,
          color: Color(0xFFC12D32),
        ),
      ),
    ),
  ),
),
                    ],
                  ),
                  const SizedBox(height: 6),
             SizedBox(
  width: 337,
  child: Text(
    _event?.description ?? "Loading description...",
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontFamily: 'Outfit', 
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.35, 
      letterSpacing: 0, 
      color: Color(0XFF1A1C20),
    ),
  ),
),         ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children:  [
                  Expanded(
                    child: _SmallInfoCard(
imagePath: "assets/icons/clock.png",
  title: "Type",
  value: _event?.category ?? "-",
),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child:_SmallInfoCard(
 imagePath: "assets/icons/clock.png",
  title: "Community",
  value: _event?.city ?? "-",
),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children:  [
                  Expanded(
                    child: _SmallInfoCard(
imagePath: "assets/icons/clock.png",
  title: "City",
  value: _event?.city ?? "-",
),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child:_SmallInfoCard(
imagePath: "assets/icons/clock.png",
  title: "Total",
  value: _event?.participantsString ?? "-",
),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

EventQuickInfoSection(event: _event),


          
            const SizedBox(height: 30),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: Text(
    "Organized By",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  ),
),

const SizedBox(height: 10),


Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.lightBeige, width: 1.0),
    ),
    child: Row(
      children: [
        /// Icon
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.dustyRose,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.directions_bike,
            color: AppColors.charcoal,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        /// Community Name
        Expanded(
          child: Text(
            "Abu Dhabi Road Races\nCommunity",
            style: TextStyle(
              fontSize: 12.5,
              height: 1.2,
              fontWeight: FontWeight.w900,
              color: AppColors.charcoal,
            ),
          ),
        ),

        const SizedBox(width: 10),

       
        SizedBox(
          height: 34,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "View Community",
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),

            const SizedBox(height: 30),

           

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                "Event Schedule",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 10),

           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: Row(
    children: [
      Expanded(
        child: _ScheduleCard(
          time: _getScheduleTime(0),
          label: _getScheduleTitle(0),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _ScheduleCard(
          time: _getScheduleTime(1),
          label: _getScheduleTitle(1),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _ScheduleCard(
          time: _getScheduleTime(2),
          label: _getScheduleTitle(2),
        ),
      ),
    ],
  ),
),
            const SizedBox(height: 30),

           

          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: EventFacilitiesSection(
  facilities: _buildFacilities(),
),
),


            const SizedBox(height: 30),

          EventInfo(event: _event),


            const SizedBox(height: 30),
const BikeQuestionCard(),

const SizedBox(height: 30),
         const EventRewardSection(
  rewards: [
    EventRewardItem(
      iconPath: "assets/icons/award1.png",
      label: "300 Points",
    ),
    EventRewardItem(
      iconPath: "assets/icons/award1.png",
      label: "Night Race...",
    ),
  ],
),

            const SizedBox(height: 30),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: AppColors.lightBeige,
        width: 1,
      ),
    ),
    child: Row(
      children: [
        /// Left icon box
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Image.asset(
              "assets/icons/bike.jpg", 
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Title + subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Participants Preview",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 3),
           Text(
  _event == null
      ? "Loading..."
      : "${_event!.currentParticipants ?? 0} riders registered",
  style: TextStyle(
    fontSize: 11.2,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal.withValues(alpha: 0.60),
  ),
),
          ],
        ),
      ],
    ),
  ),
),


            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JoinEvent(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.deepRed,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "View Past Result",
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    ),
    const SizedBox(width: 8),

    Image.asset(
      "assets/icons/arrow_right.png", 
      width: 18,
      height: 18,
      fit: BoxFit.contain,
      color: Colors.white, 
    ),
  ],
),
  ),
),

                  const SizedBox(height: 12),
SizedBox(
  width: double.infinity,
  height: 52,
  child: isStatusLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : !isRegistered
          ? ElevatedButton(
            onPressed: isLoading
    ? null
    : () async {
        setState(() => isLoading = true);

        final result = await _eventsService.joinEvent(
          eventId: widget.eventId,
        );

        setState(() => isLoading = false);

        if (!context.mounted) return;

        if (result.success) {
      
          await _checkMemberStatus();

     
await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => RegistrationSuccessScreen(
      eventTitle: _event?.title ?? "",
      eventLocationLine: _event?.address ?? "",
      date: _event?.eventDate ?? "",
      location: _event?.city ?? "",
      type: _event?.category ?? "",
      community: _event?.city ?? "", 
      eventImagePath: "assets/images/cycling_1.png",
      redArcImagePath: "assets/images/frame_1.png",
    ),
  ),
);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? "Registration failed"),
            ),
          );
        }
      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isLoading ? "Please wait..." : "Registration",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            )
          : OutlinedButton(
             onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CancelRegistrationScreen(
        eventId: widget.eventId,
      ),
    ),
  );

  if (!mounted) return;

  if (result == true) {
  
    await _checkMemberStatus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cancelled successfully")),
    );
  }
},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.deepRed,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isLoading ? "Please wait..." : "Cancel Registration",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.deepRed,
                ),
              ),
            ),
),

                ],
              ),
            ),

            const SizedBox(height: 12),
            const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  height: 52,
  child: OutlinedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JoinEvent(),
        ),
      );
    },
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: AppColors.deepRed,
        width: 1.4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    child: const Text(
      "Join Event",
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: AppColors.deepRed,
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
class _SmallInfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;

  const _SmallInfoCard({
    required this.imagePath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardLightBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.lightBeige,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Row(
            children: [
              Image.asset(
                imagePath,
                width: 14,   
                height: 14,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.7,
                height: 1.15,
                fontWeight: FontWeight.w900,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _ScheduleCard extends StatelessWidget {
  final String time;
  final String label;

  const _ScheduleCard({required this.time, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warmSand,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color:Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
           color:Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


