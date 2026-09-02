import 'package:flutter/material.dart';

class JubuLogo extends StatelessWidget {
  final double fontSize;
  final bool isDark;

  const JubuLogo({
    super.key,
    this.fontSize = 28,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 주방 & 요리 아이콘 (냄비/불꽃 느낌)
        Container(
          padding: EdgeInsets.all(fontSize * 0.2),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B4A).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(fontSize * 0.35),
          ),
          child: Icon(
            Icons.restaurant_rounded,
            color: const Color(0xFFFF6B4A),
            size: fontSize * 0.85,
          ),
        ),
        SizedBox(width: fontSize * 0.3),
        // 브랜드 네이밍 텍스트
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'JU',
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  fontWeight: FontWeight.w900,
                  fontSize: fontSize,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF2D2B2A),
                ),
              ),
              TextSpan(
                text: 'BU',
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  fontWeight: FontWeight.w900,
                  fontSize: fontSize,
                  letterSpacing: -0.5,
                  color: const Color(0xFFFF6B4A), // 메인 포인트 오렌지
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}