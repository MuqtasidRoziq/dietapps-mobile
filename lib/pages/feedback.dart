import 'package:diet_apps/components/snackbar.dart';
import 'package:diet_apps/controllers/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackUser extends StatefulWidget {
  const FeedbackUser({super.key});

  @override
  State<FeedbackUser> createState() => _FeedbackUserState();
}

class _FeedbackUserState extends State<FeedbackUser> {
  final TextEditingController _commentController = TextEditingController();
  
  // Memanggil Controller yang sudah dibuat sebelumnya
  final FeedbackController feedbackController = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Ulasan & Masukan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.rate_review_outlined, size: 60, color: Colors.blueAccent),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Beri Kami Masukan!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Rating dan saran Anda sangat membantu kami untuk menjadi lebih baik.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      const Text(
                        "Kualitas Layanan",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _commentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Ceritakan pengalaman Anda...",
                          filled: true,
                          fillColor: const Color(0xFFF3F6F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // TOMBOL SUBMIT (Diintegrasikan dengan Controller)
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                  onPressed: feedbackController.isLoading.value 
                    ? null 
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (_commentController.text.trim().isEmpty) {
                          ShowAlert(context, "Isi ulasan Anda", Colors.orange, 2);
                          return;
                        }

                        bool success = await feedbackController.sendFeedback(context, _commentController.text);

                        if (success) {
                          _commentController.clear();
                          await Future.delayed(const Duration(seconds: 2));
                          
                          if (mounted) {
                            Get.back();
                          }
                        }
                      },                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: feedbackController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("Kirim Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}