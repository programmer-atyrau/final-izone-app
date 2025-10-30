import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/district.dart';
import '../services/district_service.dart';

class DistrictMapScreen extends StatefulWidget {
  final District? district;

  const DistrictMapScreen({
    super.key,
    this.district,
  });

  @override
  State<DistrictMapScreen> createState() => _DistrictMapScreenState();
}

class _DistrictMapScreenState extends State<DistrictMapScreen> {
  List<District> _districts = [];
  District? _selectedDistrict;
  bool _showDistrictList = false;
  final MapController _mapController = MapController();

  // Координаты центра Калининграда
  static const LatLng kaliningradCenter = LatLng(54.7065, 20.5110);

  @override
  void initState() {
    super.initState();
    _loadDistricts();
    if (widget.district != null) {
      _selectedDistrict = widget.district;
    }
  }

  void _loadDistricts() {
    setState(() {
      _districts = DistrictService.getAllDistricts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          _buildMap(),
          _buildAppBar(),
          _buildFloatingListButton(),
          if (_showDistrictList) _buildDistrictList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Expanded(
              child: Text(
                'Карта районов',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () => _toggleDistrictList(),
              icon: Icon(
                _showDistrictList ? Icons.close : Icons.list,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: kaliningradCenter,
        initialZoom: 12.0,
        minZoom: 10.0,
        maxZoom: 16.0,
        onTap: (tapPosition, point) {
          setState(() {
            _selectedDistrict = null;
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
        
        // District markers
        MarkerLayer(
          markers: _districts.map((district) => Marker(
            point: LatLng(district.latitude, district.longitude),
            width: 60,
            height: 60,
            child: _DistrictMarker(
              district: district,
              isSelected: _selectedDistrict?.id == district.id,
              onTap: () => _selectDistrict(district),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFloatingListButton() {
    return Positioned(
      bottom: 100,
      right: 20,
      child: FloatingActionButton(
        onPressed: () => _toggleDistrictList(),
        backgroundColor: const Color(0xFF0C73FE),
        child: Icon(
          _showDistrictList ? Icons.close : Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDistrictList() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Районы Калининграда',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _districts.length,
                itemBuilder: (context, index) {
                  final district = _districts[index];
                  return _DistrictListItem(
                    district: district,
                    isSelected: _selectedDistrict?.id == district.id,
                    onTap: () => _selectDistrict(district),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDistrict(District district) {
    setState(() {
      _selectedDistrict = district;
    });
    _mapController.move(LatLng(district.latitude, district.longitude), 14.0);
  }

  void _toggleDistrictList() {
    setState(() {
      _showDistrictList = !_showDistrictList;
    });
  }
}


class _DistrictMarker extends StatelessWidget {
  final District district;
  final bool isSelected;
  final VoidCallback onTap;

  const _DistrictMarker({
    required this.district,
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
          color: Color(int.parse(district.color.replaceFirst('#', '0xFF'))),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_city,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Text(
                district.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DistrictListItem extends StatelessWidget {
  final District district;
  final bool isSelected;
  final VoidCallback onTap;

  const _DistrictListItem({
    required this.district,
    required this.isSelected,
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
          color: isSelected ? const Color(0xFF0C73FE) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0C73FE) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse(district.color.replaceFirst('#', '0xFF'))),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.location_city,
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
                    district.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    district.shortDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.7),
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
                        '${district.rating}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

