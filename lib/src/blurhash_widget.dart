import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image/image.dart' as graphics;

const _DEFAULT_SIZE = 64;

/// Display a Hash then fade to Image
class BlurHash extends StatefulWidget {
  const BlurHash({
    Key key,
    @required this.hash,
    this.color = Colors.blueGrey,
    this.imageFit = BoxFit.fill,
    this.decodingWidth = _DEFAULT_SIZE,
    this.decodingHeight = _DEFAULT_SIZE,
    this.image,
    this.onDecoded,
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 700),
    this.fadeInCurve = Curves.easeIn,
  })  : assert(color != null),
        assert(hash != null),
        assert(decodingWidth > 0),
        assert(decodingHeight != 0),
        super(key: key);

  /// Callback when hash is decoded
  final VoidCallback onDecoded;

  final String hash;
  final Color color;
  final BoxFit imageFit;
  final int decodingWidth;
  final int decodingHeight;
  final String image;

  /// The duration of the fade-out animation for the [placeholder].
  final Duration fadeOutDuration;

  /// The curve of the fade-out animation for the [placeholder].
  final Curve fadeOutCurve;

  /// The duration of the fade-Out animation for the [image].
  final Duration fadeInDuration;

  /// The curve of the fade-in animation for the [image].
  final Curve fadeInCurve;

  @override
  BlurHashState createState() => BlurHashState();
}

class BlurHashState extends State<BlurHash> {
  Future<Uint8List> _image;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  @override
  void didUpdateWidget(BlurHash oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO complete
    if (widget.hash != oldWidget.hash ||
        widget.image != oldWidget.image ||
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
    ).then((rs) {
      final img = graphics.Image.fromBytes(
          widget.decodingWidth, widget.decodingHeight, rs);
      return Uint8List.fromList(graphics.encodePng(img));
    }).then((value) {
      widget.onDecoded?.call();
      return value;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          buildBlurHashBackground(),
          if (widget.image != null) prepareDisplayedImage(),
        ],
      );

  Widget prepareDisplayedImage() =>
      Image.network(widget.image, fit: widget.imageFit, loadingBuilder:
          (BuildContext context, Widget img, ImageChunkEvent loadingProgress) {
        return loadingProgress == null ? Display(child: img) : SizedBox();
      });

  /// Decode the blurhash then display the resulting Image
  Widget buildBlurHashBackground() => FutureBuilder<Uint8List>(
        future: _image,
        builder: (ctx, snap) => snap.hasData
            ? Image(image: MemoryImage(snap.data), fit: widget.imageFit)
            : ColoredBox(color: widget.color),
      );
}

class Display extends StatefulWidget {
  final Widget child;

  const Display({this.child, Key key}) : super(key: key);

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  AnimationController controller;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: opacity,
        child: widget.child,
      );

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    opacity = Tween<double>(begin: .0, end: 1.0).animate(controller);

    controller.forward();
  }
}
