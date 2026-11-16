import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 주문 도중 접수 마감 안내 화면 (표시 전용, STEP 번호 없음)
///
/// 손님이 다 고르고 접수(POST /order)를 눌렀는데 그 사이 접수가 마감돼
/// 서버가 503 으로 거절한 경우에만 뜹니다. 주문은 만들어지지 않았습니다.
/// [seconds]초 동안 보여준 뒤 main.dart 의 타이머가 첫 화면으로 돌려보내고,
/// 이 화면은 남은 시간만 1초마다 줄여서 보여줍니다(화면이 멈춘 것처럼
/// 보이지 않게 하려는 표시용이며, 실제 전환은 main.dart 가 합니다).
class LineClosedScreen extends StatefulWidget {
  final int seconds;

  const LineClosedScreen({super.key, this.seconds = 20});

  @override
  State<LineClosedScreen> createState() => _LineClosedScreenState();
}

class _LineClosedScreenState extends State<LineClosedScreen> {
  late int _remaining = widget.seconds;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      // 0 아래로는 내려가지 않게 1에서 멈춥니다(전환 직전에 "0초"가 보이지 않게).
      if (_remaining > 1) setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '주문 도중 접수가 마감되었습니다',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 60),
        const Text(
          '관리자를 찾아오시면\n스페셜 키캡을 제공해드립니다',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.4,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 52),
        Text(
          '$_remaining초 뒤 처음 화면으로 돌아갑니다',
          style: AppTextStyles.body.copyWith(fontSize: 28),
        ),
      ],
    );
  }
}
