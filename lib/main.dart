import 'dart:async';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/services/language_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/view/splash_screen.dart';
import 'features/onboarding/view/onboarding_screen.dart';
import 'features/challenges/view/my_challenges_screen.dart';
import 'features/languageOption/view/languageSelectionScreen.dart';
import 'package:adcc/features/auth/view/setupProfile/setup_profile_screen.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/store/view/listings_screen.dart';
import 'package:adcc/features/store/view/live_posted_screen.dart';
import 'package:adcc/features/challenges/view/leaderboard_screen.dart';
import 'package:adcc/features/challenges/view/challenge_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('[Firebase] Initialization timeout');
          throw TimeoutException('Firebase initialization timed out');
        },
      );
      print('[Firebase] Initialized successfully from Dart');
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: false,
      );
    }
  } catch (e) {
    print('[Firebase] Initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final saved = await LanguageStorageService.getLocaleCode();
    if (!mounted) return;
    if (saved == null) return;
    setState(() {
      _locale = Locale(saved);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADCC Mobile App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en'), Locale('ar')],

      home: const SplashScreen(),
      // home: const ChallengeDetailsScreen(
      //   challengeId: 'challenge_1',
      // ),
      // home: const LeaderboardScreen(),
      // home: const LivePostedScreen(
      //   title: 'Trek Domane',
      //   price: '7500 AED',
      // ),
      // home: const StoreScreen(),
      // home: const ListingsScreen(),
      // home: const SetupProfileScreen(),
      // home: const LanguageSelectionScreen(),
      // home: const OnboardingScreen(),
      // home: const MyChallengesScreen(),
    );
  }
}
