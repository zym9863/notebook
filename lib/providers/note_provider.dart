import 'package:flutter/foundation.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/services/database_service.dart';

class NoteProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Note> _notes = [];
  List<String> _allTags = [];
  String _selectedTag = '';
  String _searchQuery = '';

  List<Note> get notes => _notes;
  List<String> get allTags => _allTags;
  String get selectedTag => _selectedTag;
  String get searchQuery => _searchQuery;

  // 初始化，加载所有笔记
  Future<void> loadNotes() async {
    if (_selectedTag.isNotEmpty) {
      _notes = await _databaseService.getNotesByTag(_selectedTag);
    } else if (_searchQuery.isNotEmpty) {
      _notes = await _databaseService.searchNotes(_searchQuery);
    } else {
      _notes = await _databaseService.getNotes();
    }
    _updateAllTags();
    notifyListeners();
  }

  // 添加新笔记
  Future<Note> addNote(Note note) async {
    await _databaseService.insertNote(note);
    await loadNotes();
    return note;
  }

  // 更新笔记
  Future<void> updateNote(Note note) async {
    await _databaseService.updateNote(note);
    await loadNotes();
  }

  // 删除笔记
  Future<void> deleteNote(String id) async {
    await _databaseService.deleteNote(id);
    await loadNotes();
  }

  // 根据ID获取笔记
  Future<Note?> getNoteById(String id) async {
    return await _databaseService.getNoteById(id);
  }

  // 设置选中的标签
  void setSelectedTag(String tag) {
    _selectedTag = tag;
    _searchQuery = '';
    loadNotes();
  }

  // 清除选中的标签
  void clearSelectedTag() {
    _selectedTag = '';
    loadNotes();
  }

  // 设置搜索查询
  void setSearchQuery(String query) {
    _searchQuery = query;
    _selectedTag = '';
    loadNotes();
  }

  // 清除搜索查询
  void clearSearchQuery() {
    _searchQuery = '';
    loadNotes();
  }

  // 更新所有标签列表
  void _updateAllTags() {
    Set<String> tagsSet = {};
    for (var note in _notes) {
      tagsSet.addAll(note.tags);
    }
    _allTags = tagsSet.toList();
  }
}