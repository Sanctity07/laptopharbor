import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../onboarding/onboarding_screen.dart';
import '../root_shell.dart';

/// Splash reveal: logo scale/glow-in, name + tagline fade-in, then
/// auto-advances to the onboarding carousel. Mirrors the Stitch
/// `#splash-layer` timing (~2.5s hold, 1s cross-fade out).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      final destination = authProvider.status == AuthStatus.authenticated
          ? const RootShell()
          : const OnboardingScreen();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
            opacity: animation,
            child: destination,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Stack(
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
                        const Icon(Icons.laptop_mac_rounded, size: 96, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: _titleOpacity.value,
                  child: Text(
                    'LaptopHarbor',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: _taglineOpacity.value,
                  child: Text(
                    'PRECISION ENGINEERED',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 3,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
