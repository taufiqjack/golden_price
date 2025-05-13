import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';

class DashboardController extends State<DashboardView> {
  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() async {
    context.read<GoldPriceCubit>().getGoldPrice(context);
    context.read<CurrencyCubit>().getCurrency(context, todayDate.toStripID());
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
