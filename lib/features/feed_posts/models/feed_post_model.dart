import 'package:adcc/core/utils/response_parser.dart';

class FeedPostModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String status;
  final bool reported;
  final String authorName;
  final String authorAvatar;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;
  final DateTime? createdAt;
  final List<FeedCommentModel> comments;

  const FeedPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reported,
    required this.authorName,
    required this.authorAvatar,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.createdAt,
    required this.comments,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    final createdBy = json['createdBy'];
    final createdByMap = createdBy is Map<String, dynamic> ? createdBy : null;
    final commentsJson = json['comments'];
    final likesJson = json['likes'];

    return FeedPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Feed Post'),
      description: ResponseParser.asString(json['description'] ?? json['body'],
          fallback: ''),
      image: ResponseParser.asString(json['image'] ?? json['mainImage']),
      status: ResponseParser.asString(json['status'], fallback: 'pending'),
      reported: ResponseParser.asBool(json['reported']),
      authorName: ResponseParser.asString(
        json['authorName'] ??
            createdByMap?['fullName'] ??
            createdByMap?['name'],
        fallback: 'ADCC Member',
      ),
      authorAvatar: ResponseParser.asString(
        json['authorAvatar'] ??
            createdByMap?['profileImage'] ??
            createdByMap?['avatar'],
      ),
      likesCount: ResponseParser.asInt(
        json['likesCount'] ?? json['likeCount'] ?? json['likes'],
        fallback: likesJson is List ? likesJson.length : 0,
      ),
      commentsCount: ResponseParser.asInt(
        json['commentsCount'] ?? json['commentCount'],
        fallback: commentsJson is List ? commentsJson.length : 0,
      ),
      likedByMe: ResponseParser.asBool(json['likedByMe']),
      createdAt: DateTime.tryParse(ResponseParser.asString(json['createdAt'])),
      comments: commentsJson is List
          ? commentsJson
              .whereType<Map<String, dynamic>>()
              .map(FeedCommentModel.fromJson)
              .toList()
          : const [],
    );
  }

  FeedPostModel copyWith({
    int? likesCount,
    bool? likedByMe,
  }) {
    return FeedPostModel(
      id: id,
      title: title,
      description: description,
      image: image,
      status: status,
      reported: reported,
      authorName: authorName,
      authorAvatar: authorAvatar,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      createdAt: createdAt,
      comments: comments,
    );
  }
}

class FeedCommentModel {
  final String id;
  final String text;
  final String userId;
  final String authorName;
  final String authorAvatar;
  final DateTime? createdAt;
  final bool canDeleteByMe;

  const FeedCommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    required this.canDeleteByMe,
  });

  factory FeedCommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userMap = user is Map<String, dynamic> ? user : null;

    return FeedCommentModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      text: ResponseParser.asString(
          json['text'] ?? json['comment'] ?? json['message']),
      userId:
          ResponseParser.asString(userMap?['_id'] ?? userMap?['id'] ?? user),
      authorName: ResponseParser.asString(
        json['authorName'] ?? userMap?['fullName'] ?? userMap?['name'],
        fallback: 'Member',
      ),
      authorAvatar: ResponseParser.asString(
        json['authorAvatar'] ?? userMap?['profileImage'] ?? userMap?['avatar'],
      ),
      createdAt: DateTime.tryParse(ResponseParser.asString(json['createdAt'])),
      canDeleteByMe: ResponseParser.asBool(json['canDeleteByMe']),
    );
  }
}
