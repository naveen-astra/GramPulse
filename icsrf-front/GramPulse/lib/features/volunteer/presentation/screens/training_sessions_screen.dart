import 'package:flutter/material.dart';

class TrainingSessionsScreen extends StatelessWidget {
  const TrainingSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Training Sessions Screen - Under Development'),
      ),
    );
  }
}
