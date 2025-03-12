import 'dart:convert';
import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String title;
  String content;
  List<String> tags;
  DateTime createdAt;
  DateTime modifiedAt;
  List<String> images; // 存储图片路径

  Note({
    String? id,
    this.title = '',
    this.content = '',
    List<String>? tags,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? images,
  }) : 
    id = id ?? const Uuid().v4(),
    tags = tags ?? [],
    createdAt = createdAt ?? DateTime.now(),
    modifiedAt = modifiedAt ?? DateTime.now(),
    images = images ?? [];

  Note copyWith({
    String? title,
    String? content,
    List<String>? tags,
    DateTime? modifiedAt,
    List<String>? images,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      modifiedAt: modifiedAt ?? DateTime.now(),
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': jsonEncode(tags),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
      'images': jsonEncode(images),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(jsonDecode(map['tags'] ?? '[]')),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']),
      images: List<String>.from(jsonDecode(map['images'] ?? '[]')),
    );
  }
}