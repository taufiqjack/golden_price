import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/components/asset_path.dart';
import 'package:golden_price/core/components/containers.dart';
import 'package:golden_price/core/constants/color_customs.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/extensions/money_extension.dart';
import 'package:golden_price/core/models/currency_model/currency_model.dart';
import 'package:golden_price/core/models/gold_prices_mode/gold_price_mode.dart';
import 'package:golden_price/pages/dashboard/controller/dashboard_controller.dart';
import 'package:golden_price/widgets/common_text.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, DashboardController controller) {
    return Scaffold(
      backgroundColor: whiteTwo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteTwo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GoldPriceCubit, GoldPriceState>(
          builder: (context, state) {
            return state.when(
                initial: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SkeletonAnimation(
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colorLightGreyFour),
                          ),
                        ).bottomPadded12(),
                        SkeletonAnimation(
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colorLightGreyFour),
                          ),
                        ),
                      ],
                    ).paddedLTRB(left: 16, right: 16),
                error: (message) => Center(
                      child: CommonText(text: message),
                    ),
                success: (goldPrice) =>
                    BlocBuilder<CurrencyCubit, CurrencyState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SkeletonAnimation(
                                child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: colorLightGreyFour),
                                ),
                              ).bottomPadded12(),
                              SkeletonAnimation(
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: colorLightGreyFour),
                                ),
                              ),
                            ],
                          ).paddedLTRB(left: 16, right: 16),
                          error: (message) => Center(
                            child: CommonText(text: message),
                          ),
                          success: (currency) => Column(
                            children: [
                              _buildPriceCard(goldPrice!),
                              const SizedBox(height: 16),
                              _buildChartPlaceholder(currency!),
                              const SizedBox(height: 16),
                              // _buildTrendCards(),
                              // const SizedBox(height: 16),
                              _buildQuickActions(controller),
                            ],
                          ),
                        );
                      },
                    ));
          },
        ),
      ),
    );
  }

  Widget _buildPriceCard(GoldPricesModel gold) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              PathAsset.png('antam_logo'),
              height: 50,
            ),
            CommonText(
              text: 'Harga Emas Hari Ini',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: gold.data?.length,
              itemBuilder: (context, index) {
                final goldPrice = gold.data![index];
                return Align(
                  alignment: Alignment.center,
                  child: CommonText(
                    text:
                        '${double.parse(goldPrice.buy.toString()).toRupiah()} / ${goldPrice.unit}',
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            SizedBox(height: 4),
            CommonText(
              text: 'Updated: ${todayDate.toIndonesiaDatetime()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder(CurrencyModel currency) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CommonText(
                text: '1 USD',
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            CommonText(
              text: double.parse(currency.usd!.idr.toString()).toRupiah(),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _TrendCard(title: '1D', change: '+1.2%'),
        _TrendCard(title: '1W', change: '+3.5%'),
        _TrendCard(title: '1M', change: '-0.8%'),
      ],
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
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        ),
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.notifications),
          label: const Text('Set Alert'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        ),
      ],
    );
  }

  @override
  State<StatefulWidget> createState() => DashboardController();
}

class _TrendCard extends StatelessWidget {
  final String title;
  final String change;

  const _TrendCard({required this.title, required this.change});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[100],
      child: SizedBox(
        width: 80,
        height: 60,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(change, style: TextStyle(color: Colors.green[700])),
            ],
          ),
        ),
      ),
    );
  }
}
