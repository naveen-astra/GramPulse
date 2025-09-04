import 'package:flutter/material.dart';

class SHGSupportScreen extends StatelessWidget {
  const SHGSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHG Support'),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('SHG Support Screen - Under Development'),
      ),
    );
  }
}
