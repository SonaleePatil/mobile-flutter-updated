import 'dart:async';
import 'package:adcc/core/services/location_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final VoidCallback? onNotificationTap;

  const ProfileHeader({
    super.key,
    required this.name,
    this.onNotificationTap,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with WidgetsBindingObserver {
  String _city = '';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocation();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startPeriodicRefresh() {
    int checkCount = 0;

    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      checkCount++;

      if (checkCount >= 5) {
        timer.cancel();
        return;
      }

      await _loadLocation();

      if (_city.isNotEmpty) {
        timer.cancel();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> _loadLocation() async {
    final location = await LocationStorageService.getLocation();

    if (location != null && mounted) {
      final newCity = location['city'] ?? '';

      if (newCity != _city) {
        setState(() {
          _city = newCity;
        });
      }
    }
  }

  Widget _buildAvatar() {
    final name = widget.name.trim();
    final isGuest = name.isEmpty || name == 'Welcome, Guest';

    if (isGuest) {
      return const CircleAvatar(
        radius: 26,
        backgroundColor: Color(0xFFE0E0E0),
        child: Icon(Icons.person, size: 26, color: Color(0xFF757575)),
      );
    }

    final initial = name[0].toUpperCase();
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.deepRed,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildAvatar(),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
  widget.name.trim().isEmpty ? 'Welcome, Guest' : widget.name,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/location.png',
                      height: 14,
                      width: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                   Text(
  _city.isEmpty ? 'Fetching location...' : _city,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF767779),
  ),
)
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: widget.onNotificationTap,
            child: Image.asset(
              'assets/icons/notification.gif',
              height: 60,
              width: 60,
        
            ),
          ),
        ],
      ),
    );
  }
}