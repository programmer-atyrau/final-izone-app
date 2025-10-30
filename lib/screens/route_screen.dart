import 'package:flutter/material.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final List<RouteItem> _routes = [
    RouteItem(
      title: 'Атырау: Европа и Азия',
      description: 'Маршрут по символам города: мост, набережная и мечеть Имангали',
      duration: '2.5 часа',
      distance: '4.0 км',
      difficulty: 'Легкий',
      places: [
        'Пешеходный мост через Урал',
        'Набережная реки Урал',
        'Мечеть Имангали',
      ],
      imageAsset: null,
      isActive: true,
    ),
    RouteItem(
      title: 'История и культура Атырау',
      description: 'От экспозиций областного музея до старой архитектуры центра',
      duration: '3 часа',
      distance: '3.2 км',
      difficulty: 'Средний',
      places: [
        'Областной историко-краеведческий музей',
        'Памятник Исатай-Махамбет',
        'Старые купеческие дома',
      ],
      imageAsset: null,
      isActive: false,
    ),
    RouteItem(
      title: 'Прогулка вдоль Урала',
      description: 'Спокойный маршрут с видами на реку и город',
      duration: '1 час 45 мин',
      distance: '5.0 км',
      difficulty: 'Легкий',
      places: [
        'Набережная реки Урал',
        'Смотровые площадки',
        'Городские скверы',
      ],
      imageAsset: null,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Маршруты',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск маршрутов...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          // Routes list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _routes.length,
              itemBuilder: (context, index) {
                final route = _routes[index];
                return _RouteCard(
                  route: route,
                  onTap: () => _showRouteDetails(route),
                  onStart: () => _startRoute(route),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewRoute,
        backgroundColor: const Color(0xFF0C73FE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Фильтры',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterChip(
              label: 'Легкий',
              isSelected: true,
              onTap: () {},
            ),
            _FilterChip(
              label: 'Средний',
              isSelected: false,
              onTap: () {},
            ),
            _FilterChip(
              label: 'Сложный',
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Применить',
              style: TextStyle(color: Color(0xFF0C73FE)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRouteDetails(RouteItem route) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _RouteDetailsScreen(route: route),
      ),
    );
  }

  void _startRoute(RouteItem route) {
    setState(() {
      for (var r in _routes) {
        r.isActive = false;
      }
      route.isActive = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Маршрут "${route.title}" начат'),
        backgroundColor: const Color(0xFF0C73FE),
        action: SnackBarAction(
          label: 'Открыть',
          textColor: Colors.white,
          onPressed: () => _showRouteDetails(route),
        ),
      ),
    );
  }

  void _createNewRoute() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Создание нового маршрута будет добавлено позже'),
        backgroundColor: Color(0xFF0C73FE),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0C73FE) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF0C73FE) : Colors.white.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final RouteItem route;
  final VoidCallback onTap;
  final VoidCallback onStart;

  const _RouteCard({
    required this.route,
    required this.onTap,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: route.isActive 
              ? const Color(0xFF0C73FE) 
              : Colors.white.withOpacity(0.1),
          width: route.isActive ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            route.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (route.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C73FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Активен',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Route info
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.access_time,
                      text: route.duration,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.straighten,
                      text: route.distance,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.trending_up,
                      text: route.difficulty,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Places preview
                Text(
                  'Места: ${route.places.take(2).join(', ')}${route.places.length > 2 ? '...' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Подробнее'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onStart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C73FE),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(route.isActive ? 'Продолжить' : 'Начать'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetailsScreen extends StatelessWidget {
  final RouteItem route;

  const _RouteDetailsScreen({required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          route.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Поделиться маршрутом'),
                  backgroundColor: Color(0xFF0C73FE),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route image
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: route.imageAsset != null
                    ? Image.asset(
                        route.imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF0C73FE), Color(0xFF0056CC)],
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.route, size: 60, color: Colors.white),
                            ),
                          );
                        },
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0C73FE), Color(0xFF0056CC)],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.route, size: 60, color: Colors.white),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Description
            Text(
              route.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // Route info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.access_time,
                    label: 'Длительность',
                    value: route.duration,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.straighten,
                    label: 'Расстояние',
                    value: route.distance,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.trending_up,
                    label: 'Сложность',
                    value: route.difficulty,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Places list
            const Text(
              'Места на маршруте',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            ...route.places.map((place) => _PlaceItem(place: place)),
            const SizedBox(height: 20),
            
            // Start button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Маршрут "${route.title}" начат'),
                      backgroundColor: const Color(0xFF0C73FE),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C73FE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  route.isActive ? 'Продолжить маршрут' : 'Начать маршрут',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0C73FE),
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PlaceItem extends StatelessWidget {
  final String place;

  const _PlaceItem({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF0C73FE),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            place,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RouteItem {
  final String title;
  final String description;
  final String duration;
  final String distance;
  final String difficulty;
  final List<String> places;
  final String? imageAsset;
  bool isActive;

  RouteItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.distance,
    required this.difficulty,
    required this.places,
    this.imageAsset,
    required this.isActive,
  });
}
