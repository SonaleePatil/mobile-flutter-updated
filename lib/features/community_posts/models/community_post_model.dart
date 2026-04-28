import 'package:adcc/core/utils/response_parser.dart';

class CommunityPostModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String status;
  final bool reported;

  const CommunityPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reported,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Post'),
      description: ResponseParser.asString(json['description'] ?? json['body'], fallback: ''),
      image: ResponseParser.asString(json['image'] ?? json['mainImage'], fallback: 'assets/images/cycling_1.png'),
      status: ResponseParser.asString(json['status'], fallback: 'pending'),
      reported: ResponseParser.asBool(json['reported']),
    );
  }
}
