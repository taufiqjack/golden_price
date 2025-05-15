import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/helpers/connection_internet.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:golden_price/pages/no_connection/no_connection_view.dart';

class DashboardController extends State<DashboardView> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      refresh();
    });

    super.initState();
  }

  SahamTop7Cubit sahamTop7Cubit = SahamTop7Cubit();
  GoldPriceCubit goldPricesModel = GoldPriceCubit();
  CurrencyCubit currencyCubit = CurrencyCubit();

  refresh() async {
    goldPricesModel = context.read<GoldPriceCubit>()..getGoldPrice(context);
    currencyCubit = context.read<CurrencyCubit>()
      ..getCurrency(context, todayDate.toStripID());
    context.read<SahamTop7Cubit>().getSahamTop7(context);
    ConnectionInternet.isInternet().then(
      (connected) async {
        if (connected!) {
        } else {
          Go.to(NoConnectionView());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
