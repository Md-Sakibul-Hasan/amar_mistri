import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/domain/usecases/get_provider_details_usecase.dart';

part 'provider_details_event.dart';
part 'provider_details_state.dart';

class ProviderDetailsBloc
    extends Bloc<ProviderDetailsEvent, ProviderDetailsState> {
  final GetProviderDetailsUseCase getProviderDetails;

  ProviderDetailsBloc({required this.getProviderDetails})
    : super(const ProviderDetailsInitial()) {
    on<ProviderDetailsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ProviderDetailsLoadRequested event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    emit(const ProviderDetailsLoading());
    final result = await getProviderDetails(UidParams(uid: event.uid));
    result.fold(
      (failure) => emit(ProviderDetailsError(failure.message)),
      (provider) => emit(ProviderDetailsLoaded(provider)),
    );
  }
}
