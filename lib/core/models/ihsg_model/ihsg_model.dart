/// Selectable chart ranges, mapped to Yahoo Finance `range`/`interval`.
enum IhsgRange {
  day('1D', '1d', '5m'),
  week('1W', '5d', '30m'),
  month('1M', '1mo', '1d'),
  threeMonths('3M', '3mo', '1d'),
  year('1Y', '1y', '1d'),
  fiveYears('5Y', '5y', '1wk');

  const IhsgRange(this.label, this.range, this.interval);

  final String label;
  final String range;
  final String interval;
}

class IhsgPoint {
  final DateTime time;
  final double close;

  const IhsgPoint(this.time, this.close);
}

class IhsgModel {
  final double price;
  final double previousClose;
  final List<IhsgPoint> points;

  const IhsgModel({
    required this.price,
    required this.previousClose,
    required this.points,
  });

  /// Change against the first point of the selected range.
  double get change => price - _base;

  double get percent => _base == 0 ? 0 : change / _base * 100;

  double get _base => points.isNotEmpty ? points.first.close : previousClose;

  /// Parses `chart.result[0]` of the Yahoo Finance v8 chart response.
  factory IhsgModel.fromYahoo(Map<String, dynamic> json) {
    final result = (json['chart']['result'] as List).first;
    final meta = result['meta'] as Map<String, dynamic>;
    final timestamps = (result['timestamp'] as List?) ?? [];
    final closes =
        ((result['indicators']['quote'] as List).first['close'] as List?) ??
            [];

    final points = <IhsgPoint>[];
    for (var i = 0; i < timestamps.length && i < closes.length; i++) {
      final close = closes[i];
      // Yahoo leaves gaps (null) for intervals without trades.
      if (close == null) continue;
      points.add(IhsgPoint(
        DateTime.fromMillisecondsSinceEpoch((timestamps[i] as int) * 1000),
        (close as num).toDouble(),
      ));
    }

    return IhsgModel(
      price: (meta['regularMarketPrice'] as num?)?.toDouble() ??
          (points.isNotEmpty ? points.last.close : 0),
      previousClose: (meta['chartPreviousClose'] as num?)?.toDouble() ?? 0,
      points: points,
    );
  }
}
