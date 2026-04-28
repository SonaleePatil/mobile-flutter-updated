import 'package:adcc/core/utils/response_parser.dart';

class FeedPostModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String status;
  final bool reported;

  const FeedPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reported,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Feed Post'),
      description: ResponseParser.asString(json['description'] ?? json['body'], fallback: ''),
      image: ResponseParser.asString(json['image'] ?? json['mainImage'], fallback: 'assets/images/cycling_1.png'),
      status: ResponseParser.asString(json['status'], fallback: 'pending'),
      reported: ResponseParser.asBool(json['reported']),
    );
  }
}
