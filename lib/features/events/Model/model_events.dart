import 'package:intl/intl.dart';

/// Event model (Fully Synced With Backend)
class Event {
  final String id;
  final String title;
  final String? description;


  final String? mainImage;

  final String? eventDate;
  final String? eventTime;
  final String? address;

  final int? maxParticipants;
  final int? currentParticipants;

  final int? minAge;
  final int? maxAge;

  final String? youtubeLink;
  final String? status;

  final Map<String, dynamic>? createdBy;


  final bool? allowCancellation;
  final List<String>? amenities;
  final String? category;
  final String? city;
  final String? communityId;
  final String? difficulty;
  final int? distance;
  final List<Map<String, dynamic>>? eligibility;
  final List<String>? galleryImages;
  final bool? isFeatured;
  final List<Map<String, dynamic>>? schedule;
  final String? slug;
  final String? trackId;

 
  final Map<String, dynamic>? additionalData;

  
  final String? derivedCategory;

  Event({
    required this.id,
    required this.title,
    this.description,
    this.mainImage,
    this.eventDate,
    this.eventTime,
    this.address,
    this.maxParticipants,
    this.currentParticipants,
    this.minAge,
    this.maxAge,
    this.youtubeLink,
    this.status,
    this.createdBy,
    this.allowCancellation,
    this.amenities,
    this.category,
    this.city,
    this.communityId,
    this.difficulty,
    this.distance,
    this.eligibility,
    this.galleryImages,
    this.isFeatured,
    this.schedule,
    this.slug,
    this.trackId,
    this.additionalData,
    this.derivedCategory,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final title = json['title']?.toString() ?? '';

    return Event(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: title,
      description: json['description']?.toString(),
      mainImage: json['mainImage']?.toString(),
      eventDate: json['eventDate']?.toString(),
      eventTime: json['eventTime']?.toString(),
      address: json['address']?.toString(),

      maxParticipants: json['maxParticipants'] is int
          ? json['maxParticipants']
          : int.tryParse(json['maxParticipants']?.toString() ?? ''),

      currentParticipants: json['currentParticipants'] is int
          ? json['currentParticipants']
          : int.tryParse(json['currentParticipants']?.toString() ?? ''),

      minAge: json['minAge'] is int
          ? json['minAge']
          : int.tryParse(json['minAge']?.toString() ?? ''),

      maxAge: json['maxAge'] is int
          ? json['maxAge']
          : int.tryParse(json['maxAge']?.toString() ?? ''),

      youtubeLink: json['youtubeLink']?.toString(),
      status: json['status']?.toString(),
      createdBy: json['createdBy'] is Map<String, dynamic>
          ? json['createdBy']
          : null,

      allowCancellation: json['allowCancellation'] as bool?,
      amenities: (json['amenities'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      category: json['category']?.toString(),
      city: json['city']?.toString(),
      communityId: json['communityId']?.toString(),
      difficulty: json['difficulty']?.toString(),

      distance: json['distance'] is int
          ? json['distance']
          : int.tryParse(json['distance']?.toString() ?? ''),

      eligibility: (json['eligibility'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),

      galleryImages: (json['galleryImages'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      isFeatured: json['isFeatured'] as bool?,

      schedule: (json['schedule'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),

      slug: json['slug']?.toString(),
      trackId: json['trackId']?.toString(),

      additionalData: json,

      derivedCategory:
          json['category']?.toString() ?? _deriveCategoryFromTitle(title),
    );
  }


  static String _deriveCategoryFromTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains('family') || t.contains('kids')) return 'Family & Kids';
    if (t.contains('shop')) return 'Shop';
    if (t.contains('community') || t.contains('ride')) return 'Community Ride';

    return 'Community Ride';
  }

  
 String? get formattedDate {
  if (eventDate == null) return null;
  try {
    final dateTime = DateTime.parse(eventDate!);
    return DateFormat('d MMM yyyy').format(dateTime);
  } catch (_) {
    return eventDate;
  }
}


  String get participantsString {
    if (currentParticipants != null && maxParticipants != null) {
      return '$currentParticipants/$maxParticipants';
    } else if (currentParticipants != null) {
      return '$currentParticipants';
    } else if (maxParticipants != null) {
      return '0/$maxParticipants';
    }
    return '0';
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'mainImage': mainImage,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'address': address,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'minAge': minAge,
      'maxAge': maxAge,
      'youtubeLink': youtubeLink,
      'status': status,
      'createdBy': createdBy,
      'allowCancellation': allowCancellation,
      'amenities': amenities,
      'category': category,
      'city': city,
      'communityId': communityId,
      'difficulty': difficulty,
      'distance': distance,
      'eligibility': eligibility,
      'galleryImages': galleryImages,
      'isFeatured': isFeatured,
      'schedule': schedule,
      'slug': slug,
      'trackId': trackId,
      'derivedCategory': derivedCategory,
    };
  }
}