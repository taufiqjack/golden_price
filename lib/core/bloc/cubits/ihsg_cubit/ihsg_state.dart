import 'package:golden_price/core/models/ihsg_model/ihsg_model.dart';

class IhsgState {
  final IhsgRange range;
  final bool loading;
  final IhsgModel? data;
  final String? error;

  const IhsgState({
    this.range = IhsgRange.week,
    this.loading = true,
    this.data,
    this.error,
  });
}
