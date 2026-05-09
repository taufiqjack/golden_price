import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_state.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_state.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_state.dart';
import 'package:golden_price/core/components/asset_path.dart';
import 'package:golden_price/core/components/containers.dart';
import 'package:golden_price/core/components/dialogs.dart';
import 'package:golden_price/core/constants/color_customs.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/extensions/money_extension.dart';
import 'package:golden_price/core/models/currency_model/currency_model.dart';
import 'package:golden_price/core/models/gold_model/gold_model.dart';
import 'package:golden_price/core/models/idx_top7_model/idx_top7_model.dart';
import 'package:golden_price/core/services/iap_service.dart';
import 'package:golden_price/pages/dashboard/controller/dashboard_controller.dart';
import 'package:golden_price/widgets/common_text.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, DashboardController controller) {
    return Scaffold(
      backgroundColor: coreBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: coreBgColor,
        title: CommonText(
          text: 'Dashboard',
          color: coreTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: controller.bannerAd != null
            ? PreferredSize(
                preferredSize: Size(
                  controller.bannerAd!.size.width.toDouble(),
                  controller.bannerAd!.size.height.toDouble(),
                ),
                child: SizedBox(
                  height: controller.bannerAd!.size.height.toDouble(),
                  width: controller.bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: controller.bannerAd!),
                ),
              )
            : null,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => exitApp(context),
        child: RefreshIndicator(
          onRefresh: () async => controller.refresh(),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<GoldPriceCubit, GoldPriceState>(
                    builder: (context, state) {
                      return state.when(
                          initial: () => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SkeletonAnimation(
                                    child: Container(
                                      height: 170,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorLightGreyFour),
                                    ),
                                  ).bottomPadded20(),
                                  SkeletonAnimation(
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorLightGreyFour),
                                    ),
                                  ).bottomPadded20(),
                                  ListView.builder(
                                      padding: EdgeInsets.only(),
                                      itemCount: 3,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SkeletonAnimation(
                                                child: Container(
                                                  height: 50,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          colorLightGreyFour),
                                                ),
                                              ).bottomPadded6(),
                                              SkeletonAnimation(
                                                child: Container(
                                                  height: 50,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          colorLightGreyFour),
                                                ),
                                              ).bottomPadded8(),
                                              SkeletonAnimation(
                                                child: Container(
                                                  height: 50,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          colorLightGreyFour),
                                                ),
                                              ),
                                            ],
                                          ))
                                ],
                              ).paddedLTRB(left: 8, right: 8),
                          error: (message) => Center(
                                child: CommonText(text: message),
                              ),
                          success:
                              (goldPrice) =>
                                  BlocBuilder<CurrencyCubit, CurrencyState>(
                                    builder: (context, state) {
                                      return state.when(
                                        initial: () => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SkeletonAnimation(
                                              child: Container(
                                                height: 150,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: colorLightGreyFour),
                                              ),
                                            ).bottomPadded20(),
                                            SkeletonAnimation(
                                              child: Container(
                                                height: 150,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: colorLightGreyFour),
                                              ),
                                            ).bottomPadded20(),
                                            ListView.builder(
                                                padding: EdgeInsets.only(),
                                                itemCount: 3,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) =>
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SkeletonAnimation(
                                                          child: Container(
                                                            height: 50,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    colorLightGreyFour),
                                                          ),
                                                        ).bottomPadded6(),
                                                        SkeletonAnimation(
                                                          child: Container(
                                                            height: 50,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    colorLightGreyFour),
                                                          ),
                                                        ).bottomPadded8(),
                                                        SkeletonAnimation(
                                                          child: Container(
                                                            height: 50,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    colorLightGreyFour),
                                                          ),
                                                        ),
                                                      ],
                                                    )).bottomPadded12(),
                                          ],
                                        ).paddedLTRB(left: 16, right: 16),
                                        error: (message) => Center(
                                          child: CommonText(text: message),
                                        ),
                                        success: (currency) => Column(
                                          children: [
                                            _buildWishlistSection(
                                              goldPrice: goldPrice,
                                              currency: currency!,
                                            ),
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  1.3, // Adjusted height
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    BlocBuilder<SahamTop7Cubit,
                                                        SahamTop7State>(
                                                      builder:
                                                          (context, state) {
                                                        return state.when(
                                                          initial: () => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ListView.builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(),
                                                                  itemCount: 3,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SkeletonAnimation(
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: coreSecondaryColor),
                                                                                ),
                                                                              ).bottomPadded6(),
                                                                              SkeletonAnimation(
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: coreSecondaryColor),
                                                                                ),
                                                                              ).bottomPadded8(),
                                                                              SkeletonAnimation(
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: coreSecondaryColor),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )).bottomPadded12(),
                                                            ],
                                                          ).paddedLTRB(
                                                              left: 8,
                                                              right: 8),
                                                          error: (message) =>
                                                              Center(
                                                            child: CommonText(
                                                                text: message),
                                                          ),
                                                          marketClosed: () =>
                                                              _buildMarketClosed(),
                                                          success:
                                                              (sahamTop7) =>
                                                                  Column(
                                                            children: [
                                                              _buildPlaceholderSaham(
                                                                  sahamTop7!),
                                                              const SizedBox(
                                                                  height: 16),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistSection({
    required GoldModel? goldPrice,
    required CurrencyModel currency,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildWishlistCard(
                title: 'ANTAM',
                subtitle: 'Harga Emas',
                value: goldPrice
                        ?.getAntam1gr()
                        ?.sellPrice
                        ?.toDouble()
                        .toRupiah() ??
                    'N/A',
                updateTime: goldPrice?.timestamp != null
                    ? 'Updated: ${goldPrice!.timestamp!.toIndonesiaDatetime()}'
                    : null,
                percent: '+0.45%', // Placeholder as no historic data for calc
                isPositive: true,
                logo: PathAsset.png('antam_logo'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildWishlistCard(
                title: 'USD/IDR',
                subtitle: 'Kurs Dollar',
                value: double.parse(currency.usd!.idr.toString()).toRupiah(),
                percent: '+0.12%', // Placeholder
                isPositive: true,
                iconData: Icons.attach_money,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWishlistCard({
    required String title,
    required String subtitle,
    required String value,
    required String percent,
    required bool isPositive,
    String? updateTime,
    String? logo,
    IconData? iconData,
  }) {
    final color = isPositive ? spectrumGreen : spectrumRed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: coreSecondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.05),
                child: logo != null
                    ? Image.asset(logo, height: 20)
                    : Icon(iconData, color: Colors.blueAccent, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: coreTextColor,
                    ),
                    CommonText(
                      text: subtitle,
                      fontSize: 10,
                      color: coreGrayColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            children: [
              CommonText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: coreTextColor,
              ),
              if (updateTime != null)
                CommonText(
                  text: updateTime,
                  fontSize: 8,
                  color: coreGrayColor,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: percent,
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 20,
                width: 50,
                child: LineChart(
                  LineChartData(
                    minY: -5,
                    maxY: 5,
                    titlesData: FlTitlesData(show: false),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: color,
                        barWidth: 1.5,
                        dotData: FlDotData(show: false),
                        spots: [
                          FlSpot(0, 0),
                          FlSpot(0.2, 1),
                          FlSpot(0.4, -1),
                          FlSpot(0.6, 2),
                          FlSpot(0.8, 1),
                          FlSpot(1, 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketClosed() {
    return Card(
      color: coreSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.storefront,
              size: 48,
              color: coreGrayColor,
            ),
            const SizedBox(height: 12),
            CommonText(
              text: 'Pasar Sedang Tutup',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: coreTextColor,
            ),
            const SizedBox(height: 4),
            CommonText(
              text: 'Bursa efek saat ini tidak aktif',
              fontSize: 12,
              color: coreGrayColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderSaham(List<IdxTop7Model> saham) {
    return Card(
      color: coreSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: 'Saham',
                  fontSize: 18,
                  color: coreTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ).bottomPadded16(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: saham.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final sahams = saham[index];
                final isPositive = (sahams.percent ?? 0) >= 0;
                final color = isPositive ? spectrumGreen : spectrumRed;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.05),
                        child: CommonText(
                          text: sahams.code?.substring(0, 1) ?? '',
                          color: coreTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: '${sahams.code}',
                              fontWeight: FontWeight.w700,
                              color: coreTextColor,
                            ),
                            CommonText(
                              text: 'Saham IDX',
                              color: coreGrayColor,
                              fontSize: 11,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 30,
                          child: LineChart(
                            LineChartData(
                              minY: -10,
                              maxY: 10,
                              titlesData: FlTitlesData(show: false),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: color,
                                  barWidth: 2,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        color.withOpacity(0.2),
                                        color.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                  spots: [
                                    FlSpot(0, 0),
                                    FlSpot(0.2, (sahams.percent ?? 0) * 0.5),
                                    FlSpot(0.4, (sahams.percent ?? 0) * 0.2),
                                    FlSpot(0.6, (sahams.percent ?? 0) * 0.8),
                                    FlSpot(0.8, (sahams.percent ?? 0) * 0.4),
                                    FlSpot(1, (sahams.percent ?? 0)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CommonText(
                              text: (sahams.price ?? 0).toRupiah(),
                              fontWeight: FontWeight.w700,
                              color: coreTextColor,
                              fontSize: 14,
                            ),
                            CommonText(
                              text:
                                  '${isPositive ? '+' : ''}${sahams.percent?.toStringAsFixed(2)}%',
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeButton(
      BuildContext context, DashboardController controller) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.showUpgradeDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade400, Colors.orange.shade500],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium, color: Colors.white, size: 18),
              SizedBox(width: 6),
              CommonText(
                text: 'Upgrade',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => DashboardController();
}
