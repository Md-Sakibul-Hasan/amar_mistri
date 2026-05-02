import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Provider-specific state
  final Set<String> _selectedServices = {};
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _nidController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _serviceAreaController.dispose();
    _nidController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final isProvider = widget.role == 'provider';
    if (isProvider && _selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service.')),
      );
      return;
    }
    final role = isProvider ? UserRole.provider : UserRole.customer;
    final expText = _experienceController.text.trim();
    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        role: role,
        services: isProvider ? _selectedServices.toList() : null,
        experienceYears: isProvider && expText.isNotEmpty
            ? int.tryParse(expText)
            : null,
        skills: isProvider && _skillsController.text.trim().isNotEmpty
            ? _skillsController.text.trim()
            : null,
        serviceArea: isProvider && _serviceAreaController.text.trim().isNotEmpty
            ? _serviceAreaController.text.trim()
            : null,
        nidNumber: isProvider ? _nidController.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProvider = widget.role == 'provider';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            EasyLoading.show(status: 'Please wait...');
          } else {
            EasyLoading.dismiss();
          }
          if (state is AuthAuthenticated) {
            final destination = state.user.role == UserRole.provider
                ? AppRouter.providerHome
                : AppRouter.customerHome;
            context.go(destination);
          } else if (state is AuthFailureState) {
            EasyLoading.showError(state.message);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                isProvider: isProvider,
                pageContext: context,
                topPadding: MediaQuery.of(context).padding.top,
              ),
            ),
            SliverToBoxAdapter(child: _buildForm(context, isProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sign up to get started',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Full Name
            const AppFieldLabel('Full Name'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _nameController,
              hint: 'John Doe',
              prefixIcon: const Icon(
                Icons.person_outline,
                size: 18,
                color: Colors.grey,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),

            // Email
            const AppFieldLabel('Email Address'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _emailController,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline,
                size: 18,
                color: Colors.grey,
              ),
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Enter a valid email'
                  : null,
            ),
            const SizedBox(height: 16),

            // Phone
            const AppFieldLabel('Phone Number'),
            const SizedBox(height: 6),
            AppPhoneField(controller: _phoneController),
            const SizedBox(height: 16),

            // ── Provider-only fields ─────────────────────────────────────
            if (isProvider) ...[
              // Services
              const AppFieldLabel('Services Offered'),
              const SizedBox(height: 8),
              _ServiceChips(
                selected: _selectedServices,
                onToggle: (s) => setState(() {
                  if (_selectedServices.contains(s)) {
                    _selectedServices.remove(s);
                  } else {
                    _selectedServices.add(s);
                  }
                }),
              ),
              const SizedBox(height: 16),

              // Experience
              const AppFieldLabel('Experience (Years)'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _experienceController,
                hint: 'e.g. 3',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  Icons.work_history_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Enter years of experience';
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Service Area
              const AppFieldLabel('Service Area'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _serviceAreaController,
                hint: 'Enter your service area',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter your service area'
                    : null,
              ),
              const SizedBox(height: 16),

              // NID / ID Number
              const AppFieldLabel('NID / ID Number'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _nidController,
                hint: 'National ID or other ID',
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter your NID / ID number'
                    : null,
              ),
              const SizedBox(height: 16),

              // Skills (optional)
              const AppFieldLabel('Skills (Optional)'),
              const SizedBox(height: 6),
              AppTextField(
                controller: _skillsController,
                hint: 'e.g. Solar panel installation, inverter repair',
                maxLines: 3,
                prefixIcon: const Icon(
                  Icons.build_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Password
            const AppFieldLabel('Password'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _passwordController,
              hint: 'Min. 6 characters',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 16),

            // Confirm Password
            const AppFieldLabel('Confirm Password'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _confirmPasswordController,
              hint: 'Re-enter password',
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) => v != _passwordController.text
                  ? 'Passwords do not match'
                  : null,
            ),
            const SizedBox(height: 28),

            // CTA
            GestureDetector(
              onTap: _submit,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.headerGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.blue.withAlpha(77),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or sign up with',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 16),

            // Social buttons
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    emoji: '🌐',
                    label: 'Google',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialButton(
                    emoji: '📘',
                    label: 'Facebook',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () =>
                      context.go('${AppRouter.login}?role=${widget.role}'),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Collapsing header delegate ─────────────────────────────────────────────

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isProvider;
  final BuildContext pageContext;
  final double topPadding;

  const _HeaderDelegate({
    required this.isProvider,
    required this.pageContext,
    required this.topPadding,
  });

  @override
  double get minExtent => topPadding + kToolbarHeight;

  @override
  double get maxExtent => topPadding + 200.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final logoSize = lerpDouble(48.0, 32.0, t)!;
    final logoIconSize = lerpDouble(24.0, 16.0, t)!;
    final brandFontSize = lerpDouble(22.0, 16.0, t)!;
    final logoTop = lerpDouble(
      topPadding + 62.0,
      topPadding + (kToolbarHeight - 32.0) / 2,
      t,
    )!;

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative circles — fade out while collapsing
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: const Offset(40, -40),
                child: AppTheme.circle(180, 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: const Offset(-30, 30),
                child: AppTheme.circle(120, 0.10),
              ),
            ),
          ),
          // Back button — fixed at the top
          Positioned(
            top: topPadding + 4.0,
            left: 4.0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => pageContext.go(AppRouter.roleSelection),
            ),
          ),
          // Logo + name — slides up and shrinks as header collapses
          Positioned(
            top: logoTop,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTheme.logoBadge(size: logoSize, iconSize: logoIconSize),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTheme.brandName(fontSize: brandFontSize),
                      if (t < 0.6)
                        Opacity(
                          opacity: (1.0 - t / 0.6).clamp(0.0, 1.0),
                          child: Text(
                            isProvider
                                ? 'Provider Portal'
                                : 'Your local service partner',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
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
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) =>
      oldDelegate.isProvider != isProvider ||
      oldDelegate.topPadding != topPadding;
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Service chips selector ──────────────────────────────────────────────────

class _ServiceChips extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;

  const _ServiceChips({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.availableServices.map((service) {
        final isSelected = selected.contains(service);
        return GestureDetector(
          onTap: () => onToggle(service),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.blue : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppTheme.blue : Colors.grey.shade300,
              ),
            ),
            child: Text(
              service,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
