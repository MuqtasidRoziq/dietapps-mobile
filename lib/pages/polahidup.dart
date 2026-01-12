import 'package:diet_apps/components/snackbar.dart';
import 'package:diet_apps/controllers/recommendation_controller.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/components/category_button.dart';
class RePolahidup extends StatefulWidget {
  const RePolahidup({super.key});

  @override
  State<RePolahidup> createState() => _RePolahidupState();
}

class _RePolahidupState extends State<RePolahidup> {
  String selectedCategory = "Makanan";
  Map<String, dynamic> dataReal = {'makanan': [], 'olahraga': []}; // Data ini yang kita pakai
  Map<String, bool> itemStatus = {};
  Map<String, String> alarmTimes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;
      Map<String, bool> savedChecklist = await RecommendationController.getChecklist();
      Map<String, String> savedAlarms = await RecommendationController.getAlarms();

      if (args != null) {
        // Jika baru selesai scan, data langsung ada
        setState(() {
          dataReal = args as Map<String, dynamic>;
          itemStatus = savedChecklist;
          alarmTimes = savedAlarms;
          isLoading = false;
        });
        await RecommendationController.saveToLocal(dataReal);
      } else {
        // JIKA DARI HOMEPAGE: Panggil Controller yang sudah terhubung ke ENDPOINT
        Map<String, dynamic>? data = await RecommendationController.getData(context);
        
        setState(() {
                if (data != null) dataReal = data;
                itemStatus = savedChecklist; // Load centang yang tersimpan
                isLoading = false;
              });
            }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Rekomendasi Pola Hidup", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          CategoryBar(
            categories: ["Makanan", "Olahraga", "Tidur"],
            selectedCategory: selectedCategory,
            onCategorySelected: (category) => setState(() => selectedCategory = category),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: (dataReal['makanan'] as List).isEmpty && (dataReal['olahraga'] as List).isEmpty
                ? const Center(child: Text("Data rekomendasi tidak tersedia"))
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: _buildContentList(dataReal),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContentList(Map<String, dynamic> data) {
    if (selectedCategory == "Makanan") {
      final List makanan = data['makanan'] ?? [];
      return List.generate(makanan.length, (index) {
        final item = makanan[index];
        final String id = "makanan_${item['nama']}_$index";
        return _buildActionCard(
          id,
          "${item['waktu']} (${item['jam']})",
          item['nama'] ?? "",
          "assets/images/sarapan.png",
          item['jam'].toString(), // KIRIM RENTANG LENGKAP (Misal: "18:00 - 20:00")
        );
      });
    }

    if (selectedCategory == "Olahraga") {
      final List olahraga = data['olahraga'] ?? [];
      return List.generate(olahraga.length, (index) {
        final item = olahraga[index];
        final String id = "olahraga_${item['gerakan']}_$index";
        return _buildActionCard(
          id,
          "${item['area']}: ${item['gerakan']}",
          "Durasi: ${item['durasi']}\nJam: ${item['jam']}",
          "assets/images/run_iklan.png",
          item['jam'].toString(), // KIRIM RENTANG LENGKAP
        );
      });
    }

    return [_buildActionCard("tidur_0", "Tidur Ideal", "7-8 Jam", "assets/images/run_iklan.png", "22:00")];
  }

  Widget _buildActionCard(String id, String title, String desc, String img, String recomRange) {
    bool isDone = itemStatus[id] ?? false;
    String? setTime = alarmTimes[id]; // Ambil jam yang sudah di-set

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Image.asset(img, width: 50),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(desc, style: const TextStyle(fontSize: 16)),
                  if (setTime != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        "🔔 Alarm: $setTime", 
                        style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                setTime != null ? Icons.alarm_on : Icons.alarm_add, // Icon berubah jika sudah set
                color: setTime != null ? Colors.green : Colors.blueAccent
              ),
              onPressed: () => _setAlarm(id, title, recomRange),
            ),
            Checkbox(
              value: isDone,
              onChanged: (val) async {
                setState(() => itemStatus[id] = val!);
                await RecommendationController.saveChecklist(itemStatus);
                ShowAlert(context, 
                  isDone ? "Belum dilakukan" : "Selesai dilakukan", 
                  isDone ? Colors.orange : Colors.green, 
                  2
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAlarm(String id, String title, String recomRange) async {
    if (alarmTimes.containsKey(id)) {
      bool? actionChoose = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Kelola Alarm"),
          content: Text("Alarm untuk $title sudah di-set pada jam ${alarmTimes[id]}. Apa yang ingin Anda lakukan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Berarti Hapus
              child: const Text("Hapus Alarm", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Berarti Ubah
              child: const Text("Ubah Jam"),
            ),
          ],
        ),
      );

      // Jika pilih hapus (Navigator pop false)
      if (actionChoose == false) {
        setState(() {
          alarmTimes.remove(id);
        });
        await RecommendationController.deleteAlarmTime(id);
        ShowAlert(context, 'Alarm berhasil dihapus!', Colors.red, 2);
        return; 
      }
      
      // Jika cancel dialog (klik luar)
      if (actionChoose == null) return;
    }

    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

    if (picked != null) {
      // 1. Konversi waktu yang dipilih ke total menit agar lebih akurat
      int pickedTotalMinutes = (picked.hour * 60) + picked.minute;

      try {
        if (recomRange.contains(' - ')) {
          List<String> range = recomRange.split(' - ');
          
          int getMinutes(String timeStr) {
            // Bersihkan string dari karakter selain angka dan titik dua
            String cleanStr = timeStr.replaceAll(RegExp(r'[^0-9:]'), '').trim();
            
            if (cleanStr.contains(':')) {
              List<String> parts = cleanStr.split(':');
              return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
            } else {
              // Jika hanya angka jam saja (misal "18")
              return int.parse(cleanStr) * 60;
            }
          }

          int startMinutes = getMinutes(range[0]);
          int endMinutes = getMinutes(range[1]);

          // 3. Bandingkan dalam satuan menit
          if (pickedTotalMinutes < startMinutes || pickedTotalMinutes > endMinutes) {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: const Text("Waktu Diluar Rekomendasi"),
              content: Text("Jam yang Anda pilih (${picked.format(context)}) berada diluar rentang rekomendasi (${recomRange}). Apakah Anda yakin ingin melanjutkan?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Batal", style: TextStyle(color: Colors.red)),
                ),
              ],
            )).then((proceed) async {
              if (proceed == true) {
                String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                setState(() => alarmTimes[id] = formattedTime);
                await RecommendationController.saveAlarmTime(id, formattedTime);
              }
            });
            return; // Hentikan eksekusi jika tidak lanjut
          }
        }
      } catch (e) {
        print("Error Validasi: $e");
      }

      // 4. Simpan jika valid (atau tetap simpan dengan peringatan)
      String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      setState(() => alarmTimes[id] = formattedTime);
      await RecommendationController.saveAlarmTime(id, formattedTime);
      ShowAlert(context, "Alarm berhasil diatur di pukul $formattedTime!", Colors.green, 2);
    }
  }
}