import 'package:adcc/features/profile/view/sections/profile/my_badge_section.dart';
import 'package:adcc/features/profile/view/sections/profile/my_communities_section.dart';
import 'package:adcc/features/profile/view/sections/profile/my_joined_events_section.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../sections/profile/profile_header_section.dart';
import '../sections/profile/profile_menu_section.dart';
import '../sections/profile/route_details_integration_section.dart';
import '../sections/guest_screen/guest_profile_section.dart';
import '../../../auth/view/register_screen.dart';
import '../../../auth/view/email_password_login_screen.dart';
import '../../../events/view/events_screen.dart';
import '../../../communities/view/community_screen.dart';
import '../../../routes/view/routes_screen_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = true;
  final ProfileViewModel _profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    _profileViewModel.addListener(_onProfileChanged);
    _checkAuthentication();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _profileViewModel.removeListener(_onProfileChanged);
    _profileViewModel.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await TokenStorageService.isAuthenticated();
    if (isAuthenticated) {
      await _profileViewModel.loadProfile();
    }
    if (mounted) {
      setState(() {
        _isAuthenticated = isAuthenticated;
        _isCheckingAuth = false;
      });
    }
  }


  Future<void> _handleLogout() async {
    if (_isLoggingOut) return; 

    setState(() {
      _isLoggingOut = true;
    });

    try {
      
      final refreshToken = await TokenStorageService.getRefreshToken();

  
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final apiClient = ApiClient.instance;
          final requestData = {
            'refreshToken': refreshToken,
          };

          debugPrint(' [Logout API] Request URL: ${ApiEndpoints.authLogout}');
          debugPrint(' [Logout API] Request Body: $requestData');

          final response = await apiClient.post<dynamic>(
            ApiEndpoints.authLogout,
            data: requestData,
          );

          debugPrint(
              ' [Logout API] Response Status Code: ${response.statusCode}');
          debugPrint(' [Logout API] Response Body: ${response.data}');

          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            debugPrint(' [Logout API] Logout successful');
          } else {
            debugPrint(
                ' [Logout API] Logout API returned non-success status');
    
          }
        } on DioException {
        
         
        } catch (e) {
       
         
        }
      } else {
        debugPrint(' [Logout] No refresh token found, skipping API call');
      }

      await TokenStorageService.clearTokens();
      debugPrint(' [Logout] Local tokens cleared');


      if (mounted) {
        setState(() {
          _isAuthenticated = false;
        });
      }
    } catch (e) {
    

      await TokenStorageService.clearTokens();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const RegisterScreen(),
          ),
          (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _handleSignUpLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EmailPasswordLoginScreen(),
      ),
    );
  
    _checkAuthentication();
  }

  void _handleBrowseEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EventsScreen(),
      ),
    );
  }

  void _handleExploreCommunity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CommunitiesScreen(),
      ),
    );
  }

  void _handleViewRoutes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoutesScreenWrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    if (_isCheckingAuth) {
      return Container(
        color: AppColors.softCream,
        child: const SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show guest profile screen if not authenticated
    if (!_isAuthenticated) {
      return Container(
        color: AppColors.softCream,
        child: SafeArea(
          child: Column(
            children: [
              // Header with Profile title
             Container(
  color: const Color(0xFFFFF9EF), // Background color
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  child: Stack(
    alignment: Alignment.center,
    children: [

      Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE8B4B4), // soft red circle
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFFC12D32),
              size: 22,
            ),
          ),
        ),
      ),

    
      const Text(
  'Profile',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 25,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
    ],
  ),
),
              // Guest Profile Content
              Expanded(
                child: GuestProfileSection(
                  onSignUpLogin: _handleSignUpLogin,
                  onBrowseEvents: _handleBrowseEvents,
                  onExploreCommunity: _handleExploreCommunity,
                  onViewRoutes: _handleViewRoutes,
                ),
              ),
            ],
          ),
        ),
      );
    }

 
    return Container(
    color: AppColors.softCream,
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: 100, 
          ),
          children: [
          
            ProfileHeaderSection(
              name: _profileViewModel.profile?.fullName ?? '',
              location: _profileViewModel.profile?.city ?? 'Abu Dhabi City',
              skillLevel: _profileViewModel.profile?.skillLevel ?? 'Intermediate rider',
              profileImageUrl: _profileViewModel.profile?.image?.startsWith('http') == true
                  ? _profileViewModel.profile!.image
                  : null,
              stats: {
                'km': _profileViewModel.profile?.km ?? '2,340',
                'rides': _profileViewModel.profile?.rides ?? '126',
                'events': _profileViewModel.profile?.events ?? '14',
              },
            ),
        
const MyBadgesSection(),
const SizedBox(height: 41),

const MyCommunitiesSection(),
const SizedBox(height: 49),

const MyJoinedEventsSection(),

const SizedBox(height: 50),

 ProfileMenuSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Route Details Integration
                  RouteDetailsIntegrationSection(
                    services: [
                      ServiceIntegration(
                        name: 'Garmin',
                        onConnect: () {
                    
                          debugPrint('Connect Garmin tapped');
                        },
                      ),
                      ServiceIntegration(
                        name: 'Wahoo',
                        onConnect: () {
                     
                          debugPrint('Connect Wahoo tapped');
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 50),
             
                  AppButton(
                   label: _isLoggingOut ? 'Logging out...' : 'Logout',
textStyle: const TextStyle(
  fontFamily: 'Outfit',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1, // 100% line height
  letterSpacing: 0,
  color: Colors.white,
),
                    onPressed: _isLoggingOut ? null : _handleLogout,
                    type: AppButtonType.danger,
                    backgroundColor: AppColors.deepRed,
                  ),
                  const SizedBox(height: 95),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
