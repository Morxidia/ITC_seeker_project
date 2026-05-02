// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/itc_structure.dart';
import '../services/json_loader.dart';
import '../theme.dart';
import '../widgets/asset_image_view.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'structure_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ITCStructure? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await JsonLoader.loadStructure();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : _error != null
              ? _errorView()
              : _body(),
    );
  }

  Widget _errorView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 52),
        const SizedBox(height: 16),
        Text('Gagal memuat data\n\n$_error',
            style: const TextStyle(color: kTextSec), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () { setState(() { _loading = true; _error = null; }); _load(); },
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Coba Lagi'),
          style: ElevatedButton.styleFrom(backgroundColor: kAccent, foregroundColor: kTextPri),
        ),
      ]),
    ),
  );

  Widget _body() {
    final d = _data!;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(children: [
        // ── Header bar ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: kAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.people_alt_rounded, color: kAccent, size: 20),
            ),
            const SizedBox(width: 12),
            // Name from JSON
            Text(d.kingdom.name,
                style: const TextStyle(
                  color: kTextPri, fontSize: 20, fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                )),
          ]),
        ),

        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: kBorder),
        ),

        // ── Kingdom hero image ──────────────────────────────────────
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Image Container
              Container(
                width: 180, // Adjust size as needed
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2), // Optional border
                  image: DecorationImage(
                    image: AssetImage(d.kingdom.img), //[cite: 1]
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // Text Information below the circle
              Text(
                d.kingdom.name, //[cite: 1]
                style: const TextStyle(
                  color: kTextPri,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              
              Text(
                d.kingdom.description == "" ? lorem(paragraphs: 2, words: 100): d.kingdom.description,
                style: const TextStyle(
                  color: kTextPri,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (d.kingdom.description.isNotEmpty) ...[ //[cite: 1]
                const SizedBox(height: 6),
                Text(
                  d.kingdom.description, //[cite: 1]
                  style: const TextStyle(color: kTextSec, fontSize: 13),
                ),
              ],
            ],
          ),
        ),

        // ── CTA ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => StructurePage(structure: d))),
              icon: const Icon(Icons.account_tree_rounded, size: 20),
              label: const Text('Lihat Struktur ITC',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: kAccent,
                foregroundColor: kTextPri,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 6,
                shadowColor: kAccent.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
