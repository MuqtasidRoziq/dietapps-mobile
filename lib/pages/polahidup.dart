import 'package:diet_apps/components/snackbar.dart';
import 'package:diet_apps/controllers/recommendation_controller.dart';
import 'package:diet_apps/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/components/category_button.dart';

class RePolahidup extends StatefulWidget {
  const RePolahidup({super.key});

  @override
  State<RePolahidup> createState() => _RePolahidupState();
}

class _RePolahidupState extends State<RePolahidup> {
  String selectedCategory = "Makanan";
  Map<String, dynamic> dataReal = {'makanan': [], 'olahraga': []}; 
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
        setState(() {
          dataReal = args as Map<String, dynamic>;
          itemStatus = savedChecklist;
          alarmTimes = savedAlarms;
          isLoading = false;
        });
        await RecommendationController.saveToLocal(dataReal);
      } else {
        Map<String, dynamic>? data = await RecommendationController.getData(context);
        
        setState(() {
          if (data != null) dataReal = data;
          itemStatus = savedChecklist;
          alarmTimes = savedAlarms;
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
            categories: ["Makanan", "Olahraga"],
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
          item['jam'].toString(),
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
          item['jam'].toString(),
        );
      });
    }

    return [_buildActionCard("tidur_0", "Tidur Ideal", "7-8 Jam", "assets/images/run_iklan.png", "22:00")];
  }

  Widget _buildActionCard(String id, String title, String desc, String img, String recomRange) {
    bool isDone = itemStatus[id] ?? false;
    String? setTime = alarmTimes[id];

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
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.alarm, size: 12, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "Alarm: $setTime",
                            style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500)
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            IconButton(
              icon: Icon(
                setTime != null ? Icons.alarm_on_rounded : Icons.alarm_add_rounded,
                color: setTime != null ? Colors.green : Colors.blueAccent,
                size: 28,
              ),
              onPressed: () => _setAlarm(id, title, recomRange),
            ),
            
            Checkbox(
              value: isDone,
              onChanged: (val) async {
                setState(() => itemStatus[id] = val!);
                await RecommendationController.saveChecklist(itemStatus);
                
                if (val == true) {
                  int reminderId = ("AUTO_REMINDER_$id").hashCode.abs();
                  await NotifService.cancelNotification(reminderId);
                }
                
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
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Hapus Alarm", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ubah Jam"),
            ),
          ],
        ),
      );

      if (actionChoose == false) {
        setState(() {
          alarmTimes.remove(id);
        });
        await RecommendationController.deleteAlarmTime(id);
        ShowAlert(context, 'Alarm & Notifikasi dihapus!', Colors.red, 2);
        return; 
      }
      if (actionChoose == null) return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      int pickedTotalMinutes = (picked.hour * 60) + picked.minute;
      String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

      bool isOutOfRange = false;
      if (recomRange.contains(' - ')) {
        List<String> range = recomRange.split(' - ');
        
        int getMinutes(String timeStr) {
          String cleanStr = timeStr.replaceAll(RegExp(r'[^0-9:]'), '').trim();
          if (cleanStr.contains(':')) {
            List<String> parts = cleanStr.split(':');
            return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
          }
          return int.parse(cleanStr) * 60;
        }

        int startMinutes = getMinutes(range[0]);
        int endMinutes = getMinutes(range[1]);

        if (pickedTotalMinutes < startMinutes || pickedTotalMinutes > endMinutes) {
          isOutOfRange = true;
        }
      }

      if (isOutOfRange) {
        bool? proceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Waktu Diluar Rekomendasi"),
            content: Text("Jam ${picked.format(context)} berada diluar rentang $recomRange. Lanjutkan?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Ya, Set Alarm")),
            ],
          ),
        );

        if (proceed != true) return;
      }

      setState(() => alarmTimes[id] = formattedTime);
      
      await RecommendationController.saveAlarmTime(id, title, formattedTime);
      
      ShowAlert(context, "Alarm & Notifikasi berhasil diatur!", Colors.green, 2);
    }
  }
}