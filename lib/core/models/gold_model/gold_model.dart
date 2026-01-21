import 'data.dart';

class GoldModel {
  int? statusCode;
  String? status;
  Data? data;

  GoldModel({this.statusCode, this.status, this.data});

  factory GoldModel.fromJson(Map<String, dynamic> json) => GoldModel(
        statusCode: json['statusCode'] as int?,
        status: json['status'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'status': status,
        'data': data?.toJson(),
      };
}
