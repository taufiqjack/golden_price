class IdxTop7Model {
  String? code;
  int? price;
  int? change;
  double? percent;
  int? volume;
  int? value;
  int? frequency;

  IdxTop7Model({
    this.code,
    this.price,
    this.change,
    this.percent,
    this.volume,
    this.value,
    this.frequency,
  });

  factory IdxTop7Model.fromJson(Map<String, dynamic> json) => IdxTop7Model(
        code: json['Code'] as String?,
        price: json['Price'] as int?,
        change: json['Change'] as int?,
        percent: (json['Percent'] as num?)?.toDouble(),
        volume: json['Volume'] as int?,
        value: json['Value'] as int?,
        frequency: json['Frequency'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Price': price,
        'Change': change,
        'Percent': percent,
        'Volume': volume,
        'Value': value,
        'Frequency': frequency,
      };
}
