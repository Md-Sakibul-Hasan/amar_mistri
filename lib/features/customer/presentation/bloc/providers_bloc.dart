import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/domain/usecases/get_providers_by_service_usecase.dart';

part 'providers_event.dart';
part 'providers_state.dart';

class ProvidersBloc extends Bloc<ProvidersEvent, ProvidersState> {
  final GetProvidersByServiceUseCase getProvidersByService;

  ProvidersBloc({required this.getProvidersByService})
    : super(const ProvidersInitial()) {
    on<ProvidersLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ProvidersLoadRequested event,
    Emitter<ProvidersState> emit,
  ) async {
    emit(const ProvidersLoading());
    final result = await getProvidersByService(
      ServiceParams(service: event.service),
    );
    result.fold(
      (failure) => emit(ProvidersError(failure.message)),
      (providers) => emit(ProvidersLoaded(providers)),
    );
  }
}
