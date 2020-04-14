import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class BlurHash extends StatefulWidget {
  const BlurHash({
    Key key,
    this.hash,
    this.color = Colors.grey,
    this.imageFit = BoxFit.fill,
    this.decodingWidth = 32,
    this.decodingHeight = 32,
  })  : assert(color != null),
        assert(hash != null),
        assert(decodingWidth > 0),
        assert(decodingHeight != 0),
        super(key: key);

  final String hash;
  final Color color;
  final BoxFit imageFit;
  final int decodingWidth;
  final int decodingHeight;

  @override
  _BlurHashState createState() => _BlurHashState();
}

class _BlurHashState extends State<BlurHash> {
  Future<ui.Image> _image;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  @override
  void didUpdateWidget(BlurHash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hash != oldWidget.hash ||
        widget.decodingWidth != oldWidget.decodingWidth ||
        widget.decodingHeight != oldWidget.decodingHeight) {
      _decodeImage();
    }
  }

  void _decodeImage() {
    _image = blurHashDecode(
      blurHash: widget.hash,
      width: widget.decodingWidth,
      height: widget.decodingHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _image,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        return snapshot.hasData
            ? RawImage(image: snapshot.data, fit: widget.imageFit)
            : ColoredBox(color: widget.color);
      },
    );
  }
}
