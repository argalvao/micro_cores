// pixel_art_painter.dart

import 'package:flutter/material.dart';

class PixelArtPainter extends CustomPainter {
  final double cloudOffsetX;
  final double rainOffsetX;

  PixelArtPainter({required this.cloudOffsetX, required this.rainOffsetX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Fundo azul
    paint.color = Colors.lightBlue;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Desenhar montanhas
    _drawMountains(canvas, size, paint);

    // Desenhar nuvens
    _drawClouds(canvas, paint);

    // Desenhar animais
    _drawAnimals(canvas, paint, size);
  }

  void _drawMountains(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.green; // Cor das montanhas
    Path mountainPath = Path();
    mountainPath.moveTo(0, size.height * 0.6);
    mountainPath.lineTo(size.width * 0.2, size.height * 0.4); // Montanha esquerda
    mountainPath.lineTo(size.width * 0.4, size.height * 0.6);
    mountainPath.lineTo(size.width * 0.5, size.height * 0.5); // Montanha do meio
    mountainPath.lineTo(size.width * 0.6, size.height * 0.6);
    mountainPath.lineTo(size.width * 0.8, size.height * 0.3); // Montanha direita
    mountainPath.lineTo(size.width, size.height * 0.6);
    mountainPath.lineTo(size.width, size.height);
    mountainPath.lineTo(0, size.height);
    mountainPath.close();

    // Desenhar as montanhas
    canvas.drawPath(mountainPath, paint);

    // Adicionar neve no topo das montanhas
    paint.color = Colors.white; // Cor da neve
    Path snowPath = Path();
    snowPath.moveTo(size.width * 0.2, size.height * 0.4); // Montanha esquerda
    snowPath.lineTo(size.width * 0.15, size.height * 0.45);
    snowPath.lineTo(size.width * 0.25, size.height * 0.45);
    snowPath.close();
    
    snowPath.moveTo(size.width * 0.5, size.height * 0.5); // Montanha do meio
    snowPath.lineTo(size.width * 0.45, size.height * 0.55);
    snowPath.lineTo(size.width * 0.55, size.height * 0.55);
    snowPath.close();
    
    snowPath.moveTo(size.width * 0.8, size.height * 0.3); // Montanha direita
    snowPath.lineTo(size.width * 0.75, size.height * 0.35);
    snowPath.lineTo(size.width * 0.85, size.height * 0.35);
    snowPath.close();

    // Desenhar a neve
    canvas.drawPath(snowPath, paint);
  }

  void _drawClouds(Canvas canvas, Paint paint) {
    paint.color = Colors.white; // Cor das nuvens
    // Nuvem esquerda
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 100, 100), radius: 40), paint);
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 130, 100), radius: 50), paint);
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 80, 100), radius: 50), paint);

    // Nuvem direita
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 300, 80), radius: 50), paint);
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 330, 80), radius: 60), paint);
    canvas.drawOval(Rect.fromCircle(center: Offset(cloudOffsetX + 280, 80), radius: 60), paint);
  }

  void _drawAnimals(Canvas canvas, Paint paint, Size size) {
    // Centralizar os animais
    double baseY = size.height - 100;

    // Desenhar uma vaca
    paint.color = Colors.black; // Cor do corpo da vaca
    canvas.drawRect(Rect.fromLTWH(size.width * 0.25, baseY - 30, 80, 40), paint); // Corpo
    paint.color = Colors.white; // Cor da neve
    canvas.drawRect(Rect.fromLTWH(size.width * 0.25 + 10, baseY - 50, 30, 10), paint); // Cabeça
    paint.color = Colors.black; // Olhos
    canvas.drawOval(Rect.fromLTWH(size.width * 0.25 + 15, baseY - 45, 5, 5), paint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.25 + 25, baseY - 45, 5, 5), paint);

    // Desenhar um cachorro
    paint.color = Colors.brown; // Cor do corpo do cachorro
    canvas.drawRect(Rect.fromLTWH(size.width * 0.45, baseY - 30, 60, 30), paint); // Corpo
    paint.color = Colors.black; // Cabeça
    canvas.drawOval(Rect.fromLTWH(size.width * 0.45 + 10, baseY - 50, 20, 20), paint); // Cabeça
    paint.color = Colors.white; // Olhos
    canvas.drawOval(Rect.fromLTWH(size.width * 0.45 + 15, baseY - 45, 5, 5), paint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.45 + 25, baseY - 45, 5, 5), paint);

    // Desenhar uma galinha
    paint.color = Colors.red; // Cor do corpo da galinha
    canvas.drawOval(Rect.fromLTWH(size.width * 0.65, baseY - 40, 50, 40), paint); // Corpo
    paint.color = Colors.yellow; // Cabeça
    canvas.drawOval(Rect.fromLTWH(size.width * 0.67, baseY - 80, 20, 20), paint); // Cabeça
    paint.color = Colors.black; // Olhos
    canvas.drawOval(Rect.fromLTWH(size.width * 0.68, baseY - 75, 5, 5), paint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.72, baseY - 75, 5, 5), paint);

    // Desenhar um gato
    paint.color = Colors.grey; // Cor do corpo do gato
    canvas.drawRect(Rect.fromLTWH(size.width * 0.85, baseY - 30, 50, 30), paint); // Corpo
    paint.color = Colors.black; // Cabeça
    canvas.drawOval(Rect.fromLTWH(size.width * 0.85 + 10, baseY - 50, 20, 20), paint); // Cabeça
    paint.color = Colors.white; // Olhos
    canvas.drawOval(Rect.fromLTWH(size.width * 0.85 + 15, baseY - 45, 5, 5), paint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.85 + 25, baseY - 45, 5, 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint sempre que há mudança
  }
}
