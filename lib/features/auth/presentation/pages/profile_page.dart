import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: _ProfileView(user: authState.user),
    );
  }
}

class _ProfileView extends StatefulWidget {
  final AppUser user;
  const _ProfileView({required this.user});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _skillsCtrl;
  late final TextEditingController _serviceAreaCtrl;
  late final TextEditingController _nidCtrl;
  late final TextEditingController _expCtrl;
  late List<String> _selectedServices;

  @override
  void initState() {
    super.initState();
    _initControllers(widget.user);
  }

  @override
  void didUpdateWidget(_ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user && !_isEditing) {
      _resetControllers(widget.user);
    }
  }

  void _initControllers(AppUser u) {
    _nameCtrl = TextEditingController(text: u.name);
    _phoneCtrl = TextEditingController(text: u.phone);
    _skillsCtrl = TextEditingController(text: u.skills ?? '');
    _serviceAreaCtrl = TextEditingController(text: u.serviceArea ?? '');
    _nidCtrl = TextEditingController(text: u.nidNumber ?? '');
    _expCtrl = TextEditingController(text: u.experienceYears?.toString() ?? '');
    _selectedServices = List<String>.from(u.services ?? []);
  }

  void _resetControllers(AppUser u) {
    _nameCtrl.text = u.name;
    _phoneCtrl.text = u.phone;
    _skillsCtrl.text = u.skills ?? '';
    _serviceAreaCtrl.text = u.serviceArea ?? '';
    _nidCtrl.text = u.nidNumber ?? '';
    _expCtrl.text = u.experienceYears?.toString() ?? '';
    _selectedServices = List<String>.from(u.services ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _skillsCtrl.dispose();
    _serviceAreaCtrl.dispose();
    _nidCtrl.dispose();
    _expCtrl.dispose();
    super.dispose();
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _resetControllers(widget.user);
    });
  }

  Future<void> _pickAndUpload(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (file != null && mounted) {
      context.read<ProfileBloc>().add(
        ProfilePhotoUploadRequested(uid: widget.user.uid, file: file),
      );
    }
  }

  void _showImagePickerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F0FE),
                child: Icon(Icons.camera_alt, color: Color(0xFF1A73E8)),
              ),
              title: const Text(
                'Take a photo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () => _pickAndUpload(context, ImageSource.camera),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F0FE),
                child: Icon(Icons.photo_library, color: Color(0xFF1A73E8)),
              ),
              title: const Text(
                'Choose from gallery',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () => _pickAndUpload(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final expText = _expCtrl.text.trim();
    context.read<ProfileBloc>().add(
      ProfileSaveRequested(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        services: widget.user.role == UserRole.provider
            ? _selectedServices
            : null,
        experienceYears:
            widget.user.role == UserRole.provider && expText.isNotEmpty
            ? int.tryParse(expText)
            : null,
        skills:
            widget.user.role == UserRole.provider &&
                _skillsCtrl.text.trim().isNotEmpty
            ? _skillsCtrl.text.trim()
            : null,
        serviceArea:
            widget.user.role == UserRole.provider &&
                _serviceAreaCtrl.text.trim().isNotEmpty
            ? _serviceAreaCtrl.text.trim()
            : null,
        nidNumber:
            widget.user.role == UserRole.provider &&
                _nidCtrl.text.trim().isNotEmpty
            ? _nidCtrl.text.trim()
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProvider = widget.user.role == UserRole.provider;
    final initials = widget.user.name
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          // Update auth state directly — avoids AuthLoading which would
          // trigger the router redirect to roleSelection.
          context.read<AuthBloc>().add(AuthUserUpdated(state.user));
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.user.photoUrl != null &&
                        state.user.photoUrl != widget.user.photoUrl
                    ? 'Profile photo updated'
                    : 'Profile updated successfully',
              ),
              backgroundColor: const Color(0xFF22C55E),
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.scaffoldBg,
        body: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 210,
              pinned: true,
              backgroundColor: const Color(0xFF1A73E8),
              foregroundColor: Colors.white,
              actions: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileSaving ||
                        state is ProfilePhotoUploading) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    }
                    if (_isEditing) {
                      return Row(
                        children: [
                          TextButton(
                            onPressed: _cancelEdit,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _save(context),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit profile',
                      onPressed: () => setState(() => _isEditing = true),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Blurred photo background (or gradient fallback) ──
                    if (widget.user.photoUrl != null)
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Image.network(
                          widget.user.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                          ),
                        ),
                      ),
                    // ── Dark shade overlay ───────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.black.withValues(alpha: 0.60),
                          ],
                        ),
                      ),
                    ),
                    // ── Avatar + name ────────────────────────────────────
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              final isUploading =
                                  state is ProfilePhotoUploading;
                              return GestureDetector(
                                onTap: isUploading
                                    ? null
                                    : () => _showImagePickerSheet(context),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 46,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      backgroundImage:
                                          widget.user.photoUrl != null
                                          ? NetworkImage(widget.user.photoUrl!)
                                          : null,
                                      child: widget.user.photoUrl == null
                                          ? Text(
                                              initials,
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                    if (isUploading)
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    if (!isUploading)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: const Color(
                                            0xFF1A73E8,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Basic Info ─────────────────────────────
                        _SectionCard(
                          title: 'Basic Information',
                          icon: Icons.person_outline,
                          children: [
                            _ProfileField(
                              label: 'Full Name',
                              controller: _nameCtrl,
                              enabled: _isEditing,
                              icon: Icons.badge_outlined,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _ProfileField(
                              label: 'Email',
                              controller: TextEditingController(
                                text: widget.user.email,
                              ),
                              enabled: false,
                              icon: Icons.email_outlined,
                              hint: 'Cannot be changed',
                            ),
                            const SizedBox(height: 16),
                            _ProfileField(
                              label: 'Phone',
                              controller: _phoneCtrl,
                              enabled: _isEditing,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Phone is required'
                                  : null,
                            ),
                          ],
                        ),

                        // ── Provider-only fields ───────────────────
                        if (isProvider) ...[
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Professional Details',
                            icon: Icons.work_outline,
                            children: [
                              _ProfileField(
                                label: 'Experience (years)',
                                controller: _expCtrl,
                                enabled: _isEditing,
                                icon: Icons.workspace_premium_outlined,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              _ProfileField(
                                label: 'Skills',
                                controller: _skillsCtrl,
                                enabled: _isEditing,
                                icon: Icons.star_border_rounded,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              _ProfileField(
                                label: 'Service Area',
                                controller: _serviceAreaCtrl,
                                enabled: _isEditing,
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 16),
                              _ProfileField(
                                label: 'NID Number',
                                controller: _nidCtrl,
                                enabled: _isEditing,
                                icon: Icons.credit_card_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Services Offered',
                            icon: Icons.build_circle_outlined,
                            children: [
                              if (!_isEditing && _selectedServices.isEmpty)
                                const Text(
                                  'No services added',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 13,
                                  ),
                                )
                              else
                                _ServicesSelector(
                                  selected: _selectedServices,
                                  enabled: _isEditing,
                                  onChanged: (list) =>
                                      setState(() => _selectedServices = list),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: c.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: c.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: c.divider),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? hint;
  final String? Function(String?)? validator;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: c.secondaryText,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: c.primaryText,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: c.inputHint),
            filled: true,
            fillColor: enabled ? c.inputFill : c.inputFillDisabled,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF1A73E8),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.divider),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesSelector extends StatelessWidget {
  final List<String> selected;
  final bool enabled;
  final ValueChanged<List<String>> onChanged;

  const _ServicesSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.availableServices.map((service) {
        final isSelected = selected.contains(service);
        return FilterChip(
          label: Text(service),
          selected: isSelected,
          onSelected: enabled
              ? (value) {
                  final updated = List<String>.from(selected);
                  if (value) {
                    updated.add(service);
                  } else {
                    updated.remove(service);
                  }
                  onChanged(updated);
                }
              : null,
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF1A73E8) : c.secondaryText,
          ),
          backgroundColor: c.inputFill,
          selectedColor: c.lightBlueBg,
          checkmarkColor: const Color(0xFF1A73E8),
          side: BorderSide(
            color: isSelected ? const Color(0xFF1A73E8) : c.inputBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: true,
        );
      }).toList(),
    );
  }
}
