part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class ReviewRatingChanged extends ReviewEvent {
  final int rating;
  const ReviewRatingChanged(this.rating);

  @override
  List<Object?> get props => [rating];
}

class ReviewCommentChanged extends ReviewEvent {
  final String comment;
  const ReviewCommentChanged(this.comment);

  @override
  List<Object?> get props => [comment];
}

class ReviewSubmitted extends ReviewEvent {
  final String bookingId;
  final String providerId;
  final String customerId;

  const ReviewSubmitted({required this.bookingId, required this.providerId, required this.customerId});

  @override
  List<Object?> get props => [bookingId, providerId, customerId];
}

class ReviewReset extends ReviewEvent {
  const ReviewReset();
}
