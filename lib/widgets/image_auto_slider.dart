import 'dart:async';

import 'package:flutter/material.dart';

import '../app_theme.dart';

class ImageAutoSlider extends StatefulWidget {
  const ImageAutoSlider({
    super.key,
    required this.images,
    this.height = 320,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.viewportFraction = 0.88,
    this.onImageTap,
  });

  final List<String> images;
  final double height;
  final Duration autoPlayInterval;
  final double viewportFraction;
  final ValueChanged<String>? onImageTap;

  @override
  State<ImageAutoSlider> createState() => _ImageAutoSliderState();
}

class _ImageAutoSliderState extends State<ImageAutoSlider> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.images.length <= 1) return;
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_currentIndex + 1) % widget.images.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _pauseAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightLavender,
            AppTheme.lavender.withOpacity(0.55),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.photo_library_rounded,
          size: 48,
          color: AppTheme.primaryPurple.withOpacity(0.55),
        ),
      ),
    );
  }

  Widget _buildSlide(String asset, bool active) {
    final scale = active ? 1.0 : 0.94;
    final verticalPadding = active ? 0.0 : 12.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: verticalPadding),
      transform: Matrix4.identity()..scale(scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(active ? 0.18 : 0.08),
            blurRadius: active ? 22 : 12,
            offset: Offset(0, active ? 12 : 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(height: widget.height, child: _buildPlaceholder());
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _pauseAutoPlay();
              } else if (notification is ScrollEndNotification) {
                _startAutoPlay();
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                if (!mounted) return;
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final asset = widget.images[index];
                return GestureDetector(
                  onTap: widget.onImageTap == null ? null : () => widget.onImageTap!(asset),
                  child: _buildSlide(asset, index == _currentIndex),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            final active = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: active ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: active ? AppTheme.primaryPurple : AppTheme.lavender,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}
