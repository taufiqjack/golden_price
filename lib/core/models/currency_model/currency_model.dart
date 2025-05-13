import 'usd.dart';

class CurrencyModel {
  String? date;
  Usd? usd;

  CurrencyModel({this.date, this.usd});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        date: json['date'] as String?,
        usd: json['usd'] == null
            ? null
            : Usd.fromJson(json['usd'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'usd': usd?.toJson(),
      };
}
