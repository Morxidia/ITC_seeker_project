/// Represents the root kingdom/club info
class Kingdom {
  final String name;
  final String img;

  Kingdom({required this.name, required this.img});

  factory Kingdom.fromJson(Map<String, dynamic> json) => Kingdom(
        name: json['name'] as String,
        img: json['img'] as String,
      );
}

/// A single person/role entry inside a section
class Member {
  final String roleKey; // e.g. "king", "secretary"
  final String name;
  final String email;
  final String instagram;
  final String img;

  Member({required this.roleKey, required this.name, required this.email, required this.instagram, required this.img});

  factory Member.fromJson(String key, Map<String, dynamic> json) => Member(
        roleKey: key,
        name: json['name'] as String,
        email: json['email'] as String,
        instagram: json['instagram'] as String,
        img: json['img'] as String,
      );

  /// Human-readable role label
  String get roleLabel {
    switch (roleKey.toLowerCase()) {
      case 'king':
        return 'Ketua';
      case 'succession':
        return 'Wakil Ketua';
      case 'secretary':
        return 'Sekretaris';
      case 'treasury':
        return 'Bendahara';
      default:
        return roleKey[0].toUpperCase() + roleKey.substring(1);
    }
  }
}

/// One structural section (e.g. Monarh, Administrator)
class StructureSection {
  final String sectionKey; // JSON raw Key
  final String img;        // group/preview media path
  final List<Member> members;

  StructureSection({
    required this.sectionKey,
    required this.img,
    required this.members,
  });

  /// Friendly display title
  String get title {
    switch (sectionKey.toLowerCase()) {
      case 'monarh':
        return 'King';
      case 'administrator':
        return 'Administrator';
      default:
        return sectionKey[0].toUpperCase() + sectionKey.substring(1);
    }
  }

  /// All media in display order: group image first, then each member
  List<MediaItem> get allMedia {
    final items = <MediaItem>[
      MediaItem(path: img, caption: title, isGroupShot: true),
    ];
    for (final m in members) {
      items.add(MediaItem(path: m.img, caption: '${m.roleLabel}\n${m.name}\nInstagram:${m.instagram}\nEmail:${m.email}'));
    }
    return items;
  }
}

/// A single displayable media item (image or video)
class MediaItem {
  final String path;
  final String caption;
  final bool isGroupShot;

  MediaItem({required this.path, required this.caption, this.isGroupShot = false});
}

/// Root app data model — parsed entirely from JSON, nothing hardcoded
class ITCStructure {
  final Kingdom kingdom;
  final List<StructureSection> sections; // preserves JSON key order

  ITCStructure({required this.kingdom, required this.sections});

  factory ITCStructure.fromJson(Map<String, dynamic> json) {
    final kingdom = Kingdom.fromJson(json['kingdom'] as Map<String, dynamic>);
    final sections = <StructureSection>[];

    for (final entry in json.entries) {
      if (entry.key == 'kingdom') continue;

      final sectionData = entry.value as Map<String, dynamic>;
      final mainImg = sectionData['img'] as String;
      final members = <Member>[];

      for (final memberEntry in sectionData.entries) {
        if (memberEntry.key == 'img') continue;
        final memberMap = memberEntry.value as Map<String, dynamic>;
        members.add(Member.fromJson(memberEntry.key, memberMap));
      }

      sections.add(StructureSection(
        sectionKey: entry.key,
        img: mainImg,
        members: members,
      ));
    }

    return ITCStructure(kingdom: kingdom, sections: sections);
  }
}
