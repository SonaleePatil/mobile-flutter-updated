import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class RouteActionButtonsSection extends StatelessWidget {
  final VoidCallback? onOpenLinkMyRide;
  final VoidCallback? onOpenMaps;

  const RouteActionButtonsSection({
    super.key,
    this.onOpenLinkMyRide,
    this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Open in Link My Ride Button
         AppButton(
  label: 'Open in Link My Ride',
  onPressed: onOpenLinkMyRide,
  type: AppButtonType.primary,
  backgroundColor: AppColors.deepRed,
  suffixImage: "assets/icons/units.png",
  suffixImageColor: Colors.white,
),
          const SizedBox(height: 12),
          // Open in Maps Button
         AppButton(
  label: 'Open in Maps',
  onPressed: onOpenMaps,
  type: AppButtonType.secondary,
  borderColor: AppColors.deepRed,
  textColor: AppColors.deepRed,
  backgroundColor: Colors.transparent,
  suffixImage: "assets/icons/units.png",
  suffixImageColor: AppColors.deepRed,
),
        ],
      ),
    );
  }
}
