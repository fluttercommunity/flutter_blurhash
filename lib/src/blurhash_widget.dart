import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/blurhash.dart';

class BlurHash extends StatelessWidget {
  final String hash;
  final Color color;

  const BlurHash({Key key, this.hash, this.color = Colors.grey})
      : assert(color != null),
        assert(hash != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
        future: BlurHashDecoder().decode(
          blurhash: hash,
          width: 32,
          height: 32,
        ),
        builder: (ctx, snap) => (snap.hasData)
            ? CustomPaint(
                painter: BlurHashPainter(img: snap.data),
              )
            : Container(
                constraints: BoxConstraints.expand(),
                color: color,
              ),
      );
}

class BlurHashPainter extends CustomPainter {
  final ui.Image img;

  const BlurHashPainter({this.img});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: img,
      fit: BoxFit.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
