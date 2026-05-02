// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/itc_structure.dart';
import '../services/json_loader.dart';
import '../theme.dart';
import '../widgets/asset_image_view.dart';
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(fit: StackFit.expand, children: [
                // Image from JSON path — no hardcoding
                AssetImageView(path: d.kingdom.img, fit: BoxFit.cover),

                // Gradient overlay at the bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, kBg.withOpacity(0.92)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(d.kingdom.name,
                            style: const TextStyle(
                              color: kTextPri, fontSize: 24,
                              fontWeight: FontWeight.w900, letterSpacing: 0.5,
                            )),
                        if (d.kingdom.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(d.kingdom.description,
                              style: const TextStyle(color: kTextSec, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                ),
              ]),
            ),
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
