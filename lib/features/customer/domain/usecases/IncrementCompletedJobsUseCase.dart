import '../repositories/booking_repository.dart';

class IncrementCompletedJobsUseCase {
  final BookingRepository repository;

  IncrementCompletedJobsUseCase(this.repository);

  Future<void> call(String providerUid) {
    return repository.updateProviderCompletedJobs(providerUid);
  }
}
