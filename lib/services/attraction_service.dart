import 'package:latlong2/latlong.dart';
import '../models/attraction.dart';

class AttractionService {
  // Координаты центра Атырау
  static const LatLng atyrauCenter = LatLng(47.1167, 51.8833);

  static final List<Attraction> _attractions = [
    Attraction(
      id: '1',
      name: 'Урало-Каспийский собор',
      description: 'Православный храм, построенный в 2000 году. Один из самых красивых и современных соборов в Казахстане. Высота собора составляет 64 метра, а его золотые купола видны издалека.',
      shortDescription: 'Современный православный собор с золотыми куполами',
      coordinates: const LatLng(47.1167, 51.8833),
      type: AttractionType.church,
      imageUrl: 'assets/images/attractions/uralo_kaspijskiy_sobor.jpg',
      rating: 4.8,
      isAREnabled: true,
      tags: ['религия', 'архитектура', 'история'],
      address: 'ул. Абая, 1, Атырау',
      workingHours: '08:00 - 20:00',
      phone: '+7 (7122) 32-45-67',
    ),
    Attraction(
      id: '2',
      name: 'Набережная реки Урал',
      description: 'Красивая набережная вдоль реки Урал с пешеходными дорожками, скамейками и фонарями. Отличное место для прогулок и отдыха. Здесь можно насладиться видом на реку и город.',
      shortDescription: 'Пешеходная набережная с видом на реку Урал',
      coordinates: const LatLng(47.1200, 51.8800),
      type: AttractionType.park,
      imageUrl: 'assets/images/attractions/ural_embankment.jpg',
      rating: 4.5,
      isAREnabled: false,
      tags: ['природа', 'прогулки', 'отдых'],
      address: 'набережная реки Урал, Атырау',
      workingHours: 'круглосуточно',
    ),
    Attraction(
      id: '3',
      name: 'Пешеходный мост через Урал',
      description: 'Символический мост, соединяющий Европу и Азию. Мост был построен в 2000 году и стал символом города. С моста открывается прекрасный вид на реку Урал и город.',
      shortDescription: 'Символический мост между Европой и Азией',
      coordinates: const LatLng(47.1150, 51.8850),
      type: AttractionType.monument,
      imageUrl: 'assets/images/attractions/ural_bridge.jpg',
      rating: 4.7,
      isAREnabled: true,
      tags: ['символ', 'мост', 'Европа-Азия'],
      address: 'пешеходный мост через Урал, Атырау',
      workingHours: 'круглосуточно',
    ),
    Attraction(
      id: '4',
      name: 'Мечеть Имангали',
      description: 'Главная мечеть города, построенная в 2000 году. Красивое здание в традиционном исламском стиле с высоким минаретом. Вмещает до 1000 верующих.',
      shortDescription: 'Главная мечеть города в традиционном стиле',
      coordinates: const LatLng(47.1100, 51.8900),
      type: AttractionType.church,
      imageUrl: 'assets/images/attractions/imangali_mosque.jpg',
      rating: 4.6,
      isAREnabled: false,
      tags: ['религия', 'ислам', 'архитектура'],
      address: 'ул. Курмангазы, 45, Атырау',
      workingHours: '05:00 - 22:00',
      phone: '+7 (7122) 32-12-34',
    ),
    Attraction(
      id: '5',
      name: 'Областной историко-краеведческий музей',
      description: 'Музей с богатой коллекцией экспонатов по истории Прикаспийского региона. Здесь можно узнать о древней истории края, традициях и культуре местных народов.',
      shortDescription: 'Музей истории и культуры Прикаспийского региона',
      coordinates: const LatLng(47.1250, 51.8750),
      type: AttractionType.museum,
      imageUrl: 'assets/images/attractions/history_museum.jpg',
      rating: 4.4,
      isAREnabled: true,
      tags: ['музей', 'история', 'культура'],
      address: 'ул. Абая, 15, Атырау',
      workingHours: '09:00 - 18:00 (вт-вс)',
      phone: '+7 (7122) 32-56-78',
    ),
    Attraction(
      id: '6',
      name: 'Парк Победы',
      description: 'Мемориальный парк, посвященный победе в Великой Отечественной войне. Здесь установлен памятник воинам-землякам и горит вечный огонь.',
      shortDescription: 'Мемориальный парк с памятником воинам-землякам',
      coordinates: const LatLng(47.1300, 51.8700),
      type: AttractionType.park,
      imageUrl: 'assets/images/attractions/victory_park.jpg',
      rating: 4.3,
      isAREnabled: false,
      tags: ['память', 'война', 'памятник'],
      address: 'парк Победы, Атырау',
      workingHours: 'круглосуточно',
    ),
    Attraction(
      id: '7',
      name: 'Торговый центр "Атырау"',
      description: 'Современный торговый центр с множеством магазинов, ресторанов и развлекательных заведений. Один из крупнейших торговых центров города.',
      shortDescription: 'Современный торговый центр с магазинами и ресторанами',
      coordinates: const LatLng(47.1050, 51.8950),
      type: AttractionType.shopping,
      imageUrl: 'assets/images/attractions/atyrau_mall.jpg',
      rating: 4.2,
      isAREnabled: false,
      tags: ['шопинг', 'торговля', 'развлечения'],
      address: 'ул. Сатпаева, 12, Атырау',
      workingHours: '10:00 - 22:00',
      phone: '+7 (7122) 32-78-90',
    ),
    Attraction(
      id: '8',
      name: 'Ресторан "Урал"',
      description: 'Один из лучших ресторанов города с традиционной казахской кухней. Здесь можно попробовать блюда из мяса, молочные продукты и национальные напитки.',
      shortDescription: 'Ресторан с традиционной казахской кухней',
      coordinates: const LatLng(47.1180, 51.8820),
      type: AttractionType.restaurant,
      imageUrl: 'assets/images/attractions/ural_restaurant.jpg',
      rating: 4.5,
      isAREnabled: false,
      tags: ['еда', 'казахская кухня', 'традиции'],
      address: 'ул. Абая, 25, Атырау',
      workingHours: '12:00 - 24:00',
      phone: '+7 (7122) 32-34-56',
    ),
    Attraction(
      id: '9',
      name: 'Отель "Атырау"',
      description: 'Современный отель в центре города с комфортабельными номерами и отличным сервисом. Идеальное место для проживания туристов.',
      shortDescription: 'Современный отель в центре города',
      coordinates: const LatLng(47.1220, 51.8880),
      type: AttractionType.hotel,
      imageUrl: 'assets/images/attractions/atyrau_hotel.jpg',
      rating: 4.3,
      isAREnabled: false,
      tags: ['отель', 'проживание', 'туризм'],
      address: 'ул. Курмангазы, 78, Атырау',
      workingHours: 'круглосуточно',
      phone: '+7 (7122) 32-90-12',
    ),
    Attraction(
      id: '10',
      name: 'Смотровая площадка "Европа-Азия"',
      description: 'Смотровая площадка на высоте 30 метров с панорамным видом на город и реку Урал. Отсюда можно увидеть, как река разделяет Европу и Азию.',
      shortDescription: 'Смотровая площадка с видом на раздел Европы и Азии',
      coordinates: const LatLng(47.1140, 51.8840),
      type: AttractionType.viewpoint,
      imageUrl: 'assets/images/attractions/europe_asia_viewpoint.jpg',
      rating: 4.6,
      isAREnabled: true,
      tags: ['панорама', 'вид', 'Европа-Азия'],
      address: 'смотровая площадка "Европа-Азия", Атырау',
      workingHours: '08:00 - 20:00',
    ),
  ];

  static List<Attraction> getAllAttractions() {
    return List.from(_attractions);
  }

  static List<Attraction> getAttractionsByType(AttractionType type) {
    return _attractions.where((attraction) => attraction.type == type).toList();
  }

  static Attraction? getAttractionById(String id) {
    try {
      return _attractions.firstWhere((attraction) => attraction.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Attraction> searchAttractions(String query) {
    if (query.isEmpty) return _attractions;
    
    final lowercaseQuery = query.toLowerCase();
    return _attractions.where((attraction) {
      return attraction.name.toLowerCase().contains(lowercaseQuery) ||
             attraction.description.toLowerCase().contains(lowercaseQuery) ||
             attraction.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static List<Attraction> getNearbyAttractions(LatLng location, double radiusKm) {
    final distance = Distance();
    return _attractions.where((attraction) {
      final distanceKm = distance.as(LengthUnit.Kilometer, location, attraction.coordinates);
      return distanceKm <= radiusKm;
    }).toList();
  }

  static List<Attraction> getAREnabledAttractions() {
    return _attractions.where((attraction) => attraction.isAREnabled).toList();
  }

  static List<Attraction> getPopularAttractions() {
    return _attractions.where((attraction) => attraction.rating >= 4.5).toList();
  }
}
