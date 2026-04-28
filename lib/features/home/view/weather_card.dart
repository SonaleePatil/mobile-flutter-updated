import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final String time;
  final int temperature;
  final int highTemp;
  final int lowTemp;
  final String weatherIcon;

  const WeatherCard({
    super.key,
    required this.city,
    required this.time,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 120,
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background decorative arcs
            Positioned(
              bottom: -80,
              left: 110,
              child: Container(
                width: 130,
                height:180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: 75,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.08),
                ),
              ),
            ),
             Positioned(
              bottom: -30,
              left: 135,
              child: Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT SIDE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
  l10n.currentLocation,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                        const SizedBox(height: 4),
                       Text(
  city,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                        const SizedBox(height: 12),
                       Text(
  time,
  style: theme.textTheme.bodySmall?.copyWith(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1,
  ),
)
                      ],
                    ),
                  ),

                  // RIGHT SIDE
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Image.asset(weatherIcon, width: 36, height: 36),
                          const SizedBox(width: 8),
                         Text(
  '$temperature${l10n.temperatureUnit}',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
)
                        ],
                      ),
                      const SizedBox(height: 8),
                     Text(
  '${l10n.highTemp}:$highTemp${l10n.temperatureUnit}   '
  '${l10n.lowTemp}:$lowTemp${l10n.temperatureUnit}',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
