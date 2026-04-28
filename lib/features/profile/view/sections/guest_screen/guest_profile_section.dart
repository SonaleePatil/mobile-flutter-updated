import 'package:flutter/material.dart';
import 'package:adcc/features/languageOption/view/languageSelectionScreen.dart';
import '../../../../../core/theme/app_colors.dart';

class GuestProfileSection extends StatelessWidget {
  final VoidCallback onSignUpLogin;
  final VoidCallback onBrowseEvents;
  final VoidCallback onExploreCommunity;
  final VoidCallback onViewRoutes;

  const GuestProfileSection({
    super.key,
    required this.onSignUpLogin,
    required this.onBrowseEvents,
    required this.onExploreCommunity,
    required this.onViewRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF9EF),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 110),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  /// Profile Icon
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Color(0xFFD4AF37),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Image.asset(
                          'assets/icons/profile.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    'Welcome to ADCC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Sign up to join events, connect with the community, and track your cycling journey.',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.3, // Proper spacing
                        letterSpacing: 0.14,
                        color: AppColors.charcoal.withOpacity(0.95),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Button
                  SizedBox(
                    width: 328,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: onSignUpLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC12D32),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Up / Login',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available as a guest:',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: Color(0xFF1A1C20),
                  ),
                ),
                const SizedBox(height: 18),
                _GuestOptionButton(
                  label: 'Browse Events',
                  onTap: onBrowseEvents,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'Explore Community',
                  onTap: onExploreCommunity,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'View Tracks',
                  onTap: onViewRoutes,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'Language',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelectionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GuestOptionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13.3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          decoration: BoxDecoration(
            color: const Color(0xFFE9E4DB),
            borderRadius: BorderRadius.circular(13.3),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.charcoal,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
