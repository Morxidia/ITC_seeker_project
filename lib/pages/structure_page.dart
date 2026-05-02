// lib/pages/structure_page.dart
import 'package:flutter/material.dart';
import '../models/itc_structure.dart';
import '../theme.dart';
import '../widgets/asset_image_view.dart';
import 'detail_page.dart';

class StructurePage extends StatelessWidget {
  final ITCStructure structure;

  const StructurePage({super.key, required this.structure});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kTextPri),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Struktur Organisasi',
            style: TextStyle(color: kTextPri, fontWeight: FontWeight.w700, fontSize: 18)),
      ),

      // ── One group section per top-level key (Sovereign, division, …) ──
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 32),
        itemCount: structure.groups.length,
        itemBuilder: (context, gi) {
          final group = structure.groups[gi];
          return _GroupSection(group: group);
        },
      ),
    );
  }
}

// Group section Pengurus and Divisions
class _GroupSection extends StatelessWidget {
  final Group group;
  const _GroupSection({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Group title
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(children: [
          Container(
            width: 4, height: 20,
            decoration: BoxDecoration(
              color: kAccent, borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(group.title,
              style: const TextStyle(
                color: kTextPri, fontSize: 17, fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              )),
          const SizedBox(width: 10),
          Text('${group.subSections.length} divisi',
              style: const TextStyle(color: kTextMuted, fontSize: 12)),
        ]),
      ),

      // Horizontal sub-section cards — each is a preview and tappable
      SizedBox(
        height: 380,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: group.subSections.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, si) {
            final sub = group.subSections[si];
            return _SubSectionCard(
              subSection: sub,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => DetailPage(subSection: sub))),
            );
          },
        ),
      ),
    ]);
  }
}

// ── Sub-section preview card ──────────────────────────────────────────────────
class _SubSectionCard extends StatelessWidget {
  final SubSection subSection;
  final VoidCallback onTap;

  const _SubSectionCard({required this.subSection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: kAccent.withOpacity(0.08),
              blurRadius: 16, offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Cover image — path from JSON
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(children: [
              Center(child: AssetImageView(path: subSection.img, height: 200, fit: BoxFit.cover)),
              // Slide count badge
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.photo_library_rounded, size: 11, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${subSection.slides.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ]),
                ),
              ),
            ]),
          ),

          // Info area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Sub-section title from JSON key
                Text(subSection.title,
                    style: const TextStyle(
                      color: kTextPri, fontSize: 15, fontWeight: FontWeight.w700,
                    )),

                if (subSection.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(subSection.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: kTextMuted, fontSize: 11)),
                ],

                const SizedBox(height: 8),
                const Divider(color: kBorder, height: 1),
                const SizedBox(height: 8),

                // Members — dynamically rendered, names from JSON
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: subSection.members.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kTextPri, fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(m.role,
                                  style: const TextStyle(
                                    color: kAccentSoft, fontSize: 10,
                                  )),
                            ],
                          ),
                        ),
                      ]),
                    )).toList(),
                  ),
                ),

                // Tap hint
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Tap untuk detail →',
                      style: TextStyle(color: kAccent.withOpacity(0.7), fontSize: 10)),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
