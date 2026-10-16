import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_state.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_state.dart';
import 'package:golden_price/core/bloc/cubits/ihsg_cubit/ihsg_cubit.dart';
import 'package:golden_price/core/bloc/cubits/ihsg_cubit/ihsg_state.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_state.dart';
import 'package:golden_price/core/components/asset_path.dart';
import 'package:golden_price/core/components/dialogs.dart';
import 'package:golden_price/core/constants/color_customs.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/extensions/money_extension.dart';
import 'package:golden_price/core/models/gold_model/datum.dart';
import 'package:golden_price/core/models/idx_top7_model/idx_top7_model.dart';
import 'package:golden_price/core/models/ihsg_model/ihsg_model.dart';
import 'package:golden_price/pages/dashboard/controller/dashboard_controller.dart';
import 'package:golden_price/widgets/common_text.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  static const double _gutter = 20;

  Widget build(BuildContext context, DashboardController controller) {
    final c = CorePalette.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bg,
        bottomNavigationBar: controller.bannerAd != null
            ? SafeArea(
                child: SizedBox(
                  height: controller.bannerAd!.size.height.toDouble(),
                  width: controller.bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: controller.bannerAd!),
                ),
              )
            : null,
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) => exitApp(context),
          child: RefreshIndicator(
            color: c.primary,
            onRefresh: () async => controller.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(c, context),
                  const SizedBox(height: 24),
                  _buildIhsgChart(c),
                  const SizedBox(height: 24),
                  _buildSectionTitle(c, 'Saham Teratas', trailing: 'IDX'),
                  const SizedBox(height: 12),
                  _buildTopStocks(c),
                  const SizedBox(height: 24),
                  _buildGoldList(c),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header: blue background with greeting and an overlapping summary card
  // ---------------------------------------------------------------------------

  Widget _buildHeader(CorePalette c, BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        Container(
          height: topInset + 170,
          decoration: BoxDecoration(
            color: c.header,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(_gutter, topInset + 20, _gutter, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: _greeting(),
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
              const SizedBox(height: 4),
              const CommonText(
                text: 'Emas Saham Hari Ini',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 20),
              _buildSummaryCard(c),
            ],
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Widget _buildSummaryCard(CorePalette c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(c, withShadow: true),
      child: BlocBuilder<GoldPriceCubit, GoldPriceState>(
        builder: (context, state) => state.when(
          initial: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeleton(c, height: 14, width: 120),
              const SizedBox(height: 10),
              _skeleton(c, height: 30, width: 200),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _skeleton(c, height: 52)),
                  const SizedBox(width: 10),
                  Expanded(child: _skeleton(c, height: 52)),
                ],
              ),
            ],
          ),
          error: (message) => _buildErrorText(c, message),
          success: (goldPrice) {
            final antam = goldPrice?.getAntam1gr();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: 'Emas Antam 1 gram (Jual)',
                  color: c.gray,
                  fontSize: 13,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: antam?.sellPrice?.toDouble().toRupiah() ?? 'N/A',
                    color: c.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (goldPrice?.timestamp != null) ...[
                  const SizedBox(height: 4),
                  CommonText(
                    text:
                        'Update: ${goldPrice!.timestamp!.toIndonesiaDatetime()}',
                    color: c.gray,
                    fontSize: 11,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniTile(
                        c,
                        leading: _logoAvatar(
                          c,
                          image: PathAsset.png('antam_logo'),
                          radius: 16,
                        ),
                        title: 'Buyback',
                        value:
                            antam?.buybackPrice?.toDouble().toRupiah() ?? 'N/A',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCurrencyTile(c)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrencyTile(CorePalette c) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) => state.when(
        initial: () => _skeleton(c, height: 52),
        error: (_) => _buildMiniTile(
          c,
          leading: _iconAvatar(c, Icons.attach_money, radius: 16),
          title: 'USD/IDR',
          value: 'N/A',
        ),
        success: (currency) => _buildMiniTile(
          c,
          leading: _iconAvatar(c, Icons.attach_money, radius: 16),
          title: 'USD/IDR',
          value: (currency?.usd?.idr ?? 0).toRupiah(),
        ),
      ),
    );
  }

  Widget _buildMiniTile(
    CorePalette c, {
    required Widget leading,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  color: c.gray,
                  fontSize: 11,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: value,
                    color: c.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IHSG chart with selectable range
  // ---------------------------------------------------------------------------

  Widget _buildIhsgChart(CorePalette c) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: _gutter),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(c),
      child: BlocBuilder<IhsgCubit, IhsgState>(
        builder: (context, state) {
          final data = state.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _iconAvatar(c, Icons.show_chart, radius: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: 'IHSG',
                          color: c.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        CommonText(
                          text: 'IDX Composite',
                          color: c.gray,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ),
                  if (data != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CommonText(
                          text: data.price.toIndex(),
                          color: c.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        _changeLabel(c, data.percent),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: _buildIhsgChartBody(c, state),
              ),
              const SizedBox(height: 12),
              _buildRangeSelector(c, context, state.range),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIhsgChartBody(CorePalette c, IhsgState state) {
    final data = state.data;
    if (state.error != null) {
      return Center(child: _buildErrorText(c, state.error!));
    }
    if (data == null) return _skeleton(c, height: 160);
    if (data.points.length < 2) {
      return Center(
        child: CommonText(
          text: 'Data tidak tersedia',
          color: c.gray,
          fontSize: 13,
        ),
      );
    }

    final color = data.change >= 0 ? c.green : c.red;
    final spots = [
      for (var i = 0; i < data.points.length; i++)
        FlSpot(i.toDouble(), data.points[i].close),
    ];
    final timeFormat = switch (state.range) {
      IhsgRange.day => DateFormat('HH:mm'),
      IhsgRange.week => DateFormat('dd MMM HH:mm', 'id_ID'),
      _ => DateFormat('dd MMM yyyy', 'id_ID'),
    };

    return AnimatedOpacity(
      opacity: state.loading ? 0.4 : 1,
      duration: const Duration(milliseconds: 200),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => c.text,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touched) => touched.map((spot) {
                final point = data.points[spot.x.toInt()];
                return LineTooltipItem(
                  '${point.close.toIndex()}\n',
                  TextStyle(
                    color: c.card,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: timeFormat.format(point.time),
                      style: TextStyle(color: c.card, fontSize: 10),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: color,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSelector(
      CorePalette c, BuildContext context, IhsgRange selected) {
    return Row(
      children: IhsgRange.values.map((range) {
        final isSelected = range == selected;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isSelected
                ? null
                : () => context.read<IhsgCubit>().getIhsg(range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CommonText(
                  text: range.label,
                  color: isSelected ? Colors.white : c.gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Top stocks: horizontally scrolling cards
  // ---------------------------------------------------------------------------

  Widget _buildTopStocks(CorePalette c) {
    return BlocBuilder<SahamTop7Cubit, SahamTop7State>(
      builder: (context, state) => state.when(
        initial: () => SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _gutter),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => _skeleton(c, height: 132, width: 160),
          ),
        ),
        error: (message) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: _gutter),
          child: _buildErrorText(c, message),
        ),
        marketClosed: () => _buildMarketClosed(c),
        success: (saham) {
          final items = saham ?? [];
          if (items.isEmpty) return _buildMarketClosed(c);
          return SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: _gutter),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) => _buildStockCard(c, items[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStockCard(CorePalette c, IdxTop7Model saham) {
    final code = saham.code ?? '-';
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(c),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _stockLogo(c, code),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: code,
                      color: c.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    CommonText(
                      text: 'Saham IDX',
                      color: c.gray,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          CommonText(text: 'Harga', color: c.gray, fontSize: 11),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: (saham.price ?? 0).toRupiah(),
                    color: c.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _changeLabel(c, saham.percent ?? 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketClosed(CorePalette c) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: _gutter),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(c),
      child: Row(
        children: [
          _iconAvatar(c, Icons.storefront, radius: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: 'Pasar Sedang Tutup',
                  color: c.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 2),
                CommonText(
                  text: 'Bursa efek saat ini tidak aktif',
                  color: c.gray,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Gold price list (watchlist style)
  // ---------------------------------------------------------------------------

  Widget _buildGoldList(CorePalette c) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: _gutter),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: _cardDecoration(c),
      child: BlocBuilder<GoldPriceCubit, GoldPriceState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: 'Daftar Harga Emas',
              color: c.text,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 8),
            ...state.when(
              initial: () => List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _skeleton(c, height: 44),
                ),
              ),
              error: (message) => [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildErrorText(c, message),
                ),
              ],
              success: (goldPrice) {
                final items = goldPrice?.data ?? [];
                return List.generate(
                  items.length,
                  (index) => _buildGoldRow(
                    c,
                    items[index],
                    showDivider: index != items.length - 1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldRow(CorePalette c, Datum item, {required bool showDivider}) {
    final type = item.materialType ?? item.material ?? 'Emas';
    final isAntam = type.toLowerCase().contains('antam');
    final weight = item.weight != null
        ? '${item.weight} ${item.weightUnit ?? 'gr'}'
        : (item.source ?? '');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border:
            showDivider ? Border(bottom: BorderSide(color: c.border)) : null,
      ),
      child: Row(
        children: [
          _logoAvatar(
            c,
            image: PathAsset.png(isAntam ? 'antam_logo' : 'rp_gold'),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: type,
                  color: c.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textOverflow: TextOverflow.ellipsis,
                ),
                CommonText(text: weight, color: c.gray, fontSize: 12),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CommonText(
                text: item.sellPrice?.toDouble().toRupiah() ?? 'N/A',
                color: c.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              CommonText(
                text:
                    'Buyback ${item.buybackPrice?.toDouble().toRupiah() ?? '-'}',
                color: c.gray,
                fontSize: 11,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared building blocks
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(CorePalette c, String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _gutter),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: title,
            color: c.text,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          if (trailing != null)
            CommonText(
              text: trailing,
              color: c.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(CorePalette c, {bool withShadow = false}) {
    return BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(16),
      border: _isDark(c) ? Border.all(color: c.border) : null,
      boxShadow: [
        BoxShadow(
          color: c.shadow.withValues(
            alpha: (withShadow ? 0.10 : 0.04) * (_isDark(c) ? 3 : 1),
          ),
          blurRadius: withShadow ? 24 : 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _changeLabel(CorePalette c, double percent) {
    final isPositive = percent >= 0;
    final color = isPositive ? c.green : c.red;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: color,
          size: 18,
        ),
        CommonText(
          text: '${percent.abs().toStringAsFixed(2)}%',
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _initialsAvatar(CorePalette c, String code) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: c.primary.withValues(alpha: 0.08),
      child: CommonText(
        text: code.length > 2 ? code.substring(0, 2) : code,
        color: c.primary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  bool _isDark(CorePalette c) => identical(c, CorePalette.dark);

  /// Company logo loaded from the network, falling back to initials.
  Widget _stockLogo(CorePalette c, String code) {
    return ClipOval(
      child: SizedBox.square(
        dimension: 36,
        child: Image.network(
          stockLogoUrl(code),
          fit: BoxFit.contain,
          frameBuilder: (_, child, frame, __) => frame == null
              ? _initialsAvatar(c, code)
              : ColoredBox(color: Colors.white, child: child),
          errorBuilder: (_, __, ___) => _initialsAvatar(c, code),
        ),
      ),
    );
  }

  Widget _logoAvatar(CorePalette c,
      {required String image, required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _isDark(c) ? Colors.white : c.bg,
      child: Padding(
        padding: EdgeInsets.all(radius * 0.35),
        child: Image.asset(image),
      ),
    );
  }

  Widget _iconAvatar(CorePalette c, IconData icon, {required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: c.primary.withValues(alpha: 0.08),
      child: Icon(icon, color: c.primary, size: radius),
    );
  }

  Widget _skeleton(CorePalette c, {required double height, double? width}) {
    return SkeletonAnimation(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: c.skeleton,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorText(CorePalette c, String message) {
    return CommonText(text: message, color: c.red, fontSize: 13);
  }

  @override
  State<StatefulWidget> createState() => DashboardController();
}
