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

  // 👇 TAMBAHKAN METHOD REFRESH INI
  Future<void> _refreshHistory() async {
    if (_userId != null && _userId != 0) {
      setState(() {
        _historyFuture = _historyController.getHistory();
      });

      // Tunggu sampai data selesai di-fetch
      try {
        await _historyFuture;

        // Tampilkan feedback sukses
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Riwayat berhasil diperbarui'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Jika error, tidak perlu tampilkan snackbar karena sudah ada error state
        print("Error refreshing history: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Riwayat Deteksi", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _userId == null
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
              onRefresh: _refreshHistory,
              color: Colors.blueAccent,
              backgroundColor: Colors.white,
              child: FutureBuilder<List<dynamic>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 100),
                        Center(child: _buildErrorState(snapshot.error.toString())),
                      ],
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(child: _buildEmptyState()),
                      ],
                    );
                  }

                  final data = snapshot.data!;
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return _buildModernCard(data[index]);
                    },
                  );
                },
              ),
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
                          Expanded(
                            child: Text(
                              "${item['hari']}, ${item['tanggal']} ${item['bulan']} ${item['tahun']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16,
                                color: Colors.blueGrey
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.blue[700],
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

  // 👇 PERBAIKI ERROR STATE DENGAN TOMBOL RETRY
  Widget _buildErrorState(String error) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            "Gagal memuat data riwayat",
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _refreshHistory,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Coba Lagi"),
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
    );
  }

  // 👇 TAMBAHKAN EMPTY STATE YANG LEBIH MENARIK
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Colors.blue.shade300),
          const SizedBox(height: 16),
          Text(
            "Belum ada riwayat deteksi",
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Mulai scan postur tubuhmu untuk\nmelihat riwayat deteksi",
            style: TextStyle(
              color: Colors.blue.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}