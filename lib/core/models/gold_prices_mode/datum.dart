class Datum {
  int? sell;
  int? buy;
  String? type;
  dynamic info;
  dynamic weight;
  String? unit;

  Datum({
    this.sell,
    this.buy,
    this.type,
    this.info,
    this.weight,
    this.unit,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sell: json['sell'] as int?,
        buy: json['buy'] as int?,
        type: json['type'] as String?,
        info: json['info'] as dynamic,
        weight: json['weight'] as dynamic,
        unit: json['unit'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sell': sell,
        'buy': buy,
        'type': type,
        'info': info,
        'weight': weight,
        'unit': unit,
      };
}
