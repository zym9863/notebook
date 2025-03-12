import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/providers/note_provider.dart';
import 'package:notebook/screens/note_edit_screen.dart';
import 'package:notebook/widgets/paper_card.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // 初始化时加载笔记
    Future.microtask(() {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '搜索笔记...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  Provider.of<NoteProvider>(context, listen: false)
                      .setSearchQuery(value);
                },
              )
            : const Text('我的笔记'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  Provider.of<NoteProvider>(context, listen: false)
                      .clearSearchQuery();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 标签筛选区域
          _buildTagsFilter(),
          // 笔记列表
          Expanded(
            child: _buildNoteGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTagsFilter() {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final allTags = noteProvider.allTags;
        final selectedTag = noteProvider.selectedTag;

        if (allTags.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allTags.length + 1, // +1 for 'All' option
            itemBuilder: (context, index) {
              if (index == 0) {
                // 'All' option
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: FilterChip(
                    label: const Text('全部'),
                    selected: selectedTag.isEmpty,
                    onSelected: (selected) {
                      if (selected) {
                        noteProvider.clearSelectedTag();
                      }
                    },
                  ),
                );
              }

              final tag = allTags[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: FilterChip(
                  label: Text(tag),
                  selected: tag == selectedTag,
                  onSelected: (selected) {
                    if (selected) {
                      noteProvider.setSelectedTag(tag);
                    } else if (tag == selectedTag) {
                      noteProvider.clearSelectedTag();
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteGrid() {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final notes = noteProvider.notes;

        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/notebook_image.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 24),
                const Text('没有笔记，点击右下角按钮创建新笔记'),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return _buildNoteCard(notes[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = dateFormat.format(note.modifiedAt);

    return PaperCard(
      elevation: 2.5,
      padding: const EdgeInsets.all(16.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEditScreen(note: note),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 标题
              Expanded(
                child: Text(
                  note.title.isEmpty ? '无标题' : note.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 删除按钮
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  // 显示确认对话框
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('确认删除'),
                      content: const Text('确定要删除这条笔记吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            // 删除笔记
                            Provider.of<NoteProvider>(context, listen: false)
                                .deleteNote(note.id);
                            Navigator.pop(context);
                          },
                          child: const Text('删除'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 内容预览
          Text(
            note.content,
            style: const TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // 标签
          if (note.tags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: note.tags.map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 11),
                  ),
                  padding: const EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          const SizedBox(height: 12),
          // 修改时间
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}