import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golden_price/core/models/idx_top7_model/idx_top7_model.dart';

part 'saham_top7_state.freezed.dart';

@freezed
class SahamTop7State with _$SahamTop7State {
  const factory SahamTop7State.initial() = _Initial;
  const factory SahamTop7State.error(String message) = _Error;
  const factory SahamTop7State.success(
    List<IdxTop7Model>? sahamTop7,
  ) = _Success;
}
