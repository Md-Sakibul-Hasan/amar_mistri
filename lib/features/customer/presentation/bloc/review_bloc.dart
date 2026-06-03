import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/review_model.dart';
import '../../domain/usecases/submit_review_usecase.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReviewUseCase submitReviewUseCase;

  ReviewBloc({required this.submitReviewUseCase}) : super(const ReviewState()) {
    on<ReviewRatingChanged>(_onRatingChanged);
    on<ReviewCommentChanged>(_onCommentChanged);
    on<ReviewSubmitted>(_onSubmitted);
    on<ReviewReset>(_onReset);
  }

  void _onRatingChanged(ReviewRatingChanged event, Emitter<ReviewState> emit) {
    emit(state.copyWith(rating: event.rating));
  }

  void _onCommentChanged(ReviewCommentChanged event, Emitter<ReviewState> emit) {
    emit(state.copyWith(comment: event.comment));
  }

  Future<void> _onSubmitted(ReviewSubmitted event, Emitter<ReviewState> emit) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: ReviewStatus.loading));

    try {
      await submitReviewUseCase(
        SubmitReviewParams(
          request: ReviewModel(
            providerId: event.providerId,
            customerId: event.customerId,
            rating: state.rating,
            comment: state.comment,
            bookingId: event.bookingId,
            reviewId: '',
          ),
        ),
      );

      emit(state.copyWith(status: ReviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ReviewStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onReset(ReviewReset event, Emitter<ReviewState> emit) {
    emit(const ReviewState());
  }
}
