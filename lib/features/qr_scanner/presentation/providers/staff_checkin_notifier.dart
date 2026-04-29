import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/check_in_result.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';

enum CheckinStatus { idle, loading, success, error }

class StaffCheckinState {
  final CheckinStatus status;
  final CheckInResult? result;
  final String? errorMessage;

  const StaffCheckinState({
    this.status = CheckinStatus.idle,
    this.result,
    this.errorMessage,
  });

  StaffCheckinState copyWith({
    CheckinStatus? status,
    CheckInResult? result,
    String? errorMessage,
  }) {
    return StaffCheckinState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class StaffCheckinNotifier extends StateNotifier<StaffCheckinState> {
  final IEventRepository _repository;

  StaffCheckinNotifier(this._repository) : super(const StaffCheckinState());

  Future<void> verify(String qrCode) async {
    state = state.copyWith(status: CheckinStatus.loading);
    try {
      final result = await _repository.verifyQrCode(qrCode);
      state = StaffCheckinState(status: CheckinStatus.success, result: result);
    } catch (e) {
      state = StaffCheckinState(
        status: CheckinStatus.error,
        errorMessage: e.toString().replaceAll('AppException: ', ''),
      );
    }
  }

  void reset() => state = const StaffCheckinState();
}
