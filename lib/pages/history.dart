import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/history_controller.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final HistoryController _historyController = HistoryController();
  bool isLoading = true;
  Future<List<dynamic>>? _historyFuture;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
        _historyFuture = _historyController.getHistory();
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background lebih soft
      appBar: AppBar(
        title: const Text("Riwayat Deteksi", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _userId == null
          ? const Center(child: Text("Silakan login terlebih dahulu"))
          : FutureBuilder<List<dynamic>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: _buildErrorState(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada data riwayat."));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _buildModernCard(data[index]);
                  },
                );
              },
            ),
    );
  }

  Widget _buildModernCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Garis Vertikal Indikator (Biru)
              Container(width: 6, color: Colors.blueAccent),
              
              // Konten Utama
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item['hari']}, ${item['tanggal']} ${item['bulan']} ${item['tahun']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              color: Colors.blueGrey
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10)
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 20),
                      
                      // Statistik Data Tubuh
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Lengan", item['lengan'].toString(), Colors.orange),
                          _buildStatItem("Perut", item['perut'].toString(), Colors.green),
                          _buildStatItem("Paha", item['paha'].toString(), Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
            color: color
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
        const SizedBox(height: 10),
        Text("Gagal memuat data: $error", textAlign: TextAlign.center),
      ],
    );
  }
}