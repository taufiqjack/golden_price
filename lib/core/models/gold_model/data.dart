import 'current.dart';
import 'history.dart';

class Data {
  Current? current;
  List<History>? history;

  Data({this.current, this.history});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        current: json['current'] == null
            ? null
            : Current.fromJson(json['current'] as Map<String, dynamic>),
        history: (json['history'] as List<dynamic>?)
            ?.map((e) => History.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'current': current?.toJson(),
        'history': history?.map((e) => e.toJson()).toList(),
      };
}
