import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import 'onboarding_slide.dart';

/// Onboarding carousel — mirrors the Stitch HTML: auto-playing slide
/// track, dot indicators, "Next Step" / "Get Started" primary CTA,
/// outlined "Create Account", and a "Sign In" text link.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  Timer? _autoPlayTimer;
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final next = (_currentSlide + 1) % onboardingSlides.length;
      _goToSlide(next);
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void _goToSlide(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleNext() {
    _stopAutoPlay();
    if (_currentSlide < onboardingSlides.length - 1) {
      _goToSlide(_currentSlide + 1);
    } else {
      _launch();
    }
  }

  void _launch() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastSlide = _currentSlide == onboardingSlides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient background blobs, matching the Stitch atmospheric bg.
          Positioned(
            top: -80,
            right: -80,
            child: _blob(AppColors.primaryFixed.withValues(alpha: 0.3), 320),
          ),
          Positioned(
            bottom: 40,
            left: -100,
            child: _blob(AppColors.tertiaryFixed.withValues(alpha: 0.25), 280),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.laptop_mac_rounded, size: 26, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'LaptopHarbor',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _launch,
                        child: Text(
                          'Skip',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),

                // Carousel
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: GestureDetector(
                        onPanDown: (_) => _stopAutoPlay(),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: onboardingSlides.length,
                          onPageChanged: (index) => setState(() => _currentSlide = index),
                          itemBuilder: (context, index) {
                            final slide = onboardingSlides[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: CachedNetworkImage(
                                        imageUrl: slide.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: AppColors.surfaceContainer),
                                        errorWidget: (context, url, error) => Container(
                                          color: AppColors.surfaceContainer,
                                          child: const Icon(Icons.image_outlined, color: AppColors.outline, size: 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.stackLg),
                                  Text(
                                    slide.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.stackSm),
                                  Text(
                                    slide.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Dot indicators
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.stackMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingSlides.length, (index) {
                      final isActive = index == _currentSlide;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

                // Footer actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    0,
                    AppSpacing.marginMobile,
                    AppSpacing.marginMobile,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleNext,
                            icon: Text(isLastSlide ? 'Get Started' : 'Next Step'),
                            label: const Icon(Icons.arrow_forward, size: 18),
                            iconAlignment: IconAlignment.end,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.stackMd),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _stopAutoPlay();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignupScreen()),
                              );
                            },
                            child: const Text('Create Account'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.stackSm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                _stopAutoPlay();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
