import 'package:adcc/core/utils/response_parser.dart';

class ProfilePerformanceInsights {
  final String completionRate;
  final String averageDistance;
  final String bestCategory;

  const ProfilePerformanceInsights({
    required this.completionRate,
    required this.averageDistance,
    required this.bestCategory,
  });

  factory ProfilePerformanceInsights.fromApi(Map<String, dynamic> json) {
    return ProfilePerformanceInsights(
      completionRate: ResponseParser.asString(
        json['completionRate'] ?? json['averageCompletionRate'],
        fallback: '0%',
      ),
      averageDistance: ResponseParser.asString(
        json['averageDistance'] ?? json['avgDistance'] ?? json['distance'],
        fallback: '0 km',
      ),
      bestCategory: ResponseParser.asString(
        json['bestCategory'] ?? json['category'],
        fallback: '—',
      ),
    );
  }

  static const fallback = ProfilePerformanceInsights(
    completionRate: '92%',
    averageDistance: '34.5 km',
    bestCategory: 'Community Rides',
  );
}

class ProfileEventHistoryItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final String distance;
  final String time;
  final String rank;
  final String image;

  const ProfileEventHistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.distance,
    required this.time,
    required this.rank,
    required this.image,
  });

  factory ProfileEventHistoryItem.fromApi(Map<String, dynamic> json) {
    return ProfileEventHistoryItem(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Event'),
      subtitle: ResponseParser.asString(
        json['subtitle'] ?? json['category'] ?? json['type'],
        fallback: 'Community Ride',
      ),
      date: ResponseParser.asString(
        json['date'] ?? json['eventDate'] ?? json['createdAt'],
        fallback: '—',
      ),
      status: ResponseParser.asString(json['status'], fallback: 'Completed'),
      distance: ResponseParser.asString(
        json['distance'] ?? json['distanceCovered'],
        fallback: '0 km',
      ),
      time: ResponseParser.asString(
        json['time'] ?? json['duration'],
        fallback: '—',
      ),
      rank: ResponseParser.asString(
        json['rank'] ?? json['position'] ?? json['result'],
        fallback: '—',
      ),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'] ?? json['eventImage'],
        fallback: 'assets/images/cycling_1.png',
      ),
    );
  }
}

class ProfileUpcomingEventItem {
  final String id;
  final String title;
  final String date;
  final String distance;
  final String image;

  const ProfileUpcomingEventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.distance,
    required this.image,
  });

  factory ProfileUpcomingEventItem.fromApi(Map<String, dynamic> json) {
    return ProfileUpcomingEventItem(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Upcoming event'),
      date: ResponseParser.asString(
        json['date'] ?? json['eventDate'] ?? json['startsAt'],
        fallback: '—',
      ),
      distance: ResponseParser.asString(
        json['distance'] ?? json['distanceKm'] ?? json['routeDistance'],
        fallback: '—',
      ),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'] ?? json['eventImage'],
        fallback: 'assets/images/cycling_1.png',
      ),
    );
  }
}
