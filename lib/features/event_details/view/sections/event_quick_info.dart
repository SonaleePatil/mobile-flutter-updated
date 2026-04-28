import 'package:flutter/material.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';

class EventQuickInfoSection extends StatelessWidget {
  final Event? event;

  const EventQuickInfoSection({
    super.key,
    required this.event,
  });

  String _formatDistance() {
    if (event?.distance == null) return "-";
    return "${event!.distance} km";
  }

  String _formatMinAge() {
    if (event?.minAge == null) return "-";
    return "${event!.minAge}+";
  }

  String _formatRegistration() {
    if (event == null) return "-";

    if (event!.status == "upcoming") return "Open";
    if (event!.status == "ongoing") return "Live";
    if (event!.status == "completed") return "Closed";

    return event!.status?.capitalize() ?? "-";
  }

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Info",
            style: TextStyle(
              fontSize:16 ,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _PillInfo(
                      title: "Date",
                      value: event!.formattedDate ?? "-",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillInfo(
                      title: "Time",
                      value: event!.eventTime ?? "-",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillInfo(
                      title: "Distance",
                      value: _formatDistance(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _PillInfo(
                      title: "Min Age",
                      value: _formatMinAge(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillInfo(
                      title: "Segment",
                      value: event!.difficulty ?? "-",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillInfo(
                      title: "Registration",
                      value: _formatRegistration(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillInfo extends StatelessWidget {
  final String title;
  final String value;

  const _PillInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBeige, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.charcoal.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.7,
              fontWeight: FontWeight.w900,
              color: AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}


extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}