import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';

class ServiceIntegration {
  final String name;
  final VoidCallback? onConnect;

  const ServiceIntegration({
    required this.name,
    this.onConnect,
  });
}

class RouteDetailsIntegrationSection extends StatelessWidget {
  final List<ServiceIntegration> services;

  const RouteDetailsIntegrationSection({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
  'Route Details',
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
        const SizedBox(height: 12),
        Column(
          children: services.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            final isLast = index == services.length - 1;
            
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E3176).withValues(alpha: 0.1), 
                      offset: const Offset(0, 4.38),
                      blurRadius: 30.65,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
  service.name,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13.1376,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0.13,
    color: AppColors.charcoal,
  ),
)
                    ),
                    AppButton(
                      label: 'Connect',
                    
                      onPressed: service.onConnect,
                      type: AppButtonType.primary,
                      backgroundColor: AppColors.dustyRose,
                      textColor: AppColors.textDark,
                      width: 100,
                      height: 36,
                      borderRadius: 8,
                     textStyle: const TextStyle(
  fontFamily: 'Outfit',
  fontSize: 13,
  fontWeight: FontWeight.w500,
  height: 1, // 100% line height
  letterSpacing: 0,
  color: AppColors.charcoal,
),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

