import '../models/district.dart';

class DistrictService {
  static final List<District> _districts = [
    District(
      id: '1',
      name: 'Деловой центр',
      description: 'Центральная часть города с современными офисными зданиями, банками и деловыми центрами. Здесь расположены основные административные здания и торговые центры.',
      shortDescription: 'Современный деловой центр с офисами и торговыми центрами',
      atmosphere: 'Деловая, современная, динамичная',
      people: 'Офисные работники, бизнесмены, туристы',
      sights: 'Ленинский проспект, улица Черняховского, Северный вокзал',
      safety: 'Высокая безопасность, много полиции',
      activity: 'Высокая активность в дневное время',
      latitude: 54.7065,
      longitude: 20.5110,
      color: '#FFD700',
      landmarks: [
        'Ленинский проспект',
        'Северный вокзал',
        'Торговый центр "Эпицентр"',
        'Площадь Победы'
      ],
      restaurants: [
        'Ресторан "Калининград"',
        'Кафе "Центральное"',
        'Пиццерия "Домино"'
      ],
      hotels: [
        'Отель "Калининград"',
        'Гостиница "Турист"',
        'Хостел "Центр"'
      ],
      imageUrl: 'assets/images/districts/business_center.jpg',
      isPopular: true,
      rating: 4.5,
    ),
    District(
      id: '2',
      name: 'Хипстеры',
      description: 'Молодежный район с модными кафе, барами, стрит-артом и творческими пространствами. Здесь собирается креативная молодежь и творческие люди.',
      shortDescription: 'Молодежный район с модными кафе и творческими пространствами',
      atmosphere: 'Креативная, молодежная, неформальная',
      people: 'Студенты, художники, музыканты, IT-специалисты',
      sights: 'Улица Фрунзе, парк "Юность", арт-пространства',
      safety: 'Средняя безопасность, активная ночная жизнь',
      activity: 'Очень высокая активность, особенно вечером',
      latitude: 54.7200,
      longitude: 20.4800,
      color: '#FF8C00',
      landmarks: [
        'Улица Фрунзе',
        'Парк "Юность"',
        'Арт-пространство "Гараж"',
        'Книжный магазин "Петровский"'
      ],
      restaurants: [
        'Кафе "Хипстер"',
        'Бар "Креатив"',
        'Кофейня "Боб"'
      ],
      hotels: [
        'Хостел "Креатив"',
        'Отель "Молодежный"'
      ],
      imageUrl: 'assets/images/districts/hipsters.jpg',
      isPopular: true,
      rating: 4.2,
    ),
    District(
      id: '3',
      name: 'Элита и богема',
      description: 'Престижный район с дорогими ресторанами, галереями, антикварными магазинами и элитными жилыми комплексами.',
      shortDescription: 'Престижный район с дорогими ресторанами и галереями',
      atmosphere: 'Элитная, изысканная, культурная',
      people: 'Богатые жители, коллекционеры, галеристы',
      sights: 'Улица Театральная, галерея "Богема", антикварные магазины',
      safety: 'Очень высокая безопасность',
      activity: 'Умеренная активность, культурные события',
      latitude: 54.7100,
      longitude: 20.5200,
      color: '#FF69B4',
      landmarks: [
        'Улица Театральная',
        'Галерея "Богема"',
        'Антикварный магазин "Старина"',
        'Театр драмы'
      ],
      restaurants: [
        'Ресторан "Элит"',
        'Кафе "Богема"',
        'Винный бар "Изящество"'
      ],
      hotels: [
        'Отель "Престиж"',
        'Гостиница "Элит"'
      ],
      imageUrl: 'assets/images/districts/elite.jpg',
      isPopular: false,
      rating: 4.7,
    ),
    District(
      id: '4',
      name: 'Индастриал',
      description: 'Промышленный район с заводами, фабриками и рабочими кварталами. Здесь сохранилась историческая промышленная архитектура.',
      shortDescription: 'Промышленный район с историческими заводами',
      atmosphere: 'Индустриальная, историческая, рабочая',
      people: 'Рабочие, инженеры, историки',
      sights: 'Завод "Янтарь", музей промышленности, рабочие кварталы',
      safety: 'Средняя безопасность',
      activity: 'Низкая активность, рабочие часы',
      latitude: 54.6800,
      longitude: 20.4500,
      color: '#32CD32',
      landmarks: [
        'Завод "Янтарь"',
        'Музей промышленности',
        'Рабочие кварталы',
        'Парк "Индустриальный"'
      ],
      restaurants: [
        'Столовая "Заводская"',
        'Кафе "Рабочее"'
      ],
      hotels: [
        'Гостиница "Рабочая"'
      ],
      imageUrl: 'assets/images/districts/industrial.jpg',
      isPopular: false,
      rating: 3.8,
    ),
    District(
      id: '5',
      name: 'Тихие пруды',
      description: 'Спокойный жилой район с парками, прудами и тихими улочками. Идеальное место для семейного отдыха.',
      shortDescription: 'Спокойный район с парками и прудами',
      atmosphere: 'Спокойная, семейная, уютная',
      people: 'Семьи с детьми, пенсионеры, любители природы',
      sights: 'Парк "Тихие пруды", детские площадки, аллеи',
      safety: 'Очень высокая безопасность',
      activity: 'Низкая активность, спокойная жизнь',
      latitude: 54.7300,
      longitude: 20.5500,
      color: '#DDA0DD',
      landmarks: [
        'Парк "Тихие пруды"',
        'Детские площадки',
        'Аллеи для прогулок',
        'Спортивная площадка'
      ],
      restaurants: [
        'Кафе "Семейное"',
        'Ресторан "У пруда"'
      ],
      hotels: [
        'Отель "Семейный"',
        'Гостиница "Тишина"'
      ],
      imageUrl: 'assets/images/districts/quiet_ponds.jpg',
      isPopular: false,
      rating: 4.3,
    ),
    District(
      id: '6',
      name: 'Туристы',
      description: 'Туристический район с отелями, ресторанами, сувенирными магазинами и основными достопримечательностями города.',
      shortDescription: 'Туристический район с отелями и достопримечательностями',
      atmosphere: 'Туристическая, оживленная, международная',
      people: 'Туристы, гиды, работники туризма',
      sights: 'Рыбная деревня, Музей янтаря, Кафедральный собор',
      safety: 'Высокая безопасность, много туристов',
      activity: 'Очень высокая активность, особенно летом',
      latitude: 54.7000,
      longitude: 20.5300,
      color: '#8A2BE2',
      landmarks: [
        'Рыбная деревня',
        'Музей янтаря',
        'Кафедральный собор',
        'Остров Канта'
      ],
      restaurants: [
        'Ресторан "Рыбная деревня"',
        'Кафе "Турист"',
        'Ресторан "Янтарь"'
      ],
      hotels: [
        'Отель "Турист"',
        'Гостиница "Калининград"',
        'Хостел "Туристический"'
      ],
      imageUrl: 'assets/images/districts/tourists.jpg',
      isPopular: true,
      rating: 4.6,
    ),
  ];

