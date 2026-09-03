import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _InitApp());
}

/// Shown while Firebase.initializeApp() completes.
/// Once done it swaps itself out for the real app tree.
class _InitApp extends StatefulWidget {
  const _InitApp();

  @override
  State<_InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<_InitApp> {
  late final Future<FirebaseApp> _init;

  @override
  void initState() {
    super.initState();
    _init = Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _init,
      builder: (context, snapshot) {
        // Still initializing — show the branded splash immediately
        // so the user never sees the plain Flutter loading screen.
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const _FirebaseLoadingScreen(),
          );
        }

        // Firebase init failed — show error
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: _FirebaseErrorScreen(error: snapshot.error.toString()),
          );
        }

        // Firebase ready — boot the full app
        return const LaptopHarborApp();
      },
    );
  }
}

class LaptopHarborApp extends StatelessWidget {
  const LaptopHarborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}

// ── Loading screen shown while Firebase boots ────────────────────────────────
class _FirebaseLoadingScreen extends StatelessWidget {
  const _FirebaseLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.laptop_mac_rounded,
                    size: 96, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'LaptopHarbor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'PRECISION ENGINEERED',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error screen shown if Firebase fails to init ─────────────────────────────
class _FirebaseErrorScreen extends StatelessWidget {
  final String error;
  const _FirebaseErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  size: 64, color: AppColors.error),
              const SizedBox(height: 24),
              const Text(
                'Could not connect to services',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Check your internet connection and restart the app.',
                style: TextStyle(
                    fontSize: 14, color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
