import 'package:adcc/core/utils/response_parser.dart';

class HomeEventModel {
  final String id;
  final String image;
  final String title;
  final String date;
  final String distance;
  final String type;

  const HomeEventModel({
    required this.id,
    required this.image,
    required this.title,
    required this.date,
    required this.distance,
    required this.type,
  });

  factory HomeEventModel.fromJson(Map<String, dynamic> json) {
    return HomeEventModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      image: ResponseParser.asString(
        json['mainImage'] ?? json['eventImage'] ?? json['image'],
        fallback: 'assets/images/cycling_1.png',
      ),
      title: ResponseParser.asString(json['title'], fallback: 'Upcoming Event'),
      date: ResponseParser.asString(json['eventDate'] ?? json['date'], fallback: 'TBD'),
      distance: ResponseParser.asString(
        json['distance'],
        fallback: 'N/A',
      ),
      type: ResponseParser.asString(json['category'] ?? json['type'], fallback: 'Social'),
    );
  }
}

class HomeCommunityModel {
  final String id;
  final String title;
  final String image;
  final int members;

  const HomeCommunityModel({
    required this.id,
    required this.title,
    required this.image,
    required this.members,
  });

  factory HomeCommunityModel.fromJson(Map<String, dynamic> json) {
    return HomeCommunityModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'] ?? json['name'], fallback: 'Community'),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'],
        fallback: 'assets/images/family_ride.png',
      ),
      members: ResponseParser.asInt(
        json['membersCount'] ?? json['members'] ?? json['communityMembersCount'],
      ),
    );
  }
}

class HomeFeedModel {
  final HomeEventModel? featuredEvent;
  final List<HomeEventModel> upcomingEvents;
  final List<HomeCommunityModel> popularCommunities;

  const HomeFeedModel({
    required this.featuredEvent,
    required this.upcomingEvents,
    required this.popularCommunities,
  });
}
