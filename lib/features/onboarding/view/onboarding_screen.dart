import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';
import 'package:adcc/features/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:adcc/features/auth/view/register_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  List<OnboardingSlideModel> _slides = const [];

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    _viewModel.loadSlides();
  }

  void _onVmChanged() {
    if (!mounted) return;
    setState(() {
      _slides = _viewModel.slides;
      if (_currentPage >= _slides.length && _slides.isNotEmpty) {
        _currentPage = _slides.length - 1;
      }
    });
  }

  void _onButtonPressed() {
    if (_slides.isEmpty) return;

    if (_currentPage < _slides.length - 1) {
      // Move to next slide
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last slide - navigate to login
      _navigateToLogin();
    }
  }

  void _skipToLogin() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_slides.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
          // PageView Slider (only background, title, description)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return OnboardingSlide(
                data: _slides[index],
              );
            },
          ),

          // Skip Button (always visible)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipToLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Static Pagination Dots
          Positioned(
            bottom: 125,
            left: 0,
            right: 0,
            child: _slides.isEmpty ? const SizedBox.shrink() : _buildPaginationDots(),
          ),

          // Static Button
          Positioned(
              bottom: 0,
              left: 24,
              right: 24,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      backgroundColor: AppColors.deepRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            _slides.isEmpty ? 'Next' : _slides[_currentPage].buttonText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/right_arrow_head.png',
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? AppColors.deepRed
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideModel data;

  const OnboardingSlide({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final showArc3 = data.imagePath.contains('onboarding3.png');
    final showArc4 = data.imagePath.contains('onboarding4.png');

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: data.imagePath.startsWith('http')
              ? Image.network(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                )
              : Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Placeholder if image not found
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (showArc3)
          Positioned(
            top: 162,
            left: 40,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: 2.4,
                child: const SizedBox(
                  width: 324,
                  height: 325,
                  child: _OnboardingArc(),
                ),
              ),
            ),
          ),

        if (showArc4)
          const Positioned(
            top: 120,
            left: -100,
            right: -140,
            child: IgnorePointer(
              child: Center(
                child: SizedBox.square(
                  dimension: 300,
                  child: _OnboardingArc(
                    rotation: 0,
                    startAngle: 2.8,
                    sweepAngle: 3.68,
                    strokeWidth: 35,
                  ),
                ),
              ),
            ),
          ),

        Positioned.fill(
          child: Image.asset(
            data.imagePath,
            fit: BoxFit.cover,
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),


        SafeArea(
          child: Column(
            children: [
              const Spacer(),

         
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
Text(
      data.title.toUpperCase(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: "Outfit",
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
      ),
    ),

                    const SizedBox(height: 12),
                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                         fontFamily: "Outfit",
                        fontSize: 13,
                        height: 1.2,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    
                  ],
                ),
              ),

              const SizedBox(height: 160),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnboardingArc extends StatelessWidget {
  final double rotation;
  final double startAngle;
  final double sweepAngle;
  final double strokeFactor;
  final double? strokeWidth;

  const _OnboardingArc({
    this.rotation = 0.35,
    this.startAngle = 2.45,
    this.sweepAngle = 3.55,
    this.strokeFactor = 0.16,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OnboardingArcPainter(
        rotation: rotation,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        strokeFactor: strokeFactor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _OnboardingArcPainter extends CustomPainter {
  final double rotation;
  final double startAngle;
  final double sweepAngle;
  final double strokeFactor;
  final double? strokeWidth;

  _OnboardingArcPainter({
    required this.rotation,
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeFactor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = strokeWidth ?? (size.shortestSide * strokeFactor);
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFB88900),
          Color(0xFFF1C55A),
        ],
      ).createShader(rect);

    // A partial ring similar to the onboarding arc, rotated towards the top-right.
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OnboardingArcPainter oldDelegate) => false;
}
