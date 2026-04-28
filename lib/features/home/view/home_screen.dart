import 'package:adcc/core/services/location_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/view/events.dart';
import 'package:adcc/features/home/view/home_tab.dart';
import 'package:adcc/features/routes/view/routes_screen.dart';
import 'package:adcc/features/profile/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/services/permission_service.dart';

import '../../../shared/widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  final bool fromGuest;

  const HomeScreen({
    super.key,
    this.fromGuest = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _hasRequestedPermissions = false;

  List<Widget> get _pages => [
        HomeTab(
          onTabChange: _changeTab,
          fromGuest: widget.fromGuest,
        ),
        const EventsTab(),
        const RoutesTab(),
        const ProfileScreen(),
      ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  /// Request location permissions when user signs in
  Future<void> _requestPermissions() async {
    if (_hasRequestedPermissions) return;

    // Check if permission is already granted
    bool isGranted = await PermissionService.isLocationPermissionGranted();
    _hasRequestedPermissions = true;

    if (isGranted) {
      _hasRequestedPermissions = true;
      await PermissionService.requestLocationPermission(context);

      return;
    }

    final locationData = await PermissionService.getLocationWithCity(context);

    if (locationData != null) {
      await LocationStorageService.saveLocation(
        latitude: locationData['latitude'],
        longitude: locationData['longitude'],
        city: locationData['city'],
      );

      setState(() {});
    }
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        body: _pages[_currentIndex],
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
