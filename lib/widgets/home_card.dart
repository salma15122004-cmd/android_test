import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// بيانات الكارت الواحد
class HomeItem {
  final String title;
  final String subtitle;
  final String image;
  final String? secondimage;
  final Color color;
  final bool circleImage;
  final VoidCallback? onTap;

  const HomeItem({
    required this.title,
    required this.subtitle,
    required this.image,
    this.secondimage,
    required this.color,
    this.circleImage = false,
    this.onTap,
  });
}

// شكل الكارت
class HomeCard extends StatelessWidget {
  final HomeItem item;

  const HomeCard({super.key, required this.item});

  Widget _buildImage() {
    if (item.secondimage != null) {
      return SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.image,
              width: 65,
              height: 65,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Image.asset(
                item.secondimage!,
                width: 42,
                height: 42,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    }

    if (!item.circleImage) {
      return SizedBox(
        height: 56,
        child: Image.asset(item.image, fit: BoxFit.contain),
      );
    }

    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: white,
      ),
      child: ClipOval(
        child: Image.asset(item.image, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: shadow, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}