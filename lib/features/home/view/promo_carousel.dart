import 'package:flutter/material.dart';
import 'promo_card.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {

  final PageController _controller = PageController(
    viewportFraction: 0.92,
    initialPage: 1,
  );

  final List<PromoData> _items = [
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'New to Abu Dhabi\nCycling Club?',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a ride',
    ),
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'Ride Together\nRide Stronger',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a ride',
    ),
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'Explore Abu Dhabi\nCycling Routes',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a ride',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _controller,
        itemCount: _items.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: PromoCard(data: _items[index]),
          );
        },
      ),
    );
  }
}