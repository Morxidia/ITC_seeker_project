// lib/models/itc_structure.dart
//
// Parses the JSON dynamically — no hardcoded keys except top-level
// "kingdom", "Sovereign", "division" which are the fixed schema roots.
// Within Sovereign and division, every sub-section and every member
// is discovered by inspecting the JSON map keys at runtime.

/// A single member inside a sub-section.
class Member {
  /// The JSON key used for this member (e.g. "king", "secretary", "medinfo-1")
  final String role;
  final String name;
  final String instagram;
  final String email;
  final String img;

  const Member({
    required this.role,
    required this.name,
    required this.instagram,
    required this.email,
    required this.img,
  });

  factory Member.fromJson(String role, Map<String, dynamic> json) => Member(
        role: role,
        name: json['name'] as String? ?? '',
        instagram: json['instagram'] as String? ?? '-',
        email: json['email'] as String? ?? '-',
        img: json['img'] as String? ?? '',
      );
}

/// A sub-section inside a group (e.g. "King", "administrator", "mobile").
/// Members are any JSON keys whose value has a "name" field.
class SubSection {
  final String title;
  final String img;
  final String description;
  final List<Member> members;

  const SubSection({
    required this.title,
    required this.img,
    required this.description,
    required this.members,
  });

  factory SubSection.fromJson(String title, Map<String, dynamic> json) {
    const reservedKeys = {'img', 'description'};

    final members = <Member>[];
    for (final entry in json.entries) {
      if (reservedKeys.contains(entry.key)) continue;
      if (entry.value is! Map<String, dynamic>) continue;
      final childMap = entry.value as Map<String, dynamic>;
      if (childMap.containsKey('name')) {
        members.add(Member.fromJson(entry.key, childMap));
      }
    }

    return SubSection(
      title: title,
      img: json['img'] as String? ?? '',
      description: json['description'] as String? ?? '',
      members: members,
    );
  }

  /// Ordered slides: cover image first, then one per member.
  List<_Slide> get slides => [
        _Slide(label: title, img: img),
        ...members.map((m) => _Slide(label: m.name, img: m.img)),
      ];
}

/// Lightweight slide descriptor used by the detail slideshow.
class _Slide {
  final String label;
  final String img;
  const _Slide({required this.label, required this.img});
}

// Re-export so pages don't need a separate import.
typedef Slide = _Slide;

/// A top-level group (e.g. "Sovereign", "Division").
/// Sub-sections are discovered from JSON keys whose values are Maps
/// containing an "img" key (marking them as displayable sections).
class Group {
  final String title;
  final List<SubSection> subSections;

  const Group({required this.title, required this.subSections});

  factory Group.fromJson(String title, Map<String, dynamic> json) {
    final subSections = <SubSection>[];
    for (final entry in json.entries) {
      if (entry.value is! Map<String, dynamic>) continue;
      final child = entry.value as Map<String, dynamic>;
      String newKey = entry.key;
      switch (newKey) {
      case 'ketua':
        newKey = "Tirani"; 
        break; 
      case 'administrator':
        newKey = "Administrator"; 
        break;
      case 'medinfo':
        newKey = "Media & Informasi"; 
        break; 
      case 'ai':
        newKey = "AI/ML"; 
        break; 
      case 'competitive_programming':
        newKey = "Competitive Programing"; 
        break;
      case 'web':
        newKey = "Web Dev"; 
        break; 
      case 'mobile':
        newKey = "Mobile"; 
        break;
      case 'project_management':
        newKey = "Project Management"; 
        break;
      case 'ui_ux':
        newKey = "UI/UX"; 
        break;
      }
      if (child.containsKey('img')) {
        subSections.add(SubSection.fromJson(newKey, child));
      }
    }
    return Group(title: title, subSections: subSections);
  }
}

/// Kingdom (the club itself).
class Kingdom {
  final String name;
  final String description;
  final String img;

  const Kingdom({
    required this.name,
    required this.description,
    required this.img,
  });

  factory Kingdom.fromJson(Map<String, dynamic> json) => Kingdom(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        img: json['img'] as String? ?? '',
      );
}

/// Root model — reads every top-level key except "kingdom" as a Group.
class ITCStructure {
  final Kingdom kingdom;
  final List<Group> groups;

  const ITCStructure({required this.kingdom, required this.groups});

  factory ITCStructure.fromJson(Map<String, dynamic> json) {
    final kingdom = Kingdom.fromJson(json['ITC'] as Map<String, dynamic>);

    final groups = <Group>[];
    for (final entry in json.entries) {
      if (entry.key == 'ITC') continue;
      if (entry.value is! Map<String, dynamic>) continue;
    
      groups.add(Group.fromJson(entry.key, entry.value as Map<String, dynamic>));
    }

    return ITCStructure(kingdom: kingdom, groups: groups);
  }
}
