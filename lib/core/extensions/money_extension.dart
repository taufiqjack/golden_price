import 'package:easy_localization/easy_localization.dart';

extension StringExtension on double {
  String toRupiah() {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 00,
    ).format(this);
  }

  String toDollar() {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$ ',
      decimalDigits: 0,
    ).format(this);
  }
}
