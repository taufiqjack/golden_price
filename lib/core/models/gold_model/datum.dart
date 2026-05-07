class Datum {
  String? source;
  String? material;
  String? materialType;
  int? weight;
  String? weightUnit;
  int? sellPrice;
  int? buybackPrice;
  String? currency;
  DateTime? recordedDate;
  String? lineKey;

  Datum({
    this.source,
    this.material,
    this.materialType,
    this.weight,
    this.weightUnit,
    this.sellPrice,
    this.buybackPrice,
    this.currency,
    this.recordedDate,
    this.lineKey,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        source: json['source'] as String?,
        material: json['material'] as String?,
        materialType: json['materialType'] as String?,
        weight: json['weight'] as int?,
        weightUnit: json['weightUnit'] as String?,
        sellPrice: json['sellPrice'] as int?,
        buybackPrice: json['buybackPrice'] as int?,
        currency: json['currency'] as String?,
        recordedDate: json['recordedDate'] == null
            ? null
            : DateTime.parse(json['recordedDate'] as String),
        lineKey: json['lineKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'source': source,
        'material': material,
        'materialType': materialType,
        'weight': weight,
        'weightUnit': weightUnit,
        'sellPrice': sellPrice,
        'buybackPrice': buybackPrice,
        'currency': currency,
        'recordedDate': recordedDate?.toIso8601String(),
        'lineKey': lineKey,
      };
}
