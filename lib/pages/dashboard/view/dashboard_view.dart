import 'package:flutter/material.dart';
import 'package:golden_price/core/extensions/date_extension.dart';
import 'package:golden_price/pages/dashboard/controller/dashboard_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, DashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.amber[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPriceCard(),
            const SizedBox(height: 16),
            _buildChartPlaceholder(),
            const SizedBox(height: 16),
            _buildTrendCards(),
            const SizedBox(height: 16),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Harga Emas Hari Ini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Rp2,310.50 / gram',
                style: TextStyle(fontSize: 24, color: Colors.green)),
            SizedBox(height: 4),
            Text('Updated: ${todayDate.toIndonesiaDatetime()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'Price Chart Placeholder',
            style: TextStyle(color: Colors.grey[600]),
          ),
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

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        ),
        ElevatedButton.icon(
          onPressed: () {},
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
