import 'package:flutter/material.dart';
import 'package:golden_price/core/components/containers.dart';
import 'package:golden_price/core/constants/color_customs.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:golden_price/widgets/common_text.dart';

class NoConnectionView extends StatefulWidget {
  const NoConnectionView({super.key});

  @override
  State<NoConnectionView> createState() => _NoConnectionViewState();
}

class _NoConnectionViewState extends State<NoConnectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 70,
              backgroundColor: red.withOpacity(0.1),
              child: Image.asset(
                height: 100,
                'assets/images/no_internet.png',
              )).bottomPadded16().bottomPadded16(),
          CommonText(
            text: 'Oops! Tidak ada Koneksi Internet!',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ).bottomPadded24(),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorGreenLightTwo),
            child: TextButton(
              onPressed: () => Go.to(DashboardView()),
              child: Center(
                child: CommonText(
                  text: 'Coba Lagi',
                  color: white,
                ),
              ),
            ),
          ).paddedLTRB(right: 24, left: 24)
        ],
      ).paddedLTRB(right: 16, left: 16),
    );
  }
}
