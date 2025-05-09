import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/bloc/cubits/cubit/gold_price_cubit.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';

class DashboardController extends State<DashboardView> {
  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() async {
    context.read<GoldPriceCubit>().getGoldPrice(context);
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
