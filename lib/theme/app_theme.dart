import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// 应用主题配置
/// 基于云端图书馆的数字化延伸风格设计
class AppTheme {
  // 防止实例化
  AppTheme._();

  // 颜色常量
  static const Color morningFogWhite = Color(0xFFF8F9FA); // 晨雾白（背景层）
  static const Color parchmentYellow = Color(0xFFF4ECD6); // 羊皮纸黄（内容容器）
  static const Color deepSeaBlue = Color(0xFF2D4059); // 深海蓝（重点按钮/标题）
  static const Color mossGreen = Color(0xFF7D8F69); // 苔藓绿（完成状态/勾选）
  static const Color volcanoRed = Color(0xFFE84545); // 火山红（紧急标注）
  static const Color starTrailBlue = Color(0xFF1A233D); // 星轨蓝（暗夜模式基底）

  // 获取标签颜色（根据标签名动态生成）
  static Color getTagColor(String tag) {
    // 使用标签名的哈希值生成基础色相
    final int hash = tag.hashCode;
    final double hue = (hash % 360).abs().toDouble();
    
    // 使用HSL色彩模型，固定饱和度和亮度
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.65).toColor();
  }

  // 获取亮色主题
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: deepSeaBlue,
      scaffoldBackgroundColor: morningFogWhite,
      colorScheme: ColorScheme.light(
        primary: deepSeaBlue,
        secondary: mossGreen,
        error: volcanoRed,
        background: morningFogWhite,
        surface: parchmentYellow,
      ),
      // 卡片主题
      cardTheme: CardTheme(
        color: parchmentYellow,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // 应用栏主题
      appBarTheme: AppBarTheme(
        backgroundColor: morningFogWhite,
        foregroundColor: deepSeaBlue,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepSeaBlue,
        ),
      ),
      // 文本主题
      textTheme: TextTheme(
        // 标题样式
        headlineLarge: GoogleFonts.ibmPlexSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: deepSeaBlue,
          height: 1.75,
        ),
        headlineMedium: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: deepSeaBlue,
          height: 1.75,
        ),
        // 正文样式
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          color: deepSeaBlue,
          height: 1.75,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          color: deepSeaBlue,
          height: 1.75,
        ),
        // 代码块样式
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: deepSeaBlue.withOpacity(0.8),
          height: 1.75,
        ),
      ),
      // 输入框装饰主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: morningFogWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepSeaBlue.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepSeaBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepSeaBlue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepSeaBlue,
          foregroundColor: morningFogWhite,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // 芯片主题
      chipTheme: ChipThemeData(
        backgroundColor: parchmentYellow,
        selectedColor: mossGreen.withOpacity(0.2),
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          color: deepSeaBlue,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: deepSeaBlue.withOpacity(0.2)),
        ),
      ),
      // 图标主题
      iconTheme: IconThemeData(
        color: deepSeaBlue,
        size: 24,
      ),
      // 浮动按钮主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: deepSeaBlue,
        foregroundColor: morningFogWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // 获取暗色主题
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: morningFogWhite,
      scaffoldBackgroundColor: starTrailBlue,
      colorScheme: ColorScheme.dark(
        primary: morningFogWhite,
        secondary: mossGreen,
        error: volcanoRed,
        background: starTrailBlue,
        surface: starTrailBlue.withOpacity(0.8),
      ),
      // 卡片主题
      cardTheme: CardTheme(
        color: starTrailBlue.withOpacity(0.8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // 应用栏主题
      appBarTheme: AppBarTheme(
        backgroundColor: starTrailBlue,
        foregroundColor: morningFogWhite,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: morningFogWhite,
        ),
      ),
      // 文本主题
      textTheme: TextTheme(
        // 标题样式
        headlineLarge: GoogleFonts.ibmPlexSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: morningFogWhite,
          height: 1.75,
        ),
        headlineMedium: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: morningFogWhite,
          height: 1.75,
        ),
        // 正文样式
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          color: morningFogWhite.withOpacity(0.9),
          height: 1.75,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          color: morningFogWhite.withOpacity(0.9),
          height: 1.75,
        ),
        // 代码块样式
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: morningFogWhite.withOpacity(0.8),
          height: 1.75,
        ),
      ),
      // 输入框装饰主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: starTrailBlue.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: morningFogWhite.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: morningFogWhite.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: morningFogWhite),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: morningFogWhite,
          foregroundColor: starTrailBlue,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // 芯片主题
      chipTheme: ChipThemeData(
        backgroundColor: starTrailBlue.withOpacity(0.5),
        selectedColor: mossGreen.withOpacity(0.3),
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          color: morningFogWhite,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: morningFogWhite.withOpacity(0.2)),
        ),
      ),
      // 图标主题
      iconTheme: IconThemeData(
        color: morningFogWhite,
        size: 24,
      ),
      // 浮动按钮主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: morningFogWhite,
        foregroundColor: starTrailBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}