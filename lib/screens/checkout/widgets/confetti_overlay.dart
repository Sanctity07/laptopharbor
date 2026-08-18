import 'dart:math';
import 'package:flutter/material.dart';

class _ConfettiPiece {
  double x;
  double y;
  final double size;
  final Color color;
  final double speed;
  double rotation;
  final double rotationSpeed;

  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });
}

/// Lightweight falling-confetti effect matching the Stitch canvas
/// micro-interaction. Pieces recycle to the top once off-screen.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  final List<_ConfettiPiece> _pieces = [];

  static const _colors = [
    Color(0xFF00685F),
    Color(0xFF007DA9),
    Color(0xFF7BD0FF),
    Color(0xFF6BD8CB),
    Color(0xFF0D9488),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..addListener(_tick)
      ..repeat();
  }

  _ConfettiPiece _createPiece(Size size) {
    return _ConfettiPiece(
      x: _random.nextDouble() * size.width,
      y: -20 - _random.nextDouble() * 200,
      size: _random.nextDouble() * 8 + 4,
      color: _colors[_random.nextInt(_colors.length)],
      speed: _random.nextDouble() * 2 + 1.5,
      rotation: _random.nextDouble() * 360,
      rotationSpeed: _random.nextDouble() * 6 - 3,
    );
  }

  void _tick() {
    if (!mounted) return;
    final size = MediaQuery.of(context).size;
    if (_pieces.isEmpty) {
      for (int i = 0; i < 50; i++) {
        _pieces.add(_createPiece(size));
      }
    }
    setState(() {
      for (int i = 0; i < _pieces.length; i++) {
        final p = _pieces[i];
        p.y += p.speed;
        p.rotation += p.rotationSpeed;
        if (p.y > size.height) {
          _pieces[i] = _createPiece(size);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConfettiPainter(_pieces),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;

  _ConfettiPainter(this.pieces);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation * pi / 180);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}