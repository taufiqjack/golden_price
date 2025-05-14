part of 'saham_top7_cubit.dart';

@freezed
class SahamTop7State with _$SahamTop7State {
  const factory SahamTop7State.initial() = _Initial;
  const factory SahamTop7State.error(String message) = _Error;
  const factory SahamTop7State.success(List<IdxTop7Model>? sahamTop7) =
      _Success;
}
