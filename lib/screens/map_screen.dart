import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/attraction.dart';
import '../services/attraction_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Attraction> _attractions = [];
  Attraction? _selectedAttraction;
  bool _showAROnly = false;
  bool _showPopularOnly = false;
  String _searchQuery = '';
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  void _loadAttractions() {
    setState(() {
      _attractions = AttractionService.getAllAttractions();
    });
  }

  List<Attraction> get _filteredAttractions {
    List<Attraction> filtered = _attractions;

    if (_showAROnly) {
      filtered = filtered.where((attraction) => attraction.isAREnabled).toList();
    }

    if (_showPopularOnly) {
      filtered = filtered.where((attraction) => attraction.rating >= 4.5).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = AttractionService.searchAttractions(_searchQuery);
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Карта Атырау',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterOptions(),
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () => _centerOnAtyrau(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Real map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: AttractionService.atyrauCenter,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedAttraction = null;
                });
              },
            ),
                children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ar_tourist_app',
                maxZoom: 18,
              ),
              
              // Attraction markers
              MarkerLayer(
                markers: _filteredAttractions.map((attraction) => Marker(
                  point: attraction.coordinates,
                  width: 50,
                  height: 50,
                  child: _AttractionMarker(
                    attraction: attraction,
                    isSelected: _selectedAttraction?.id == attraction.id,
                    onTap: () => _selectAttraction(attraction),
                  ),
                )).toList(),
              ),
            ],
          ),
          
          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.add,
                  onPressed: () => _zoomIn(),
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.remove,
                  onPressed: () => _zoomOut(),
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.refresh,
                  onPressed: () => _refreshMap(),
                ),
              ],
            ),
          ),
          
          // Search bar
          Positioned(
            top: 16,
            left: 16,
            right: 80,
            child: _SearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Bottom sheet with attractions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _AttractionsSheet(
              attractions: _filteredAttractions,
              onAttractionTap: _selectAttraction,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showARMode,
        backgroundColor: const Color(0xFF0C73FE),
        child: const Icon(Icons.view_in_ar, color: Colors.white),
      ),
    );
  }

  void _selectAttraction(Attraction attraction) {
    setState(() {
      _selectedAttraction = attraction;
    });
    _mapController.move(attraction.coordinates, 15.0);
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Поиск достопримечательностей',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введите название...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterOptionsSheet(
        showAROnly: _showAROnly,
        showPopularOnly: _showPopularOnly,
        onAROnlyChanged: (value) {
          setState(() {
            _showAROnly = value;
          });
        },
        onPopularOnlyChanged: (value) {
          setState(() {
            _showPopularOnly = value;
          });
        },
      ),
    );
  }

  void _centerOnAtyrau() {
    _mapController.move(AttractionService.atyrauCenter, 13.0);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _refreshMap() {
    _loadAttractions();
  }

  void _showARMode() {
    final arAttractions = AttractionService.getAREnabledAttractions();
    if (arAttractions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Нет достопримечательностей с AR контентом'),
          backgroundColor: Colors.orange,
      ),
    );
      return;
  }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ARAttractionsSheet(
        attractions: arAttractions,
        onAttractionTap: _selectAttraction,
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}




class _AttractionMarker extends StatelessWidget {
  final Attraction attraction;
  final bool isSelected;
  final VoidCallback onTap;

