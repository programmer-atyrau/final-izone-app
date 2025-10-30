import 'model_viewer_screen.dart';
import 'package:flutter/material.dart';

class CategoryModelsScreen extends StatelessWidget {
  final String category;

  const CategoryModelsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter models based on the selected category
    final allModels = ModelData.getSampleModels();
    final filteredModels = allModels
        .where((model) => model.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(category), backgroundColor: Colors.grey[900]),
      backgroundColor: Colors.grey[850],
      body: filteredModels.isEmpty
          ? const Center(
              child: Text(
                'В этой категории пока нет моделей.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredModels.length,
              itemBuilder: (context, index) {
                final model = filteredModels[index];
                return Card(
                  color: Colors.grey[800],
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      // You can use model.thumbnailPath here if you have images
                      child: const Icon(
                        Icons.threed_rotation,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      model.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      model.description,
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModelViewerScreen(
                            modelPath: model.modelPath,
                            title: model.title,
                            description: model.description,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
