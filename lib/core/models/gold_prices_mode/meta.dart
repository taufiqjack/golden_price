class Meta {
  String? url;
  String? engine;

  Meta({this.url, this.engine});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        url: json['url'] as String?,
        engine: json['engine'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'engine': engine,
      };
}
