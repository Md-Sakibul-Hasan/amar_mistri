part of 'review_bloc.dart';

enum ReviewStatus { initial, loading, success, failure }

class ReviewState extends Equatable {
  final int rating;
  final String comment;
  final ReviewStatus status;
  final String? errorMessage;

  const ReviewState({this.rating = 0, this.comment = '', this.status = ReviewStatus.initial, this.errorMessage});

  bool get canSubmit => rating > 0 && status != ReviewStatus.loading;

  ReviewState copyWith({int? rating, String? comment, ReviewStatus? status, String? errorMessage}) {
    return ReviewState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [rating, comment, status, errorMessage];
}
