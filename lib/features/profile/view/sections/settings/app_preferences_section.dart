import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppPreferencesSection extends StatelessWidget {
  final bool darkMode;
  final Function(bool) onDarkModeChanged;

  const AppPreferencesSection({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      const Text(
  "App Preferences",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.43,
    letterSpacing: -0.22,
    color: AppColors.charcoal,
  ),
),

        const SizedBox(height: 8),

        /// FIRST CARD
        Container(
          width: 358,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFD7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [

              _ArrowTile(
                image: "assets/icons/language.png",
                title: "Language",
                subtitle: "English",
              ),

              const Divider(height: 1),

              _ArrowTile(
                image: "assets/icons/units.png",
                title: "Units",
                subtitle: "Metric (km, kg)",
              ),

              const Divider(height: 1),

              _ArrowTile(
                image: "assets/icons/distance.png",
                title: "Map Style",
                subtitle: "Standard",
              ),

              const Divider(height: 1),

              _SwitchTile(
             image: "assets/icons/dark_mode.png",
                title: "Dark Mode",
                subtitle: "Coming soon",
                value: darkMode,
                onChanged: onDarkModeChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: 39),

        /// SECOND TITLE
       const Text(
  "App Preferences",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.43,
    letterSpacing: -0.22,
    color: AppColors.charcoal,
  ),
),

        const SizedBox(height: 8),

        /// SECOND CARD
        Container(
          width: 358,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFD7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [

              _SimpleTile(title: "Help Center"),

              Divider(height: 1),

              _SimpleTile(title: "Terms & Conditions"),

              Divider(height: 1),

              _SimpleTile(title: "Privacy Policy"),

              Divider(height: 1),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child:Column(
  children: const [
    Text(
      "App Version",
      style: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.charcoal,
      ),
    ),
    SizedBox(height: 1),
    Text(
      "v1.0.0 (Build 100)",
      style: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFA3A3A3),
      ),
    ),
  ],
)
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArrowTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _ArrowTile({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [

            Image.asset(
              image,
              width: 20,
              height: 20,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                 Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal
  ),
),

                  const SizedBox(height: 2),

Text(
  subtitle,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0,
    color: Color(0XFF525252),
  ),
)
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SwitchTile({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [

            Image.asset(
              image,
              width: 20,
              height: 20,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

           Transform.scale(
  scale: 0.85,
  child: Switch(
    value: value,
    onChanged: onChanged,
    trackColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFC12D32); // ON background color
      }
      return const Color(0xFFD1D5DC); 
    }),
    thumbColor: MaterialStateProperty.all(Colors.white),
  ),
),
          ],
        ),
      ),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  final String title;

  const _SimpleTile({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
Text(
  title,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
  ),
),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}