  static List<District> getAllDistricts() {
    return List.from(_districts);
  }

  static List<District> getPopularDistricts() {
    return _districts.where((district) => district.isPopular).toList();
  }

  static District? getDistrictById(String id) {
    try {
      return _districts.firstWhere((district) => district.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<District> searchDistricts(String query) {
    if (query.isEmpty) return _districts;
    
    final lowercaseQuery = query.toLowerCase();
    return _districts.where((district) {
      return district.name.toLowerCase().contains(lowercaseQuery) ||
             district.description.toLowerCase().contains(lowercaseQuery) ||
             district.atmosphere.toLowerCase().contains(lowercaseQuery) ||
             district.landmarks.any((landmark) => 
               landmark.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static List<DistrictCategory> getDistrictCategories() {
    return [
      DistrictCategory(
        name: 'Атмосфера',
        description: 'По характеру и настроению района',
        icon: '🌆',
        color: '#87CEEB',
      ),
      DistrictCategory(
        name: 'Люди',
        description: 'По типу жителей и посетителей',
        icon: '👥',
        color: '#FF6B6B',
      ),
      DistrictCategory(
        name: 'Достопримечательности',
        description: 'По близости к интересным местам',
        icon: '🏛️',
        color: '#9B59B6',
      ),
      DistrictCategory(
        name: 'Безопасность',
        description: 'По уровню безопасности',
        icon: '🛡️',
        color: '#2ECC71',
      ),
      DistrictCategory(
        name: 'Активность',
        description: 'По уровню активности и движухи',
        icon: '⚡',
        color: '#F39C12',
      ),
    ];
  }
}
