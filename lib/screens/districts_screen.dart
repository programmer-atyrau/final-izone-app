import 'package:flutter/material.dart';
import '../models/district.dart';
import '../services/district_service.dart';
import 'district_detail_screen.dart';
import 'district_map_screen.dart';

class DistrictsScreen extends StatefulWidget {
  const DistrictsScreen({super.key});

  @override
  State<DistrictsScreen> createState() => _DistrictsScreenState();
}

class _DistrictsScreenState extends State<DistrictsScreen> {
  List<District> _districts = [];
  List<District> _filteredDistricts = [];
  String _searchQuery = '';
  bool _showOnlyPopular = false;

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  void _loadDistricts() {
    setState(() {
      _districts = DistrictService.getAllDistricts();
      _filteredDistricts = _districts;
    });
  }

  void _filterDistricts() {
    setState(() {
      if (_showOnlyPopular) {
        _filteredDistricts = DistrictService.getPopularDistricts();
      } else {
        _filteredDistricts = DistrictService.searchDistricts(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterTabs(),
            _buildDistrictsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  'Короче, Калининград',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => _showMapView(),
                icon: const Icon(Icons.map, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            title: 'Избранное',
            subtitle: 'План поездки',
            icon: Icons.favorite,
            isSelected: false,
            onTap: () => _showFavorites(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            title: 'Районы',
            subtitle: 'Где жить',
            icon: Icons.location_on,
            isSelected: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          title: '',
          subtitle: '',
          icon: Icons.star,
          isSelected: false,
          onTap: () => _showStarred(),
          isCompact: true,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Поиск районов...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterDistricts();
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _FilterTab(
              label: 'Все районы',
              isSelected: !_showOnlyPopular,
              onTap: () {
                setState(() {
                  _showOnlyPopular = false;
                });
                _filterDistricts();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterTab(
              label: 'Популярные',
              isSelected: _showOnlyPopular,
              onTap: () {
                setState(() {
                  _showOnlyPopular = true;
                });
                _filterDistricts();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictsList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredDistricts.length,
        itemBuilder: (context, index) {
          final district = _filteredDistricts[index];
          return _DistrictCard(
            district: district,
            onTap: () => _showDistrictDetails(district),
            onMapTap: () => _showDistrictOnMap(district),
          );
        },
      ),
    );
  }

  void _showDistrictDetails(District district) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DistrictDetailScreen(district: district),
      ),
    );
  }

  void _showDistrictOnMap(District district) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DistrictMapScreen(district: district),
      ),
    );
  }

  void _showMapView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DistrictMapScreen(),
      ),
    );
  }

  void _showFavorites() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Раздел "Избранное" будет добавлен позже'),
        backgroundColor: Color(0xFF0C73FE),
      ),
    );
  }

  void _showStarred() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Раздел "Звездочки" будет добавлен позже'),
        backgroundColor: Color(0xFF0C73FE),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  const _ActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0C73FE) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0C73FE) : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            size: 24,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C73FE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0C73FE) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C73FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0C73FE) : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _DistrictCard extends StatelessWidget {
  final District district;
  final VoidCallback onTap;
  final VoidCallback onMapTap;

  const _DistrictCard({
    required this.district,
    required this.onTap,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(int.parse(district.color.replaceFirst('#', '0xFF'))),
                  Color(int.parse(district.color.replaceFirst('#', '0xFF'))).withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 60,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        district.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          district.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  district.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  district.shortDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                _buildDistrictInfo(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Подробнее'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onMapTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C73FE),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text('Карта'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          label: 'Атмосфера',
          value: district.atmosphere,
          color: const Color(0xFF87CEEB),
        ),
        _InfoChip(
          label: 'Люди',
          value: district.people,
          color: const Color(0xFFFF6B6B),
        ),
        _InfoChip(
          label: 'Достопримечательности',
          value: district.sights,
          color: const Color(0xFF9B59B6),
        ),
        _InfoChip(
          label: 'Безопасность',
          value: district.safety,
          color: const Color(0xFF2ECC71),
        ),
        _InfoChip(
          label: 'Активность',
          value: district.activity,
          color: const Color(0xFFF39C12),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
