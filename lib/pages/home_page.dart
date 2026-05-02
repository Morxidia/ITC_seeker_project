import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/itc_structure.dart';
import '../utils/asset_helper.dart';
import 'structure_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ITCStructure? _structure;
  bool _loading = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _loadStructure();
  }

  Future<void> _loadStructure() async {
    // Reads JSON from assets — no hardcoded data
    final raw = await rootBundle.loadString('assets/structure.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    setState(() {
      _structure = ITCStructure.fromJson(map);
      _loading = false;
    });
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1829),
      body: _loading ? _buildLoader() : _buildContent(),
    );
  }

  Widget _buildLoader() => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4FC3F7)),
      );

  Widget _buildContent() {
    final kingdom = _structure!.kingdom;

    return Stack(
      children: [
        // Decorative gradient blobs
        Positioned(
          top: -80,
          left: -60,
          child: _gradientBlob(220, const Color(0xFF1565C0)),
        ),
        Positioned(
          bottom: -60,
          right: -40,
          child: _gradientBlob(180, const Color(0xFF0D47A1)),
        ),

        SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo ──────────────────────────────────────────
                  _LogoRing(imagePath: kingdom.img),

                  const SizedBox(height: 32),

                  // ── Club name ─────────────────────────────────────
                  Text(
                    kingdom.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Information Technology Club',
                    style: TextStyle(
                      color: Color(0xFF90CAF9),
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── CTA Button ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _StructureButton(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, anim, __) =>
                              StructurePage(structure: _structure!),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradientBlob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.18),
        ),
      );
}

// ─── Logo Ring ─────────────────────────────────────────────────────────────

class _LogoRing extends StatelessWidget {
  final String imagePath;
  const _LogoRing({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: Image.asset(
          toAssetPath(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1A3A5C),
            child: const Icon(Icons.image_not_supported_rounded,
                color: Colors.white38, size: 64),
          ),
        ),
      ),
    );
  }
}

// ─── Structure Button ──────────────────────────────────────────────────────

class _StructureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StructureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E88E5).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_tree_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Lihat Struktur ITC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
