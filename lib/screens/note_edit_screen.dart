import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/providers/note_provider.dart';
import 'package:notebook/services/audio_service.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note; // 如果是编辑现有笔记，则传入笔记对象

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  bool _isLoading = false;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAudio();
    _setupTextControllerListeners();
  }

  void _initializeAudio() async {
    await _audioService.initialize();
  }

  void _setupTextControllerListeners() {
    // 为内容编辑器添加监听，在用户输入时播放音效
    _contentController.addListener(_onTextChanged);
  }

  DateTime _lastPlayTime = DateTime.now();
  String _lastText = '';

  void _onTextChanged() {
    // 获取当前文本
    final currentText = _contentController.text;
    
    // 如果文本有变化且距离上次播放至少过了500毫秒，播放音效
    if (currentText != _lastText && 
        DateTime.now().difference(_lastPlayTime).inMilliseconds > 500) {
      _audioService.playWritingSound();
      _lastPlayTime = DateTime.now();
      _lastText = currentText;
    }
  }

  void _initializeControllers() {
    // 如果是编辑现有笔记，则填充数据
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _tags = List.from(widget.note!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.removeListener(_onTextChanged);
    _contentController.dispose();
    _titleFocusNode.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final contentString = _contentController.text;

      // 播放保存音效
      _audioService.playWritingSound();

      if (widget.note == null) {
        // 创建新笔记
        final newNote = Note(
          title: _titleController.text,
          content: contentString,
          tags: _tags,
        );
        await noteProvider.addNote(newNote);
      } else {
        // 更新现有笔记
        final updatedNote = widget.note!.copyWith(
          title: _titleController.text,
          content: contentString,
          tags: _tags,
          modifiedAt: DateTime.now(),
        );
        await noteProvider.updateNote(updatedNote);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // 显示错误信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存笔记时出错: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? '新建笔记' : '编辑笔记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题输入
                    TextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      decoration: const InputDecoration(
                        hintText: '标题',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 标签输入和显示
                    const Text(
                      '标签:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                      )).toList(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: '添加标签',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTag,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 内容编辑器
                    const Text(
                      '内容:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: '输入笔记内容...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}