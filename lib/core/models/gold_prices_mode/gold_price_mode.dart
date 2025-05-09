import 'datum.dart';
import 'meta.dart';

class GoldPricesModel {
  List<Datum>? data;
  Meta? meta;

  GoldPricesModel({this.data, this.meta});

  factory GoldPricesModel.fromJson(Map<String, dynamic> json) =>
      GoldPricesModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
        meta: json['meta'] == null
            ? null
            : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
      };
}
