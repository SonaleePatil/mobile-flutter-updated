import 'package:adcc/core/utils/response_parser.dart';

class StoreItemModel {
  final String id;
  final String image;
  final String title;
  final String postedBy;
  final String price;
  final String location;
  final String timePosted;
  final String category;
  final String description;
  final List<String> details;

  const StoreItemModel({
    required this.id,
    required this.image,
    required this.title,
    required this.postedBy,
    required this.price,
    required this.location,
    required this.timePosted,
    required this.category,
    required this.description,
    required this.details,
  });

  factory StoreItemModel.fromJson(Map<String, dynamic> json) {
    final dynamic priceValue =
        json['price'] ?? json['amount'] ?? json['currentPrice'] ?? 0;
    final priceText = priceValue is num ? '${priceValue.toString()} AED' : priceValue.toString();

    final detailsRaw = json['details'] ?? json['specifications'];
    final details = detailsRaw is List
        ? detailsRaw.map((e) => e.toString()).toList()
        : <String>[];

    return StoreItemModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'],
        fallback: 'assets/images/cycling_1.png',
      ),
      title: ResponseParser.asString(json['title'] ?? json['name'], fallback: 'Item'),
      postedBy: ResponseParser.asString(
        json['sellerName'] ?? json['postedBy'] ?? json['authorName'],
        fallback: 'ADCC Member',
      ),
      price: priceText,
      location: ResponseParser.asString(json['location'] ?? json['city'], fallback: 'UAE'),
      timePosted: ResponseParser.asString(
        json['createdAt'] ?? json['timePosted'],
        fallback: 'Recently posted',
      ),
      category: ResponseParser.asString(json['category'], fallback: 'All'),
      description: ResponseParser.asString(
        json['description'],
        fallback: 'No description available.',
      ),
      details: details,
    );
  }

  Map<String, dynamic> toUiMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'postedBy': postedBy,
      'price': price,
      'timePosted': timePosted,
      'location': location,
      'category': category,
    };
  }
}
