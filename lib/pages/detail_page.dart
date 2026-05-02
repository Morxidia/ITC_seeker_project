// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import '../models/itc_structure.dart';
import '../theme.dart';
import '../widgets/asset_image_view.dart';

class DetailPage extends StatefulWidget {
  final SubSection subSection;

  const DetailPage({super.key, required this.subSection});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageCtrl = PageController();
  int _current = 0;

  List<Slide> get _slides => widget.subSection.slides;

  void _goTo(int i) => _pageCtrl.animateToPage(i,
      duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    final total = slides.length;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kTextPri),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.subSection.title,
            style: const TextStyle(
                color: kTextPri, fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_current + 1} / $total',
                  style: const TextStyle(color: kTextMuted, fontSize: 13)),
            ),
          ),
        ],
      ),

      body: Column(children: [
        // ── Slide label / sub-title ─────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Padding(
            key: ValueKey(_current),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(slides[_current].label,
                style: const TextStyle(color: kTextSec, fontSize: 13,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
        ),

        // ── Image PageView ──────────────────────────────────────────
        Expanded(
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: total,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AssetImageView(
                    path: slides[i].img,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),

        // ── Dot indicators ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (i) {
              final active = i == _current;
              return GestureDetector(
                onTap: () => _goTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? kAccent : kBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),

        // ── Member info card (shown for slides 1…n, not the cover) ──
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _current > 0 && _current <= widget.subSection.members.length
              ? _MemberCard(
                  key: ValueKey(_current),
                  member: widget.subSection.members[_current - 1],
                )
              : _CoverCard(
                  key: const ValueKey('cover'),
                  subSection: widget.subSection,
                ),
        ),

        // ── Prev / Next ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Row(children: [
            Expanded(
              child: AnimatedOpacity(
                opacity: _current > 0 ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: OutlinedButton.icon(
                  onPressed: _current > 0 ? () => _goTo(_current - 1) : null,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 13),
                  label: const Text('Prev'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextPri,
                    side: const BorderSide(color: kBorder),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedOpacity(
                opacity: _current < total - 1 ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed:
                      _current < total - 1 ? () => _goTo(_current + 1) : null,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: kTextPri,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: kAccent.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Cover info card (slide 0) ─────────────────────────────────────────────────
class _CoverCard extends StatelessWidget {
  final SubSection subSection;
  const _CoverCard({super.key, required this.subSection});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(children: [
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            subSection.description.isNotEmpty
                ? subSection.description
                : 'Geser untuk melihat anggota →',
            style: const TextStyle(color: kTextSec, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }
}

// ── Member info card (slides 1…n) ─────────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final Member member;
  const _MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(member.name,
                style: const TextStyle(
                    color: kTextPri, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(member.role,
                style: const TextStyle(color: kAccentSoft, fontSize: 14)),
            Text('email : ${member.email}',
                style: const TextStyle(color: kTextPri, fontSize: 16, fontWeight: FontWeight.w500)),
            Text('Instagram : ${member.instagram}',
                style: const TextStyle(color: kTextPri, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 7),
          ]),
        ),

        const SizedBox(width: 8),

      ]),
    );
  }
}
