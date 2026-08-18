import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../root_shell.dart';
import 'login_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_button.dart';
import 'widgets/auth_branding_panel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: replace with AuthProvider().signUp(...) once backend is wired.
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: _blob(AppColors.secondaryContainer.withValues(alpha: 0.3), 320),
          ),
          Positioned(
            bottom: -60,
            right: -80,
            child: _blob(AppColors.primaryContainer.withValues(alpha: 0.2), 280),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                  vertical: AppSpacing.stackLg,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;
                    final card = Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.laptop_mac_rounded, color: AppColors.primary, size: 26),
                                const SizedBox(width: 8),
                                Text(
                                  'LaptopHarbor',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.stackMd),
                            Text('Join the Harbor', style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 4),
                            Text('Set up your professional tech profile today.', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppSpacing.stackLg),

                            AuthTextField(
                              label: 'Full Name',
                              hint: 'Jane Doe',
                              icon: Icons.person_outline,
                              controller: _nameController,
                              validator: (v) => Validators.required(v, field: 'Name'),
                            ),
                            const SizedBox(height: AppSpacing.stackMd),
                            AuthTextField(
                              label: 'Email Address',
                              hint: 'name@company.com',
                              icon: Icons.mail_outline,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: AppSpacing.stackMd),
                            AuthTextField(
                              label: 'Password',
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: Validators.password,
                              trailing: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.outline),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.stackSm),
                            Row(
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Checkbox(
                                    value: _agreedToTerms,
                                    onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                                    activeColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'I agree to the Terms and Conditions',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.stackMd),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _handleSubmit,
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 16, height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Create Account'),
                                label: _isLoading ? const SizedBox.shrink() : const Icon(Icons.person_add_alt, size: 18),
                                iconAlignment: IconAlignment.end,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.stackLg),
                            Row(
                              children: [
                                const Expanded(child: Divider(color: AppColors.outlineVariant)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('OR CONTINUE WITH', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2)),
                                ),
                                const Expanded(child: Divider(color: AppColors.outlineVariant)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.stackMd),
                            Row(
                              children: [
                                Expanded(
                                  child: SocialButton(
                                    label: 'Google',
                                    icon: Container(
                                      width: 20, height: 20,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF1F3F4)),
                                      child: const Text('G', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4285F4))),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SocialButton(
                                    label: 'Apple',
                                    icon: const Icon(Icons.apple, size: 20, color: AppColors.onSurface),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.stackLg),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: [
                                    const TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (!isWide) return card;

                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(flex: 6, child: AuthBrandingPanel()),
                          Expanded(flex: 6, child: Center(child: card)),
                        ],
                      ),
                    );
                  },
                ),
              ),
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