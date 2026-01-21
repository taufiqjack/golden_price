import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/repositories/idx_repo/idx_saham_repo.dart';

import 'saham_top7_state.dart';

class SahamTop7Cubit extends Cubit<SahamTop7State> {
  final _repo = IdxSahamRepo();

  SahamTop7Cubit() : super(const SahamTop7State.initial());

  Future<void> getSahamTop7(BuildContext context) async {
    try {
      emit(const SahamTop7State.initial());
      final saham = await _repo.getSahamTop7(context);
      emit(SahamTop7State.success(saham));
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(SahamTop7State.error(e.toString()));
    }
  }
}
