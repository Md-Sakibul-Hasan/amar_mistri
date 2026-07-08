import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/provider_review_model.dart';
import '../bloc/provider_reviews_bloc.dart';
import 'review_details_page.dart';

class ProviderReviewListPage extends StatelessWidget {
  final String providerUid;

  const ProviderReviewListPage({super.key, required this.providerUid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProviderReviewsBloc>()..add(ProviderReviewsRequested(providerUid)),
      child: Scaffold(
        backgroundColor: context.colors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBg,
          elevation: 0,
          title: Text(
            'Reviews',
            style: TextStyle(
              color: context.colors.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          iconTheme: IconThemeData(color: context.colors.primaryText),
        ),
        body: BlocBuilder<ProviderReviewsBloc, ProviderReviewsState>(
          builder: (context, state) {
            if (state is ProviderReviewsLoading) {
              return Center(
                child: CircularProgressIndicator(color: context.colors.primaryText),
              );
            }
            if (state is ProviderReviewsError) {
              return _ErrorState(colors: context.colors);
            }
            if (state is ProviderReviewsLoaded) {
              final reviews = state.reviews;
              if (reviews.isEmpty) {
                return _EmptyState(colors: context.colors);
              }

              final average = reviews.isEmpty
                  ? 0.0
                  : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                      reviews.length;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _SummaryHeader(
                      colors: context.colors,
                      average: average,
                      total: reviews.length,
                      reviews: reviews,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: reviews.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return _ReviewCard(
                          review: review,
                          colors: context.colors,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReviewDetailScreen(review: review),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final AppColors colors;
  final double average;
  final int total;
  final List<ProviderReviewModel> reviews;

  const _SummaryHeader({
    required this.colors,
    required this.average,
    required this.total,
    required this.reviews,
  });

  int _countFor(int star) => reviews.where((r) => r.rating == star).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(rating: average.round(), colors: colors, size: 16),
              const SizedBox(height: 4),
              Text(
                '$total review${total == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 12, color: colors.secondaryText),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = _countFor(star);
                final fraction = total == 0 ? 0.0 : count / total;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 6,
                            backgroundColor: colors.inputFillDisabled,
                            valueColor: AlwaysStoppedAnimation(
                              _ratingColor(star, colors),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProviderReviewModel review;
  final AppColors colors;
  final VoidCallback onTap;

  const _ReviewCard({
    required this.review,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
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
                        color: colors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.customerName ??
                              'Customer •${review.customerUid.substring(0, review.customerUid.length.clamp(0, 6))}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colors.primaryText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      _RatingBadge(rating: review.rating, colors: colors),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.tertiaryText,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(review.timestamp),
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.greyIcon),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final int rating;
  final AppColors colors;

  const _RatingBadge({required this.rating, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _ratingBg(rating, colors),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13, color: _ratingColor(rating, colors)),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _ratingColor(rating, colors),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int rating;
  final AppColors colors;
  final double size;

  const _StarRow({
    required this.rating,
    required this.colors,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: filled ? const Color(0xFFFBBF24) : colors.greyIcon,
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined, size: 56, color: colors.greyIcon),
            const SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Reviews from your customers will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final AppColors colors;
  const _ErrorState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Something went wrong loading reviews.',
        style: TextStyle(color: colors.secondaryText),
      ),
    );
  }
}

Color _ratingColor(int rating, AppColors colors) {
  if (rating >= 4) return const Color(0xFF16A34A);
  if (rating == 3) return const Color(0xFFCA8A04);
  return const Color(0xFFDC2626);
}

Color _ratingBg(int rating, AppColors colors) {
  if (rating >= 4) return colors.lightGreenBg;
  if (rating == 3) return colors.lightYellowBg;
  return colors.lightRedBg;
}

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final period = date.hour >= 12 ? 'PM' : 'AM';
  final minute = date.minute.toString().padLeft(2, '0');
  return '${months[date.month - 1]} ${date.day}, ${date.year} • $hour12:$minute $period';
}
