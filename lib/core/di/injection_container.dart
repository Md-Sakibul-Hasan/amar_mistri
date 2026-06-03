import 'package:amar_mistri/features/customer/data/datasources/reviewRemoteDataSource.dart';
import 'package:amar_mistri/features/customer/data/repositories/review_repository_impl.dart';
import 'package:amar_mistri/features/customer/domain/repositories/review_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/get_provider_details_usecase.dart';
import '../../features/auth/domain/usecases/get_providers_by_service_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_user_profile_usecase.dart';
import '../../features/auth/domain/usecases/upload_profile_photo_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/profile_bloc.dart';
import '../../features/customer/data/datasources/booking_remote_data_source.dart';
import '../../features/customer/data/repositories/booking_repository_impl.dart';
import '../../features/customer/domain/repositories/booking_repository.dart';
import '../../features/customer/domain/usecases/IncrementCompletedJobsUseCase.dart';
import '../../features/customer/domain/usecases/create_booking_usecase.dart';
import '../../features/customer/domain/usecases/get_customer_bookings_usecase.dart';
import '../../features/customer/domain/usecases/get_provider_bookings_usecase.dart';
import '../../features/customer/domain/usecases/submit_review_usecase.dart';
import '../../features/customer/domain/usecases/update_booking_status_usecase.dart';
import '../../features/customer/presentation/bloc/booking_bloc.dart';
import '../../features/customer/presentation/bloc/customer_bookings_bloc.dart';
import '../../features/customer/presentation/bloc/provider_details_bloc.dart';
import '../../features/customer/presentation/bloc/providers_bloc.dart';
import '../../features/provider/presentation/bloc/provider_bookings_bloc.dart';
import '../locale/locale_cubit.dart';
import '../services/cloudflare_r2_service.dart';
import '../services/push_notification_service.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(firebaseAuth: sl(), firestore: sl(), messaging: sl(), localNotifications: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl(), pushNotificationService: sl()));
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()));
  sl.registerLazySingleton<ReviewRemoteDataSource>(() => ReviewRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(remoteDataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetProvidersByServiceUseCase(sl()));
  sl.registerLazySingleton(() => GetProviderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetCustomerBookingsUseCase(sl()));
  sl.registerLazySingleton(() => GetProviderBookingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookingStatusUseCase(sl()));
  sl.registerLazySingleton<CloudflareR2Service>(() => CloudflareR2Service());
  sl.registerLazySingleton(() => UploadProfilePhotoUseCase(repository: sl(), r2Service: sl()));
  sl.registerLazySingleton(() => IncrementCompletedJobsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitReviewUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl(), logoutUseCase: sl(), getCurrentUserUseCase: sl()));
  sl.registerFactory(() => ProvidersBloc(getProvidersByService: sl()));
  sl.registerFactory(() => ProviderDetailsBloc(getProviderDetails: sl()));
  sl.registerFactory(() => BookingBloc(createBookingUseCase: sl()));
  sl.registerFactory(() => CustomerBookingsBloc(getCustomerBookingsUseCase: sl()));
  sl.registerFactory(
    () => ProviderBookingsBloc(getProviderBookingsUseCase: sl(), updateBookingStatusUseCase: sl(), incrementCompletedJobsUseCase: sl()),
  );
  sl.registerFactory(() => ProfileBloc(updateUserProfile: sl(), uploadProfilePhoto: sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));
}
