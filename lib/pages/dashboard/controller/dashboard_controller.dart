import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/ads/native_ads.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/helpers/connection_internet.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:golden_price/pages/no_connection/no_connection_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DashboardController extends State<DashboardView> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      refresh();
    });
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerADS,
        listener: const BannerAdListener(),
        request: const AdRequest());
    bannerAd!.load();

    super.initState();
  }

  SahamTop7Cubit sahamTop7Cubit = SahamTop7Cubit();
  GoldPriceCubit goldPricesModel = GoldPriceCubit();
  CurrencyCubit currencyCubit = CurrencyCubit();

  refresh() async {
    sahamTop7Cubit = context.read<SahamTop7Cubit>()..getSahamTop7(context);
    goldPricesModel = context.read<GoldPriceCubit>()..getGoldPrice(context);
    currencyCubit = context.read<CurrencyCubit>()
      ..getCurrency(context, todayDate.toStripID());
    ConnectionInternet.isInternet().then(
      (connected) async {
        if (connected!) {
        } else {
          Go.to(NoConnectionView());
        }
      },
    );
  }

  BannerAd? bannerAd;

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
