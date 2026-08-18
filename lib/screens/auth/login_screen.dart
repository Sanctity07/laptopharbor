import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../root_shell.dart';
import 'signup_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_button.dart';
import 'widgets/auth_branding_panel.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    // TODO: replace with AuthProvider().login(...) once backend is wired.
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
                    final card = _AuthCard(
                      formKey: _formKey,
                      title: 'Welcome back',
                      subtitle: 'Enter your credentials to access your workspace.',
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                      isLoading: _isLoading,
                      onSubmit: _handleSubmit,
                      submitLabel: 'Sign In',
                      submitIcon: Icons.arrow_forward,
                      forgotPasswordLink: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset coming soon')),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                      checkboxValue: _rememberMe,
                      onCheckboxChanged: (v) => setState(() => _rememberMe = v ?? false),
                      checkboxLabel: 'Keep me signed in on this device',
                      footerText: "Don't have an account yet? ",
                      footerActionLabel: 'Create Account',
                      onFooterAction: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
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

/// Shared card body used by both Login and Signup — kept private here
/// since only these two screens need it.
class _AuthCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitLabel;
  final IconData submitIcon;
  final Widget? forgotPasswordLink;
  final bool checkboxValue;
  final ValueChanged<bool?> onCheckboxChanged;
  final String checkboxLabel;
  final String footerText;
  final String footerActionLabel;
  final VoidCallback onFooterAction;

  const _AuthCard({
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.isLoading,
    required this.onSubmit,
    required this.submitLabel,
    required this.submitIcon,
    this.forgotPasswordLink,
    required this.checkboxValue,
    required this.onCheckboxChanged,
    required this.checkboxLabel,
    required this.footerText,
    required this.footerActionLabel,
    required this.onFooterAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        key: formKey,
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
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.stackLg),

            AuthTextField(
              label: 'Email Address',
              hint: 'name@company.com',
              icon: Icons.mail_outline,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.stackMd),
            AuthTextField(
              label: 'Password',
              hint: '••••••••',
              icon: Icons.lock_outline,
              controller: passwordController,
              obscureText: obscurePassword,
              validator: Validators.password,
              labelTrailing: forgotPasswordLink,
              trailing: IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.outline),
                onPressed: onToggleObscure,
              ),
            ),
            const SizedBox(height: AppSpacing.stackSm),
            Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: checkboxValue,
                    onChanged: onCheckboxChanged,
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(checkboxLabel, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(submitLabel),
                label: isLoading ? const SizedBox.shrink() : Icon(submitIcon, size: 18),
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
                    TextSpan(text: footerText),
                    TextSpan(
                      text: footerActionLabel,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = onFooterAction,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}