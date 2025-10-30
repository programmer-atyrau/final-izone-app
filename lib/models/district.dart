class District {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String atmosphere;
  final String people;
  final String sights;
  final String safety;
  final String activity;
  final double latitude;
  final double longitude;
  final String color;
  final List<String> landmarks;
  final List<String> restaurants;
  final List<String> hotels;
  final String imageUrl;
  final bool isPopular;
  final double rating;

  District({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.atmosphere,
    required this.people,
    required this.sights,
    required this.safety,
    required this.activity,
    required this.latitude,
    required this.longitude,
    required this.color,
    required this.landmarks,
    required this.restaurants,
    required this.hotels,
    required this.imageUrl,
    this.isPopular = false,
    this.rating = 0.0,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      atmosphere: json['atmosphere'] ?? '',
      people: json['people'] ?? '',
      sights: json['sights'] ?? '',
      safety: json['safety'] ?? '',
      activity: json['activity'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      color: json['color'] ?? '#4CAF50',
      landmarks: List<String>.from(json['landmarks'] ?? []),
      restaurants: List<String>.from(json['restaurants'] ?? []),
      hotels: List<String>.from(json['hotels'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      isPopular: json['isPopular'] ?? false,
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'atmosphere': atmosphere,
      'people': people,
      'sights': sights,
      'safety': safety,
      'activity': activity,
      'latitude': latitude,
      'longitude': longitude,
      'color': color,
      'landmarks': landmarks,
      'restaurants': restaurants,
      'hotels': hotels,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'rating': rating,
    };
  }
}

class DistrictCategory {
  final String name;
  final String description;
  final String icon;
  final String color;

  DistrictCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
