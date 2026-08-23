import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:nantib_chamnab_ticket_digital/app_theme.dart';
import 'package:nantib_chamnab_ticket_digital/screens/image_viewer_screen.dart';

class ImageBlock extends StatelessWidget {
  const ImageBlock({super.key});

  static const List<String> listImages = [
    'assets/images/019A9261.JPG',
    'assets/images/019A9268.jpg',
    'assets/images/019A9305.JPG',
    'assets/images/019A9413.jpg',
    'assets/images/019A9407.jpg',
    'assets/images/019A9408.jpg',
    'assets/images/019A9419.jpg',
    'assets/images/019A9423q.jpg',
    'assets/images/019A9418.jpg',
    'assets/images/019A9408.jpg',
    'assets/images/019A9430.jpg',
    'assets/images/019A9453.JPG',
  ];

  static const double _spacing = 16;
  static const double _imageHeight = 300;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'assets/images/img_icons-removebg-preview.png',
            height: 70,
            width: 70,
            color: AppTheme.primaryPurple,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'វិចិត្រសាល',
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'KHMEROSMUOLLIGHT',
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 50),
          FanCarouselImageSlider.sliderType1(
            imagesLink: listImages,
            isAssets: false,
            autoPlay: true,
            sliderHeight: 400,
            showIndicator: true,
          ),
          const SizedBox(height: 16),
          _imageLayout(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _imageLayout(BuildContext context) {
    return Column(
      children: [
        _fullWidthImage(context, 0),
        const SizedBox(height: _spacing),
        _pairRow(context, 1, 2),
        const SizedBox(height: _spacing),
        _fullWidthImage(context, 7),
        const SizedBox(height: _spacing),
        _pairRow(context, 11, 5),
        const SizedBox(height: _spacing),
        _fullWidthImage(context, 6),
        const SizedBox(height: _spacing),
        _pairRow(context, 7, 8),
        const SizedBox(height: _spacing),
        _pairRow(context, 9, 10),
      ],
    );
  }

  Widget _fullWidthImage(BuildContext context, int index) {
    return _networkImage(context, index, height: 400);
  }

  Widget _centeredImage(BuildContext context, int index) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: _networkImage(context, index, height: _imageHeight),
      ),
    );
  }

  Widget _pairRow(BuildContext context, int leftIndex, int rightIndex) {
    return Row(
      children: [
        Expanded(
          child: _networkImage(context, leftIndex, height: _imageHeight),
        ),
        const SizedBox(width: _spacing),
        Expanded(
          child: _networkImage(context, rightIndex, height: _imageHeight),
        ),
      ],
    );
  }

  Widget _networkImage(
    BuildContext context,
    int index, {
    required double height,
  }) {
    final url = listImages[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    ImageViewerScreen(images: listImages, initialIndex: index),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          url,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined),
            );
          },
        ),
      ),
    );
  }
}
