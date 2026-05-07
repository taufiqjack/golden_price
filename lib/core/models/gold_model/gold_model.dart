import 'datum.dart';

class GoldModel {
  bool? success;
  List<Datum>? data;
  int? count;
  DateTime? timestamp;
  bool? cached;

  GoldModel({this.success, this.data, this.count, this.timestamp, this.cached});

  factory GoldModel.fromJson(Map<String, dynamic> json) => GoldModel(
        success: json['success'] as bool?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
        count: json['count'] as int?,
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String),
        cached: json['cached'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(), // ignore: unnecessary_null_comparison
        'count': count,
        'timestamp': timestamp?.toIso8601String(),
        'cached': cached,
      };

  Datum? getAntam1gr() {
    if (data == null || data!.isEmpty) return null;
    final match = data!.where(
      (e) => e.weight == 1 && (e.materialType?.toLowerCase().contains('antam') ?? false),
    );
    return match.isNotEmpty ? match.first : data!.first;
  }
}
