import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/report_controller.dart'; // Pastikan file controller sudah dibuat
import '../components/buttom_navigation.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();

  // Fungsi pembantu untuk membuat batang grafik
  static BarChartGroupData _makeGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue.shade600,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }
}

class _ReportState extends State<Report> {
  final ReportController _reportController = ReportController();
  
  // 1. Hilangkan 'late' dan buat menjadi nullable agar tidak error saat build awal
  Future<Map<String, dynamic>>? _reportFuture;
  int? _userId;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _loadUserReport();
  }

  // 2. Perbaikan logika pengambilan ID (String vs Int)
  Future<void> _loadUserReport() async {
    final prefs = await SharedPreferences.getInstance();
    final dynamic savedIdData = prefs.get('id'); // Gunakan .get() agar fleksibel
    int? finalId;

    if (savedIdData is int) {
      finalId = savedIdData;
    } else if (savedIdData is String) {
      finalId = int.tryParse(savedIdData);
    }

    setState(() {
      _userId = finalId;
      if (finalId != null && finalId != 0) {
        _reportFuture = _reportController.getReportData();
      }
      _isCheckingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCheckingSession
          ? const Center(child: CircularProgressIndicator())
          : _userId == null
              ? const Center(child: Text("Silakan login terlebih dahulu"))
              : FutureBuilder<Map<String, dynamic>>(
                  future: _reportFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(child: Text("Gagal memuat data laporan"));
                    }

                    final data = snapshot.data;
                    final List<dynamic> weightTrend = (data != null && data['weight_trend'] != null) 
                        ? data['weight_trend'] as List 
                        : [];

                    final Map<String, dynamic> stats = (data != null && data['posture_stats'] != null)
                        ? data['posture_stats'] as Map<String, dynamic>
                        : {};

                    return SafeArea(
                      child: 
                        ListView(
                          padding: const EdgeInsets.all(15),
                          children: [
                            const Text("Grafik Perkembangan", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            _buildWeightChart(weightTrend),
                            const SizedBox(height: 25),
                            _buildPostureAnalysis(stats),
                          ],
                        ),
                      
                    );
                  },
                ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  // Widget Grafik Berat Badan
  Widget _buildWeightChart(List<dynamic> trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Berat Badan Per Bulan (kg)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                maxY: 120,
                barGroups: trend.asMap().entries.map((e) {
                  return Report._makeGroup(e.key, e.value['berat'].toDouble());
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < trend.length) {
                          return Text(trend[value.toInt()]['bulan'], style: const TextStyle(fontSize: 10));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Ringkasan Kondisi Tubuh
  Widget _buildPostureAnalysis(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Analisis Postur Terbanyak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Menghitung kemunculan status dari kolom perut_status
          if (stats.isEmpty) const Text("Belum ada data deteksi"),
          ...stats.entries.map((e) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(e.key),
            trailing: Text("${e.value} Kali", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          )),
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]
    );
  }
}