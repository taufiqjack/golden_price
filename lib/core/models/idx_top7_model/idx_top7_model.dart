class IdxTop7Model {
  String? code;
  double? price;
  dynamic change;
  double? percent;
  dynamic volume;
  dynamic value;
  dynamic frequency;

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
        price: json['Price'] as double,
        change: json['Change'] as dynamic,
        percent: json['Percent'] as double,
        volume: json['Volume'] as dynamic,
        value: json['Value'] as dynamic,
        frequency: json['Frequency'] as dynamic,
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
