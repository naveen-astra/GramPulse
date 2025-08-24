import 'package:flutter/material.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

class FullScreenMediaView extends StatefulWidget {
  final List<MediaModel> media;
  final int initialIndex;

  const FullScreenMediaView({
    Key? key,
    required this.media,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullScreenMediaView> createState() => _FullScreenMediaViewState();
}

class _FullScreenMediaViewState extends State<FullScreenMediaView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1}/${widget.media.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.media.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.network(
                  widget.media[index].url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
