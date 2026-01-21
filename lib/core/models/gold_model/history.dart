class History {
  int? midPrice;
  int? sell;
  int? buy;
  int? installment;
  DateTime? updatedAt;

  History({
    this.midPrice,
    this.sell,
    this.buy,
    this.installment,
    this.updatedAt,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        midPrice: json['midPrice'] as int?,
        sell: json['sell'] as int?,
        buy: json['buy'] as int?,
        installment: json['installment'] as int?,
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'midPrice': midPrice,
        'sell': sell,
        'buy': buy,
        'installment': installment,
        'updated_at': updatedAt?.toIso8601String(),
      };
}
