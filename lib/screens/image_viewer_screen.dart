import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const ImageViewerScreen({Key? key, required this.images, required this.initialIndex}) : super(key: key);

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.images.length) return;
    _controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('${_currentIndex + 1}/${widget.images.length}'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.asset(
                    widget.images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white70,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 8,
            top: MediaQuery.of(context).size.height / 2 - 28,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => _goTo(_currentIndex - 1),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: MediaQuery.of(context).size.height / 2 - 28,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => _goTo(_currentIndex + 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

