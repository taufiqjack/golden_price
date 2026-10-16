import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/models/ihsg_model/ihsg_model.dart';
import 'package:golden_price/core/repositories/idx_repo/ihsg_repo.dart';

import 'ihsg_state.dart';

class IhsgCubit extends Cubit<IhsgState> {
  final _repo = IhsgRepo();

  IhsgCubit() : super(const IhsgState());

  Future<void> getIhsg([IhsgRange? range]) async {
    final selected = range ?? state.range;
    // Keep the previous chart visible while the new range loads.
    emit(IhsgState(range: selected, data: state.data));
    try {
      final data = await _repo.getIhsg(selected);
      // Ignore a stale response if the user already picked another range.
      if (selected != state.range) return;
      emit(IhsgState(range: selected, loading: false, data: data));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (selected != state.range) return;
      emit(IhsgState(range: selected, loading: false, error: e.toString()));
    }
  }
}
