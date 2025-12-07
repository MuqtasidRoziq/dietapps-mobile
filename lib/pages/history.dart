import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();

  static BarChartGroupData _makeGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue.shade600,
          width: 30,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Grafik Perkembangan",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // === Container Grafik ===
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Perkembangan Berat Badan Per Bulan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // DropdownButton<String>(
                    //   value: _selectedValue,
                    //   items: <String>['Januari', 'Februari', 'Maret'].map((Strng value)), onChanged: onChanged)
                  ],
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.9,
                  child: BarChart(
                    BarChartData(
                      // === Garis Sumbu (Tebal di kiri & bawah) ===
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5),
                          left: BorderSide(color: Colors.transparent),
                          right: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),

                      minY: 0,
                      maxY: 150,

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.shade400,
                          strokeWidth: 0.5,
                        ),
                      ),

                      // === Label Sumbu ===
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                        // Label bawah (X Axis)
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const month = ['january', 'february', 'march', 'april', 'may', 'june', 'july'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  month[value.toInt() % month.length],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // === Tooltip (Label Nilai di Atas Batang) ===
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.transparent,
                          tooltipPadding: EdgeInsets.zero,
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(1)} ',
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),

                      // === Data Batang ===
                      barGroups: [
                        History._makeGroup(0, 90),
                        History._makeGroup(1, 76),
                        History._makeGroup(2, 75),
                        History._makeGroup(3, 74),
                        History._makeGroup(4, 73),
                        History._makeGroup(5, 73),
                        History._makeGroup(6, 72),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
