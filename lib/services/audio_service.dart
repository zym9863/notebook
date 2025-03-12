import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  // 单例模式
  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // 预加载写作音效
      await _audioPlayer.setAsset('assets/writing_sound.mp3');
      _isInitialized = true;
    } catch (e) {
      debugPrint('音频初始化失败: $e');
    }
  }

  // 播放写作音效
  Future<void> playWritingSound() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      // 如果正在播放，先停止
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }
      
      // 从头开始播放
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('播放音效失败: $e');
    }
  }

  // 释放资源
  void dispose() {
    _audioPlayer.dispose();
  }
}