  const _AttractionMarker({
    required this.attraction,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSelected ? 60 : 50,
        height: isSelected ? 60 : 50,
        decoration: BoxDecoration(
          color: Color(int.parse(attraction.type.color.replaceFirst('#', '0xFF'))),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _getAttractionIcon(attraction.type),
          color: Colors.white,
          size: isSelected ? 30 : 25,
        ),
      ),
    );
  }

  IconData _getAttractionIcon(AttractionType type) {
    switch (type) {
      case AttractionType.museum:
        return Icons.museum;
      case AttractionType.park:
        return Icons.park;
      case AttractionType.church:
        return Icons.church;
      case AttractionType.monument:
        return Icons.account_balance;
      case AttractionType.viewpoint:
        return Icons.visibility;
      case AttractionType.restaurant:
        return Icons.restaurant;
      case AttractionType.hotel:
        return Icons.hotel;
      case AttractionType.shopping:
        return Icons.shopping_bag;
      case AttractionType.culture:
        return Icons.theater_comedy;
      case AttractionType.nature:
        return Icons.nature;
      case AttractionType.history:
        return Icons.history_edu;
      case AttractionType.other:
        return Icons.place;
    }
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Поиск достопримечательностей...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _AttractionsSheet extends StatelessWidget {
  final List<Attraction> attractions;
  final Function(Attraction) onAttractionTap;

  const _AttractionsSheet({
    required this.attractions,
    required this.onAttractionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Достопримечательности Атырау',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: attractions.length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return _AttractionCard(
                  attraction: attraction,
                  onTap: () => onAttractionTap(attraction),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback onTap;

  const _AttractionCard({
    required this.attraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(attraction.type.color.replaceFirst('#', '0xFF'))),
                      Color(int.parse(attraction.type.color.replaceFirst('#', '0xFF'))).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getAttractionIcon(attraction.type),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attraction.shortDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${attraction.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (attraction.isAREnabled)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C73FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'AR',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAttractionIcon(AttractionType type) {
    switch (type) {
      case AttractionType.museum:
        return Icons.museum;
      case AttractionType.park:
        return Icons.park;
      case AttractionType.church:
        return Icons.church;
      case AttractionType.monument:
        return Icons.account_balance;
      case AttractionType.viewpoint:
        return Icons.visibility;
      case AttractionType.restaurant:
        return Icons.restaurant;
      case AttractionType.hotel:
        return Icons.hotel;
      case AttractionType.shopping:
        return Icons.shopping_bag;
      case AttractionType.culture:
        return Icons.theater_comedy;
      case AttractionType.nature:
        return Icons.nature;
      case AttractionType.history:
        return Icons.history_edu;
      case AttractionType.other:
        return Icons.place;
    }
  }
}

class _FilterOptionsSheet extends StatelessWidget {
  final bool showAROnly;
  final bool showPopularOnly;
  final ValueChanged<bool> onAROnlyChanged;
  final ValueChanged<bool> onPopularOnlyChanged;

  const _FilterOptionsSheet({
    required this.showAROnly,
    required this.showPopularOnly,
    required this.onAROnlyChanged,
    required this.onPopularOnlyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _FilterOption(
            label: 'Только с AR контентом',
            value: showAROnly,
            onChanged: onAROnlyChanged,
          ),
          const SizedBox(height: 12),
          _FilterOption(
            label: 'Только популярные',
            value: showPopularOnly,
            onChanged: onPopularOnlyChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF0C73FE),
        ),
      ],
    );
  }
}

class _ARAttractionsSheet extends StatelessWidget {
  final List<Attraction> attractions;
  final Function(Attraction) onAttractionTap;

  const _ARAttractionsSheet({
    required this.attractions,
    required this.onAttractionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'AR Достопримечательности',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: attractions.length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return _ARAttractionItem(
                  attraction: attraction,
                  onTap: () => onAttractionTap(attraction),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ARAttractionItem extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback onTap;

  const _ARAttractionItem({
    required this.attraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF0C73FE).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse(attraction.type.color.replaceFirst('#', '0xFF'))),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                _getAttractionIcon(attraction.type),
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attraction.shortDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${attraction.rating}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C73FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'AR',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAttractionIcon(AttractionType type) {
    switch (type) {
      case AttractionType.museum:
        return Icons.museum;
      case AttractionType.park:
        return Icons.park;
      case AttractionType.church:
        return Icons.church;
      case AttractionType.monument:
        return Icons.account_balance;
      case AttractionType.viewpoint:
        return Icons.visibility;
      case AttractionType.restaurant:
        return Icons.restaurant;
      case AttractionType.hotel:
        return Icons.hotel;
      case AttractionType.shopping:
        return Icons.shopping_bag;
      case AttractionType.culture:
        return Icons.theater_comedy;
      case AttractionType.nature:
        return Icons.nature;
      case AttractionType.history:
        return Icons.history_edu;
      case AttractionType.other:
        return Icons.place;
    }
  }
}
