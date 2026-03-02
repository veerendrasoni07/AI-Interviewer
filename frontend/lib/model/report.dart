// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Report {
  final String id;
  final String techstack;
  final int accuracy;
  final String fluency;
  final String communication;
  final List<String> weakareas;
  final List<String> strongareas;
  final List<String> improvement;
  final List<String> tips;

  Report({
    required this.id,
    required this.techstack,
    required this.accuracy,
    required this.fluency,
    required this.communication,
    required this.weakareas,
    required this.strongareas,
    required this.improvement,
    required this.tips,
  });

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value == null) {
      return <String>[];
    }
    return <String>[value.toString()];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'techstack': techstack,
      'accuracy': accuracy,
      'fluency': fluency,
      'communication': communication,
      'weakareas': weakareas,
      'strongareas': strongareas,
      'improvement': improvement,
      'tips': tips,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      techstack:
          (map['techstack'] ?? map['techStack'] ?? map['tech_stack'] ?? '')
              .toString(),
      accuracy:
          (map['accuracy'] is num) ? (map['accuracy'] as num).toInt() : 0,
      fluency: (map['fluency'] ?? '').toString(),
      communication: map['communication'] ?? "",
      weakareas: _toStringList(map['weakareas'] ?? map['weakAreas'] ?? map['weak_areas']),
      strongareas:
          _toStringList(map['strongareas'] ?? map['strongAreas'] ?? map['strong_areas']),
      improvement:
          _toStringList(map['improvement'] ?? map['improvements']),
      tips: _toStringList(map['tips']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);
}
