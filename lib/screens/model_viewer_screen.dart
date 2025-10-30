import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerScreen extends StatefulWidget {
  final String modelPath;
  final String title;
  final String description;

  const ModelViewerScreen({
    super.key,
    required this.modelPath,
    required this.title,
    required this.description,
  });

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Use direct Flutter asset path; model_viewer_plus resolves assets internally
  String _resolveModelSrc(String path) => path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showModelInfo(),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareModel(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Model Viewer
          if (!_hasError)
            ModelViewer(
              src: _resolveModelSrc(widget.modelPath),
              alt: widget.title,
              ar: true,
              autoRotate: true,
              cameraControls: true,
              // Force eager load to avoid blank screen on some devices
              loading: Loading.eager,
              // Mobile optimization: auto reveal
              reveal: Reveal.auto,
              // Keep background consistent with app theme
              backgroundColor: const Color(0xFF1A1A1A),
              // Slightly reduce rendering cost on low-end devices
              shadowIntensity: 0.5,
            ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: const Color(0xFF1A1A1A),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0C73FE),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Загрузка 3D модели...',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          // Error state
          if (_hasError)
            Container(
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ошибка загрузки модели',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage ?? 'Неизвестная ошибка',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _hasError = false;
                          _errorMessage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C73FE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            ),

          // Model info overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _ModelInfoOverlay(
              title: widget.title,
              description: widget.description,
            ),
          ),

          // AR button overlay
          Positioned(
            top: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _launchAR(),
              backgroundColor: const Color(0xFF0C73FE),
              child: const Icon(Icons.view_in_ar, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showModelInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ModelInfoSheet(
        title: widget.title,
        description: widget.description,
        modelPath: widget.modelPath,
      ),
    );
  }

  void _shareModel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Поделиться моделью'),
        backgroundColor: Color(0xFF0C73FE),
      ),
    );
  }

  void _launchAR() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AR режим будет добавлен позже'),
        backgroundColor: Color(0xFF0C73FE),
      ),
    );
  }
}

class _ModelInfoOverlay extends StatelessWidget {
  final String title;
  final String description;

  const _ModelInfoOverlay({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A).withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C73FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3D Модель',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AR Поддержка',
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
    );
  }
}

class _ModelInfoSheet extends StatelessWidget {
  final String title;
  final String description;
  final String modelPath;

  const _ModelInfoSheet({
    required this.title,
    required this.description,
    required this.modelPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Информация о модели',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          _InfoRow(label: 'Название', value: title),
          const SizedBox(height: 12),
          _InfoRow(label: 'Описание', value: description),
          const SizedBox(height: 12),
          _InfoRow(label: 'Формат', value: 'GLB (3D модель)'),
          const SizedBox(height: 12),
          _InfoRow(label: 'Размер файла', value: '~2.5 MB'),
          const SizedBox(height: 20),

          const Text(
            'Управление',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          _ControlItem(
            icon: Icons.rotate_left,
            label: 'Поворот',
            description: 'Перетащите для поворота модели',
          ),
          _ControlItem(
            icon: Icons.zoom_in,
            label: 'Масштаб',
            description: 'Используйте жесты для масштабирования',
          ),
          _ControlItem(
            icon: Icons.pan_tool,
            label: 'Перемещение',
            description: 'Перетащите для перемещения модели',
          ),
          _ControlItem(
            icon: Icons.view_in_ar,
            label: 'AR режим',
            description: 'Нажмите кнопку AR для дополненной реальности',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ControlItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;

  const _ControlItem({
    required this.icon,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0C73FE).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF0C73FE), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model data class
class ModelData {
  final String id;
  final String title;
  final String description;
  final String modelPath;
  final String thumbnailPath;
  final bool isAREnabled;
  final String category;
  final Map<String, dynamic> metadata;

  ModelData({
    required this.id,
    required this.title,
    required this.description,
    required this.modelPath,
    required this.thumbnailPath,
    required this.isAREnabled,
    required this.category,
    required this.metadata,
  });

  // Sample models
  static List<ModelData> getSampleModels() {
    return [
      ModelData(
        id: '1',
        title: 'Исторический собор',
        description:
            '3D модель главного собора города с детальной архитектурой',
        modelPath: 'assets/models/cathedral.glb',
        thumbnailPath: 'assets/images/cathedral_thumb.jpg',
        isAREnabled: true,
        category: 'Архитектура',
        metadata: {'year': '1750', 'style': 'Барокко', 'height': '65m'},
      ),
      ModelData(
        id: '2',
        title: 'Древняя статуя',
        description: 'Археологическая находка из местного музея',
        modelPath: 'assets/models/statue.glb',
        thumbnailPath: 'assets/images/statue_thumb.jpg',
        isAREnabled: true,
        category: 'Артефакты',
        metadata: {
          'period': 'Античность',
          'material': 'Мрамор',
          'size': '1.2m',
        },
      ),
      ModelData(
        id: '3',
        title: 'Памятник героям',
        description: 'Монумент в честь героев Великой Отечественной войны',
        modelPath: 'assets/models/monument.glb',
        thumbnailPath: 'assets/images/monument_thumb.jpg',
        isAREnabled: true,
        category: 'Памятники',
        metadata: {
          'year': '1965',
          'sculptor': 'И.И. Иванов',
          'material': 'Бронза',
        },
      ),
      ModelData(
        id: '4',
        title: 'ДК Жастар',
        description: 'Дворец культуры «Жастар» в Атырау',
        modelPath: 'assets/models/dk_jastar.glb',
        thumbnailPath: 'assets/images/dk_jastar_thumb.jpg', // Placeholder
        isAREnabled: true,
        category: 'Музеи',
        metadata: {'year': '1960', 'style': 'Советский модернизм'},
      ),
      ModelData(
        id: '5',
        title: 'Женіс Саябағы',
        description: 'Экспозиция «Женіс Саябағы» (демо-модель)',
        modelPath: 'assets/models/jenis_sayabaq.glb',
        thumbnailPath: 'assets/images/jenis_sayabaq_thumb.jpg', // Placeholder
        isAREnabled: true,
        category: 'Музеи',
        metadata: {'year': '1985', 'sculptor': 'Неизвестен'},
      ),
    ];
  }
}
