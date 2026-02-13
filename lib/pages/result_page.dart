import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/storage_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;
  String _generatedSchedule = "";
  final String _apiKey = "AIzaSyB0UGBFvuM22_CKyfwXq994iOAwu8is3uw"; 

  @override
  void initState() {
    super.initState();
    _generateAI();
  }

  Future<void> _generateAI() async {
    final tasks = await StorageService.getTasks();
    
    if (tasks.isEmpty) {
      setState(() {
        _generatedSchedule = "Belum ada tugas untuk dianalisis.";
        _isLoading = false;
      });
      return;
    }

    String taskListString = tasks.map((t) => "- ${t.name} (${t.duration} menit) pada jam ${t.time}").join("\n");
    
    final prompt = """
    Analisis jadwal berikut dalam 3 bagian terpisah:
    1. [SUMMARY] Analisis singkat apakah jadwal ini realistis.
    2. [TIPS] Tips produktivitas spesifik untuk aktivitas tersebut.
    3. [PRIORITY] Urutan prioritas jika ada waktu yang bentrok.
    
    Daftar Tugas:
    $taskListString
    
    Gunakan format bahasa Indonesia yang profesional.
    """;

    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _generatedSchedule = response.text ?? "Gagal mendapatkan respon.";
        _isLoading = false;
      });
      
      if (response.text != null) {
        await StorageService.saveSummary(response.text!);
      }
    } catch (e) {
      setState(() {
        _generatedSchedule = "Terjadi kesalahan koneksi atau API Key: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? _buildLoadingState(colorScheme)
          : _buildResults(colorScheme),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 25),
          Text(
            "Gemini sedang meramu jadwalmu...",
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildInfoCard(
            colorScheme,
            title: "Smart Insights",
            icon: Icons.auto_awesome_rounded,
            color: colorScheme.primary,
            child: Text(
              "Hasil analisis AI berdasarkan aktivitas yang kamu masukkan hari ini.",
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Result Content Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: MarkdownBody(
              data: _generatedSchedule,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                h1: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                listBullet: TextStyle(color: colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Action Button
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali ke Beranda"),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme, 
      {required String title, required IconData icon, required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}