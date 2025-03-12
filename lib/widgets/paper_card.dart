import 'package:flutter/material.dart';
import 'package:notebook/theme/app_theme.dart';

/// 纸张质感卡片组件
/// 实现纸张肌理叠层效果，模拟再生纸触感
class PaperCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const PaperCard({
    super.key,
    required this.child,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDarkMode ? AppTheme.starTrailBlue.withOpacity(0.8) : AppTheme.parchmentYellow);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            boxShadow: elevation > 0 ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              ),
            ] : null,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}