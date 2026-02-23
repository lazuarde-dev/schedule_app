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

  // Palette Warna Minimalist
  final Color bgColor = const Color(0xFFF8FAFC);
  final Color accentColor = const Color(0xFF4F46E5);
  final Color darkText = const Color(0xFF1E293B);

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

    String taskListString = tasks
        .map((t) => "- ${t.name} (${t.duration} menit) pada jam ${t.time}")
        .join("\n");

    final prompt =
        """
    Analisis jadwal ini untuk pengguna bernama Mahesa:
    1. [SUMMARY] Apakah jadwal ini realistis? Berikan penilaian singkat.
    2. [TIPS] Berikan tips produktivitas spesifik.
    3. [PRIORITY] Urutan prioritas jika terjadi hambatan.
    
    Daftar Tugas:
    $taskListString
    
    Format dalam Bahasa Indonesia yang profesional dan suportif.
    """;

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
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
        _generatedSchedule = "Koneksi terputus. Pastikan API Key aktif.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AI Insights",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading ? _buildLoadingState() : _buildResults(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: accentColor,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Menganalisis jadwalmu...",
            style: TextStyle(
              color: darkText,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            "Gemini sedang bekerja.",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 32),
          _buildContentCard(),
          const SizedBox(height: 40),
          _buildFinishButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: accentColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Mahesa, AI telah menyusun strategi terbaik untuk harimu.",
              style: TextStyle(
                color: darkText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: MarkdownBody(
        data: _generatedSchedule,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: darkText.withOpacity(0.8),
          ),
          h1: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 2.0,
          ),
          h2: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.8,
          ),
          listBullet: TextStyle(color: accentColor, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
          minimumSize: const Size(200, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Selesai",
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
