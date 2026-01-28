import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/report_controller.dart';
import '../components/buttom_navigation.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();

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
  
  Future<Map<String, dynamic>>? _reportFuture;
  int? _userId;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _loadUserReport();
  }

  Future<void> _loadUserReport() async {
    final prefs = await SharedPreferences.getInstance();
    final dynamic savedIdData = prefs.get('id');
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

  // 👇 TAMBAHKAN METHOD REFRESH INI
  Future<void> _refreshReport() async {
    if (_userId != null && _userId != 0) {
      setState(() {
        _reportFuture = _reportController.getReportData();
      });

      // Tunggu sampai data selesai di-fetch
      await _reportFuture;

      // Tampilkan feedback sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Laporan berhasil diperbarui'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCheckingSession
          ? const Center(child: CircularProgressIndicator())
          : _userId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        "Silakan login terlebih dahulu",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshReport,
                  color: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _reportFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Gagal memuat data laporan",
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: _refreshReport,
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text("Muat Ulang"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final data = snapshot.data;
                      final List<dynamic> weightTrend = (data != null && data['weight_trend'] != null) 
                          ? data['weight_trend'] as List 
                          : [];

                      final Map<String, dynamic> stats = (data != null && data['posture_stats'] != null)
                          ? data['posture_stats'] as Map<String, dynamic>
                          : {};

                      return SafeArea(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(15),
                          children: [
                            const Text(
                              "Grafik Perkembangan", 
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                            ),
                            const SizedBox(height: 20),
                            _buildWeightChart(weightTrend),
                            const SizedBox(height: 25),
                            _buildPostureAnalysis(stats),
                            const SizedBox(height: 20), // Padding bawah
                          ],
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildWeightChart(List<dynamic> trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Berat Badan Per Bulan (kg)", 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 40),
          trend.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.show_chart, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada data berat badan",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : AspectRatio(
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
                                return Text(
                                  trend[value.toInt()]['bulan'], 
                                  style: const TextStyle(fontSize: 10)
                                );
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

  Widget _buildPostureAnalysis(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Analisis Postur Terbanyak", 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          if (stats.isEmpty) 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.accessibility_new, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      "Belum ada data deteksi",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ...stats.entries.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.analytics, color: Colors.blue.shade600, size: 20),
              ),
              title: Text(e.key),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${e.value} Kali",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    );
  }
}