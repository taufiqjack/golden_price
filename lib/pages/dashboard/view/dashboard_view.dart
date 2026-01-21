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
import 'package:golden_price/pages/dashboard/controller/dashboard_controller.dart';
import 'package:golden_price/widgets/common_text.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, DashboardController controller) {
    return Scaffold(
      backgroundColor: coreBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: coreBgColor,
        title: Row(
          children: [
            CommonText(
              text: 'Dashboard',
              color: coreTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            if (controller.bannerAd != null) ...[
              SizedBox(
                height: controller.bannerAd!.size.height.toDouble(),
                width: controller.bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: controller.bannerAd!),
              ),
            ]
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => exitApp(context),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
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
                                        borderRadius: BorderRadius.circular(5),
                                        color: colorLightGreyFour),
                                  ),
                                ).bottomPadded20(),
                                SkeletonAnimation(
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                                    color: colorLightGreyFour),
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
                                                    color: colorLightGreyFour),
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
                                                    color: colorLightGreyFour),
                                              ),
                                            ),
                                          ],
                                        ))
                              ],
                            ).paddedLTRB(left: 8, right: 8),
                        error: (message) => Center(
                              child: CommonText(text: message),
                            ),
                        success: (goldPrice) =>
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
                                                                  .circular(5),
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
                                                                  .circular(5),
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
                                                                  .circular(5),
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
                                      _buildPriceCard(goldPrice),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                1.8,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              _buildChartPlaceholder(currency!),
                                              const SizedBox(height: 16),
                                              BlocBuilder<SahamTop7Cubit,
                                                  SahamTop7State>(
                                                builder: (context, state) {
                                                  return state.when(
                                                    initial: () => Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ListView.builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(),
                                                                itemCount: 3,
                                                                shrinkWrap: true,
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
                                                                        ))
                                                            .bottomPadded12(),
                                                      ],
                                                    ).paddedLTRB(
                                                        left: 8, right: 8),
                                                    error: (message) => Center(
                                                      child: CommonText(
                                                          text: message),
                                                    ),
                                                    success: (sahamTop7) =>
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
                                              _buildQuickActions(controller),
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
    );
  }

  Widget _buildPriceCard(GoldModel? gold) {
    return Card(
      color: coreSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: 'Harga Emas',
                  fontSize: 16,
                  color: coreTextColor,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: corePrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    PathAsset.png('antam_logo'),
                    height: 24,
                  ),
                ),
              ],
            ).bottomPadded12(),
            gold == null || gold.data?.current == null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      text: 'Data tidak tersedia',
                      color: spectrumRed,
                      fontStyle: FontStyle.italic,
                    ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text:
                            '${gold.data!.current!.buy!.toDouble().toRupiah()} / gr',
                        fontSize: 20,
                        color: coreTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 4),
                      CommonText(
                        text:
                            'Updated: ${(gold?.data?.current?.updatedAt ?? todayDate).toIndonesiaDatetime()}',
                        color: coreGrayColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder(CurrencyModel currency) {
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
            CommonText(
              text: 'Kurs Dollar',
              fontSize: 18,
              color: coreTextColor,
              fontWeight: FontWeight.w600,
            ).bottomPadded12(),
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CommonText(
                      text: '1 USD',
                      fontSize: 18,
                      color: coreGrayColor,
                    ),
                  ),
                  CommonText(
                    text: double.parse(currency.usd!.idr.toString()).toRupiah(),
                    fontSize: 24,
                    color: coreTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
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
            CommonText(
              text: 'Saham Top 7',
              fontSize: 18,
              color: coreTextColor,
              fontWeight: FontWeight.w600,
            ).bottomPadded12(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: saham.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final sahams = saham[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: '${sahams.code}',
                            fontWeight: FontWeight.w700,
                            color: coreTextColor,
                          ),
                          CommonText(
                            text: (double.parse(sahams.price.toString())
                                    .toRupiah())
                                .toString(),
                            color: coreGrayColor,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: LineChart(
                          LineChartData(
                            minY:
                                -100000, // Allow negative values for down trends
                            maxY: 100000,
                            titlesData: FlTitlesData(show: false),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                color: sahams.percent! >= 0
                                    ? spectrumGreen
                                    : spectrumRed,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      (sahams.percent! >= 0
                                              ? spectrumGreen
                                              : spectrumRed)
                                          .withOpacity(0.3),
                                      (sahams.percent! >= 0
                                              ? spectrumGreen
                                              : spectrumRed)
                                          .withOpacity(0.0),
                                    ],
                                  ),
                                ),
                                spots: [
                                  FlSpot(0, 0),
                                  FlSpot(1, sahams.percent! * 1000),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      CommonText(
                        text: '${sahams.percent}%',
                        color:
                            sahams.percent! >= 0 ? spectrumGreen : spectrumRed,
                        fontWeight: FontWeight.bold,
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

  Widget _buildQuickActions(DashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            controller.refresh();
          },
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text('Refresh', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: corePrimaryColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.notifications, color: Colors.white54),
          label:
              const Text('Set Alert', style: TextStyle(color: Colors.white54)),
          style: ElevatedButton.styleFrom(
            backgroundColor: coreSecondaryColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  State<StatefulWidget> createState() => DashboardController();
}
