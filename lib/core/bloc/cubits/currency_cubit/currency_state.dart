part of 'currency_cubit.dart';

@freezed
class CurrencyState with _$CurrencyState {
  const factory CurrencyState.initial() = _Initial;
  const factory CurrencyState.error(String mesaage) = _Error;
  const factory CurrencyState.success(CurrencyModel? currency) = _Success;
}
