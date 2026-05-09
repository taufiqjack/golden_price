import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/ads/native_ads.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/core/helpers/connection_internet.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/core/services/iap_service.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:golden_price/pages/no_connection/no_connection_view.dart';
import 'package:golden_price/widgets/common_text.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DashboardController extends State<DashboardView> {
  final IAPService _iapService = IAPService();
  bool _isPremium = false;

  bool get isPremium => _isPremium;

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

    _initIAP();

    super.initState();
  }

  Future<void> _initIAP() async {
    await _iapService.initialize();
    setState(() {
      _isPremium = _iapService.isPremium;
    });
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

  void showUpgradeDialog() {
    final product = _iapService.getPremiumProduct();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: CommonText(
                  text: 'Upgrade to Premium',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Get unlimited access to premium features:',
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              SizedBox(height: 16),
              _buildFeatureItem(Icons.ads_click, 'Remove all ads'),
              _buildFeatureItem(
                  Icons.show_chart, 'Advanced charts and analytics'),
              _buildFeatureItem(
                  Icons.notifications_active, 'Real-time price alerts'),
              _buildFeatureItem(Icons.star, 'Priority customer support'),
              SizedBox(height: 16),
              if (product != null)
                Center(
                  child: CommonText(
                    text: product.price,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                )
              else
                Center(
                  child: CommonText(
                    text: 'Loading...',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CommonText(text: 'Cancel', color: Colors.grey),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (product != null) {
                  final success = await _iapService.purchasePremium(product);
                  if (success) {
                    setState(() {
                      _isPremium = true;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child:
                  CommonText(text: 'Upgrade Now', fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green.shade600),
          SizedBox(width: 12),
          Expanded(
            child: CommonText(
              text: text,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  BannerAd? bannerAd;

  @override
  void dispose() {
    _iapService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
