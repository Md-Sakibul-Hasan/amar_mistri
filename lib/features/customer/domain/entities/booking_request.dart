import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/app_user.dart';

class BookingRequest extends Equatable {
  final AppUser provider;
  final String area;
  final String note;
  final String priority;

  const BookingRequest({
    required this.provider,
    required this.area,
    required this.note,
    required this.priority,
  });

  @override
  List<Object?> get props => [provider, area, note, priority];
}
