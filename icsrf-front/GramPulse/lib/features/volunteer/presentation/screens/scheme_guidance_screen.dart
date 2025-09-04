import 'package:flutter/material.dart';

class SchemeGuidanceScreen extends StatelessWidget {
  const SchemeGuidanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Guidance'),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Scheme Guidance Screen - Under Development'),
      ),
    );
  }
}
