import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/provider_review_model.dart';

class ReviewDetailScreen extends StatelessWidget {
  final ProviderReviewModel review;

  const ReviewDetailScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: colors.scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.primaryText),
        title: Text(
          'Review details',
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroCard(review: review, colors: colors),
          const SizedBox(height: 16),
          _CommentCard(review: review, colors: colors),
          const SizedBox(height: 16),
          _MetaCard(review: review, colors: colors),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final ProviderReviewModel review;
  final AppColors colors;

  const _HeroCard({required this.review, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.lightBlueBg,
            backgroundImage: review.customerPhotoUrl != null
                ? NetworkImage(review.customerPhotoUrl!)
                : null,
            child: review.customerPhotoUrl == null
                ? Text(
                    review.customerUid.isNotEmpty
                        ? review.customerUid.substring(0, 1).toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            review.customerName ?? 'Customer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) {
              final filled = i < review.rating;
              return Icon(
                filled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 26,
                color: filled ? const Color(0xFFFBBF24) : colors.greyIcon,
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '${review.rating} / 5',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatFullDate(review.timestamp),
            style: TextStyle(fontSize: 12, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final ProviderReviewModel review;
  final AppColors colors;

  const _CommentCard({required this.review, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote_rounded, size: 18, color: colors.greyIcon),
              const SizedBox(width: 6),
              Text(
                'Comment',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment.isEmpty ? 'No comment left.' : review.comment,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: colors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final ProviderReviewModel review;
  final AppColors colors;

  const _MetaCard({required this.review, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        children: [
          _MetaRow(
            colors: colors,
            label: 'Review ID',
            value: review.reviewId,
            first: true,
          ),
          _MetaRow(
            colors: colors,
            label: 'Booking ID',
            value: review.bookingId,
          ),
          _MetaRow(
            colors: colors,
            label: 'Customer UID',
            value: review.customerUid,
          ),
          _MetaRow(
            colors: colors,
            label: 'Provider UID',
            value: review.providerUid,
          ),
          _MetaRow(
            colors: colors,
            label: 'Submitted',
            value: _formatFullDate(review.timestamp),
            last: true,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final AppColors colors;
  final String label;
  final String value;
  final bool first;
  final bool last;

  const _MetaRow({
    required this.colors,
    required this.label,
    required this.value,
    this.first = false,
    this.last = false,
  });

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied "$label"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _copy(context),
      borderRadius: BorderRadius.vertical(
        top: first ? const Radius.circular(16) : Radius.zero,
        bottom: last ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: colors.divider)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.copy_rounded, size: 15, color: colors.greyIcon),
          ],
        ),
      ),
    );
  }
}

String _formatFullDate(DateTime date) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final period = date.hour >= 12 ? 'PM' : 'AM';
  final minute = date.minute.toString().padLeft(2, '0');
  return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour12:$minute $period';
}