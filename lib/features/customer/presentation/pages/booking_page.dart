import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/domain/entities/app_user.dart';
import '../bloc/booking_bloc.dart';
import 'booking_confirm_page.dart';

class BookingPage extends StatelessWidget {
  final AppUser provider;

  const BookingPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: _BookingPageView(provider: provider),
    );
  }
}

class _BookingPageView extends StatefulWidget {
  final AppUser provider;

  const _BookingPageView({required this.provider});

  @override
  State<_BookingPageView> createState() => _BookingPageViewState();
}

class _BookingPageViewState extends State<_BookingPageView> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _areaController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state.status == BookingStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.status == BookingStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BookingConfirmPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.scaffoldBg,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 170,
                  pinned: true,
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 54, 16, 18),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.25,
                                ),
                                backgroundImage:
                                    (widget.provider.photoUrl != null && widget.provider.photoUrl!.isNotEmpty)
                                    ? NetworkImage(widget.provider.photoUrl!)
                                    : null,
                                child: (widget.provider.photoUrl == null || widget.provider.photoUrl!.isEmpty)
                                    ? Text(
                                        _initials(widget.provider.name),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      context.l10n.bookService,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.provider.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _infoCard(
                        c: context.colors,
                        children: [
                          _serviceTag(widget.provider),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.bookingJobDetailsHint,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.colors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _formCard(context),
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                decoration: BoxDecoration(
                  color: context.colors.cardBg,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.shadowHeavy,
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state.status == BookingStatus.submitting;
                    return ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              context.l10n.confirmBooking,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard(BuildContext context) {
    final c = context.colors;
    return _infoCard(
      c: c,
      children: [
        Text(
          context.l10n.bookingForm,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: c.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _areaController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  c: c,
                  label: context.l10n.area,
                  hint: context.l10n.areaHint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.areaRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                decoration: _inputDecoration(
                  c: c,
                  label: context.l10n.noteDescription,
                  hint: context.l10n.describeTheProblem,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.descriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Text(
                context.l10n.priority,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c.tertiaryText,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      _priorityChip(
                        context,
                        state.priority,
                        'normal',
                        context.l10n.normal,
                      ),
                      _priorityChip(
                        context,
                        state.priority,
                        'urgent',
                        context.l10n.urgent,
                      ),
                      _priorityChip(
                        context,
                        state.priority,
                        'emergency',
                        context.l10n.emergency,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceTag(AppUser provider) {
    final service = provider.services != null && provider.services!.isNotEmpty
        ? provider.services!.first
        : 'AC Repair';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1A73E8).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.build_circle_outlined,
            size: 16,
            color: Color(0xFF1A73E8),
          ),
          const SizedBox(width: 6),
          Text(
            service,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A73E8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityChip(
    BuildContext context,
    String selectedPriority,
    String value,
    String label,
  ) {
    final selected = selectedPriority == value;
    final c = context.colors;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        context.read<BookingBloc>().add(
          BookingPriorityChanged(priority: value),
        );
      },
      selectedColor: const Color(0xFF1A73E8).withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF1A73E8) : c.tertiaryText,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(
        color: selected ? const Color(0xFF1A73E8) : c.inputBorder,
      ),
      backgroundColor: c.cardBg,
    );
  }

  Widget _infoCard({required AppColors c, required List<Widget> children}) {
    return Container(
      width: double.infinity,
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
        children: children,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required AppColors c,
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: c.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
      ),
    );
  }

  String _initials(String name) {
    return name
        .split(' ')
        .where((segment) => segment.isNotEmpty)
        .take(2)
        .map((segment) => segment[0].toUpperCase())
        .join();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BookingBloc>().add(
      BookingSubmitted(
        provider: widget.provider,
        area: _areaController.text.trim(),
        note: _noteController.text.trim(),
      ),
    );
  }
}
