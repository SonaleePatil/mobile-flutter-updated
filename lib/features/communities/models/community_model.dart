class CommunityModel {
  final String id;
  final String title;
  final String description;

  final String type;
  final List<String> category;

  final String? location;
  final String? city;
  final String? area;

  final String? trackName;
  final String? trackId;
  final String? terrain;
  final double? distance;

  final String? imageUrl;
  final String? logo;

  final bool isActive;
  final bool isPublic;
  final bool isFeatured;

  final String? manager;
  final String? slug;
  final int? foundedYear;

  bool isJoined;

  final int? membersCount;
  final int? eventsCount;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommunityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.location,
    this.city,
    this.area,
    this.trackName,
    this.trackId,
    this.terrain,
    this.distance,
    this.imageUrl,
    this.logo,
    this.isActive = false,
    this.isPublic = false,
    this.isFeatured = false,
    this.manager,
    this.slug,
    this.foundedYear,
    this.isJoined = false,
    this.membersCount,
    this.eventsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',

      type: json['type'] is List
          ? (json['type'] as List).join(', ')
          : json['type']?.toString() ?? '',

      category: _parseCategory(json['category']),

      location: json['location']?.toString(),
      city: json['city']?.toString(),
      area: json['area']?.toString(),

      trackName: json['trackName']?.toString(),
      trackId: json['trackId']?.toString(),
      terrain: json['terrain']?.toString(),
      distance: _parseDouble(json['distance']),

      imageUrl: json['image'] ?? json['imageUrl'],
      logo: json['logo'],

      isActive: json['isActive'] ?? false,
      isPublic: json['isPublic'] ?? false,
      isFeatured: json['isFeatured'] ?? false,

      manager: json['manager']?.toString(),
      slug: json['slug']?.toString(),
      foundedYear: json['foundedYear'] is int
          ? json['foundedYear']
          : int.tryParse(json['foundedYear']?.toString() ?? ''),

      membersCount: _parseCount(
          json['membersCount'] ?? json['memberCount'] ?? json['members']),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

   Map<String, dynamic> toJson() {
  return {
    "id": id,
    "title": title,
    "description": description,
    "type": type,
    "category": category,
    "location": location,
    "city": city,
    "area": area,
    "trackName": trackName,
    "trackId": trackId,
    "terrain": terrain,
    "distance": distance,
    "imageUrl": imageUrl,
    "logo": logo,
    "isActive": isActive,
    "isPublic": isPublic,
    "isFeatured": isFeatured,
    "manager": manager,
    "slug": slug,
    "foundedYear": foundedYear,
    "membersCount": membersCount,
    "eventsCount": eventsCount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
  static int? _parseCount(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is List) return value.length;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
  bool hasCategory(String categoryName) {
    final lowerCategoryName = categoryName.toLowerCase().trim();
    return category.any((cat) => cat.toLowerCase().trim() == lowerCategoryName);
  }

  bool hasAnyCategory(List<String> categories) {
    if (category.isEmpty) return false;

    final lowerCategories =
        categories.map((c) => c.toLowerCase().trim()).toList();
    final lowerCommunityCategories =
        category.map((c) => c.toLowerCase().trim()).toList();

    for (final keyword in lowerCategories) {
      for (final cat in lowerCommunityCategories) {
        if (cat == keyword) return true;
      }
    }
    return false;
  }

  static List<String> _parseCategory(dynamic value) {
  if (value == null) return [];

  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  if (value is String) {
    return [value];
  }

  return [];
}
}
