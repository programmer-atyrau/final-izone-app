import 'package:latlong2/latlong.dart';

class Attraction {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final LatLng coordinates;
  final AttractionType type;
  final String imageUrl;
  final double rating;
  final bool isAREnabled;
  final List<String> tags;
  final String address;
  final String workingHours;
  final String phone;
  final String website;

  Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.coordinates,
    required this.type,
    required this.imageUrl,
    this.rating = 0.0,
    this.isAREnabled = false,
    this.tags = const [],
    this.address = '',
    this.workingHours = '',
    this.phone = '',
    this.website = '',
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      coordinates: LatLng(
        json['latitude']?.toDouble() ?? 0.0,
        json['longitude']?.toDouble() ?? 0.0,
      ),
      type: AttractionType.values.firstWhere(
        (e) => e.toString() == 'AttractionType.${json['type']}',
        orElse: () => AttractionType.other,
      ),
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      isAREnabled: json['isAREnabled'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      address: json['address'] ?? '',
      workingHours: json['workingHours'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'rating': rating,
      'isAREnabled': isAREnabled,
      'tags': tags,
      'address': address,
      'workingHours': workingHours,
      'phone': phone,
      'website': website,
    };
  }
}

enum AttractionType {
  museum,
  park,
  church,
  monument,
  viewpoint,
  restaurant,
  hotel,
  shopping,
  culture,
  nature,
  history,
  other,
}

extension AttractionTypeExtension on AttractionType {
  String get displayName {
    switch (this) {
      case AttractionType.museum:
        return 'Музей';
      case AttractionType.park:
        return 'Парк';
      case AttractionType.church:
        return 'Церковь';
      case AttractionType.monument:
        return 'Памятник';
      case AttractionType.viewpoint:
        return 'Смотровая площадка';
      case AttractionType.restaurant:
        return 'Ресторан';
      case AttractionType.hotel:
        return 'Отель';
      case AttractionType.shopping:
        return 'Торговый центр';
      case AttractionType.culture:
        return 'Культурный объект';
      case AttractionType.nature:
        return 'Природный объект';
      case AttractionType.history:
        return 'Исторический объект';
      case AttractionType.other:
        return 'Другое';
    }
  }

  String get icon {
    switch (this) {
      case AttractionType.museum:
        return 'museum';
      case AttractionType.park:
        return 'park';
      case AttractionType.church:
        return 'church';
      case AttractionType.monument:
        return 'monument';
      case AttractionType.viewpoint:
        return 'viewpoint';
      case AttractionType.restaurant:
        return 'restaurant';
      case AttractionType.hotel:
        return 'hotel';
      case AttractionType.shopping:
        return 'shopping';
      case AttractionType.culture:
        return 'culture';
      case AttractionType.nature:
        return 'nature';
      case AttractionType.history:
        return 'history';
      case AttractionType.other:
        return 'other';
    }
  }

  String get color {
    switch (this) {
      case AttractionType.museum:
        return '#2196F3';
      case AttractionType.park:
        return '#0C73FE';
      case AttractionType.church:
        return '#9C27B0';
      case AttractionType.monument:
        return '#FF9800';
      case AttractionType.viewpoint:
        return '#FF5722';
      case AttractionType.restaurant:
        return '#E91E63';
      case AttractionType.hotel:
        return '#607D8B';
      case AttractionType.shopping:
        return '#795548';
      case AttractionType.culture:
        return '#3F51B5';
      case AttractionType.nature:
        return '#8BC34A';
      case AttractionType.history:
        return '#FFC107';
      case AttractionType.other:
        return '#9E9E9E';
    }
  }
}
