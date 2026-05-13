import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/features/onboarding/view/onboarding_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  static final Uri _backgroundVideoUrl = Uri.parse(
    'https://adcc-frontend.s3.amazonaws.com/event+-+F1.mp4',
  );

  String _selected = 'en';
  late final VideoPlayerController _videoController;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _loadSaved();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.networkUrl(_backgroundVideoUrl);
    try {
      await _videoController.initialize();
      if (!mounted) return;
      await _videoController.setLooping(true);
      await _videoController.setVolume(0);
      await _videoController.play();
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _videoFailed = true);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final saved = await LanguageStorageService.getLocaleCode();
    if (!mounted || saved == null) return;
    setState(() => _selected = saved);
  }

  Future<void> _continue() async {
    await LanguageStorageService.setLocaleCode(_selected);
    if (!mounted) return;
    MyApp.setLocale(context, Locale(_selected));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final horizontalPadding = size.width < 360 ? 12.0 : 14.0;

    // Figma: title top ≈ 507px, screen height 844px → title starts at ~60.1% from top
    // Figma: language buttons top = 624px → 73.9% from top
    // Gap between title bottom (507+60=567) and buttons top (624) = 57px
    // Gap between buttons bottom (624+53=677) and continue top ≈ 18px (isShortScreen) / 22px
    final isShortScreen = size.height < 700;

    // The title should start at ~60% of screen height
    const titleTopFraction = 0.601;
    final titleTopPx = size.height * titleTopFraction;

    // Gap from title bottom (title height = 60px) to language row
    final titleToButtonsGap = isShortScreen ? 36.0 : 57.0;

    // Gap from language row to continue button
    final buttonsToCtaGap = isShortScreen ? 12.0 : 18.0;

    // Bottom safe area padding
    final bottomPadding = (isShortScreen ? 10.0 : 16.0) + bottomInset;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video, with image fallback while loading or if remote video fails.
          if (!_videoController.value.isInitialized || _videoFailed)
            Image.asset(
              'assets/images/onboarding33.png',
              fit: BoxFit.cover,
            )
          else
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          // Gradient overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x1F000000),
                  Color(0x9E000000),
                ],
              ),
            ),
          ),
          // Back button (top-left)
          if (canPop)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  top: 6,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: _TopBackButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          // Main content: positioned using a Stack so title lands at exactly ~60% from top
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: titleTopPx,
            bottom: bottomPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 259),
                  child: const Text(
                    'WELCOME TO ABU\nDHABI CYCLING CLUB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0,
                      color: Color(0xFFFFF9EF),
                    ),
                  ),
                ),
                SizedBox(height: titleToButtonsGap),
                // Language option tiles
                Row(
                  children: [
                    Expanded(
                      child: _LanguageOptionTile(
                        label: 'ENGLISH',
                        leadingAsset: 'assets/images/en-country.png',
                        selected: _selected == 'en',
                        onTap: () => setState(() => _selected = 'en'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LanguageOptionTile(
                        label: 'ARABIC',
                        leadingAsset: 'assets/images/ar-country.png',
                        selected: _selected == 'ar',
                        onTap: () => setState(() => _selected = 'ar'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: buttonsToCtaGap),
                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0359E8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.continue_button,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _TopBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.24),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 35,
          height: 35,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String label;
  final String leadingAsset;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.label,
    required this.leadingAsset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 53,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF09802)
              : Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: const Color(0xFFEFE3CA), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Image.asset(leadingAsset, width: 22, height: 22),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFC12D32)
                      : const Color(0xFF898989),
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFC12D32),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
