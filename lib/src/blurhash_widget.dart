import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class BlurHash extends StatelessWidget {
  final String hash;
  final Color color;
  final BoxFit imageFit;
  final int decodingWidth;
  final int decodingHeight;

  const BlurHash(
      {Key key,
      this.hash,
      this.color = Colors.grey,
      this.imageFit = BoxFit.fill,
      this.decodingWidth = 32,
      this.decodingHeight = 32})
      : assert(color != null),
        assert(hash != null),
        assert(decodingWidth > 0),
        assert(decodingHeight != 0),
        super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
        future: BlurHashDecoder().decode(
          blurhash: hash,
          width: decodingWidth,
          height: decodingHeight,
        ),
        builder: (ctx, snap) => (snap.hasData)
            ? LayoutBuilder(
                builder: (ctx, cns) => CustomPaint(
                  painter: BlurHashPainter(
                      image: snap.data,
                      imageFit: imageFit,
                      renderSize: Size(cns.maxWidth, cns.maxHeight)),
                ),
              )
            : Container(
                color: color,
              ),
      );
}

class BlurHashPainter extends CustomPainter {
  final ui.Image image;
  final BoxFit imageFit;
  final Size renderSize;

  const BlurHashPainter({this.image, this.imageFit, this.renderSize});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    //print("Painting on $size");
    paintImage(
      canvas: canvas,
      rect: Offset.zero & renderSize,
      image: image,
      fit: imageFit,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
