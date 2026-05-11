import 'package:flutter/material.dart';
import 'promo_card.dart';

class PromoCarousel extends StatefulWidget {
  final List<PromoData> items;
  final bool showFallback;

  const PromoCarousel({
    super.key,
    this.items = const [],
    this.showFallback = true,
  });

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController(
    viewportFraction: 0.92,
    initialPage: 1,
  );

  final List<PromoData> _fallbackItems = [
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'New to Abu Dhabi\nCycling Club?',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a Route',
    ),
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'Ride Together\nRide Stronger',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a Route',
    ),
    PromoData(
      image: 'assets/images/cycling_1.png',
      title: 'Explore Abu Dhabi\nCycling Routes',
      subtitle: 'Join Your',
      highlight: 'First Community Ride',
      buttonText: 'Find a Route',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = widget.items.isEmpty
        ? (widget.showFallback ? _fallbackItems : const <PromoData>[])
        : widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _controller,
        itemCount: items.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: PromoCard(data: items[index]),
          );
        },
      ),
    );
  }
}
