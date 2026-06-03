import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/review_bloc.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String bookingId;
  final String providerId;
  final String customerId;

  final VoidCallback? onSuccess;

  const ReviewBottomSheet({super.key, required this.bookingId, required this.providerId, this.onSuccess, required this.customerId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  int _hoveredStar = 0;

  // Shake animation for empty-rating submit attempt
  late final AnimationController _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final Animation<double> _shakeAnim = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

  void _triggerShake() {
    HapticFeedback.vibrate();
    _shakeCtrl.forward(from: 0);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── Theme constants ────────────────────────────────────────────────────────
  static const _bg = Color(0xFF0F0F14);
  static const _surface = Color(0xFF1A1A24);
  static const _accent = Color(0xFFFFBE3C);
  static const _accentSoft = Color(0x26FFBE3C);
  static const _textPrimary = Color(0xFFF0EFE9);
  static const _textMuted = Color(0xFF7A7A8A);
  static const _border = Color(0xFF2A2A38);
  static const _ratingLabels = ['', 'Poor', 'Fair', 'Good', 'Great', 'Excellent'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.status == ReviewStatus.success) {
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (context.mounted) {
              Navigator.pop(context);
              widget.onSuccess?.call();
            }
          });
        }
        if (state.status == ReviewStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        snap: true,
        snapSizes: const [0.62, 0.92],
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) => SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    child: state.status == ReviewStatus.success ? _buildSuccess() : _buildForm(context, state),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Success view ───────────────────────────────────────────────────────────
  Widget _buildSuccess() {
    return SizedBox(
      height: 340,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(color: _accentSoft, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: _accent, size: 38),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Review Submitted!',
            style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.4),
          ),
          const SizedBox(height: 8),
          const Text('Thank you for your honest feedback.', style: TextStyle(color: _textMuted, fontSize: 14)),
        ],
      ),
    );
  }

  // ── Form view ──────────────────────────────────────────────────────────────
  Widget _buildForm(BuildContext context, ReviewState state) {
    final bloc = context.read<ReviewBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: _accentSoft, borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.rate_review_rounded, color: _accent, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate Your Experience',
                  style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3),
                ),
                SizedBox(height: 2),
                Text('Your feedback shapes the service', style: TextStyle(color: _textMuted, fontSize: 12)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),
        _sectionLabel('Overall Rating'),
        const SizedBox(height: 14),

        // ── Stars ────────────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _shakeAnim,
          builder: (_, child) => Transform.translate(offset: Offset(_shakeAnim.value, 0), child: child),
          child: StatefulBuilder(
            builder: (context, setStar) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    final active = star <= (_hoveredStar > 0 ? _hoveredStar : state.rating);
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        bloc.add(ReviewRatingChanged(star));
                      },
                      child: MouseRegion(
                        onEnter: (_) => setStar(() => _hoveredStar = star),
                        onExit: (_) => setStar(() => _hoveredStar = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.only(right: 10),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: active ? _accentSoft : _surface,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: active ? _accent : _border, width: 1.5),
                          ),
                          child: AnimatedScale(
                            scale: active ? 1.12 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Icon(active ? Icons.star_rounded : Icons.star_outline_rounded, color: active ? _accent : _textMuted, size: 24),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // Rating label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.rating > 0
                      ? Padding(
                          key: ValueKey(state.rating),
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: _accentSoft, borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  _ratingLabels[state.rating],
                                  style: const TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(key: ValueKey(0), height: 10),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),
        _sectionLabel('Comment  (optional)'),
        const SizedBox(height: 10),

        // ── Comment field ─────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border, width: 1.5),
          ),
          child: TextField(
            controller: _commentController,
            onChanged: (v) => bloc.add(ReviewCommentChanged(v)),
            maxLines: 4,
            maxLength: 300,
            style: const TextStyle(color: _textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Share details about your experience…',
              hintStyle: TextStyle(color: _textMuted, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              counterStyle: TextStyle(color: _textMuted, fontSize: 11),
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ── Submit button ─────────────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 54,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: state.canSubmit ? _accent : _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: state.canSubmit ? Colors.transparent : _border, width: 1.5),
              boxShadow: state.canSubmit ? [BoxShadow(color: _accent.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 8))] : [],
            ),
            child: TextButton(
              onPressed: state.status == ReviewStatus.loading
                  ? null
                  : () {
                      if (state.rating == 0) {
                        _triggerShake();
                        return;
                      }
                      bloc.add(ReviewSubmitted(bookingId: widget.bookingId, providerId: widget.providerId, customerId: widget.customerId));
                    },
              style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: state.status == ReviewStatus.loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(_bg)),
                    )
                  : Text(
                      'Submit Review',
                      style: TextStyle(color: state.canSubmit ? _bg : _textMuted, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe later', style: TextStyle(color: _textMuted, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  );
}
