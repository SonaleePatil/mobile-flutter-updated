import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/onboarding/view/onboarding_screen.dart';
import '../../../main.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'en';

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await LanguageStorageService.getLocaleCode();
    if (!mounted) return;
    if (saved == null) return;
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.softCream,

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: (ModalRoute.of(context)?.canPop ?? false)
                      ? IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        )
                      : const SizedBox(height: 48),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Image.asset(
                    'assets/images/lang_icon.png',
                    width: 56,
                    height: 56,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${l10n.choose} ${l10n.language}'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 78),
                _LanguageOptionTile(
                  label: 'ENGLISH',
                  leadingAsset: 'assets/images/en-country.png',
                  selected: _selected == 'en',
                  onTap: () => setState(() => _selected = 'en'),
                ),
                const SizedBox(height: 14),
                _LanguageOptionTile(
                  label: 'ARABIC',
                  leadingAsset: 'assets/images/ar-country.png',
                  selected: _selected == 'ar',
                  onTap: () => setState(() => _selected = 'ar'),
                ),
                const Spacer(),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(l10n.continue_button.toUpperCase()),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        height: 76,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1E1B8) : const Color(0xFFE9E1D4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.deepRed : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Image.asset(leadingAsset, width: 28, height: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selected ? AppColors.deepRed : const Color(0xFF8A8A8A),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.deepRed,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
