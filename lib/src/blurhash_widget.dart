import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image/image.dart' as graphics;

const _DEFAULT_SIZE = 32;

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
    this.onReady,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOut,
  })  : assert(color != null),
        assert(hash != null),
        assert(decodingWidth > 0),
        assert(decodingHeight != 0),
        super(key: key);

  /// Callback when hash is decoded
  final VoidCallback onDecoded;

  /// Callback when image is downloaded
  final VoidCallback onReady;

  /// Hash to decode
  final String hash;

  /// Displayed background color before decoding
  final Color color;

  /// How to fit decoded & downloaded image
  final BoxFit imageFit;

  /// Decoding definition
  final int decodingWidth;

  /// Decoding definition
  final int decodingHeight;

  /// Remote resource to download
  final String image;

  final Duration duration;

  final Curve curve;

  @override
  BlurHashState createState() => BlurHashState();
}

class BlurHashState extends State<BlurHash> {
  Future<Uint8List> _image;
  bool loaded;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _decodeImage();
    loaded = false;
  }

  @override
  void didUpdateWidget(BlurHash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hash != oldWidget.hash ||
        widget.image != oldWidget.image ||
        widget.decodingWidth != oldWidget.decodingWidth ||
        widget.decodingHeight != oldWidget.decodingHeight) {
      _init();
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
        if (loadingProgress == null) {
          // Image is now loaded, trigger the event
          loaded = true;
          widget.onReady?.call();
          return _DisplayImage(
            child: img,
            duration: widget.duration,
            curve: widget.curve,
          );
        } else {
          return const SizedBox();
        }
      });

  /// Decode the blurhash then display the resulting Image
  Widget buildBlurHashBackground() => FutureBuilder<Uint8List>(
        future: _image,
        builder: (ctx, snap) => snap.hasData
            ? Image(image: MemoryImage(snap.data), fit: widget.imageFit)
            : Container(color: widget.color),
      );
}

// Inner display details & controls
class _DisplayImage extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _DisplayImage(
      {@required this.child,
      this.duration = const Duration(milliseconds: 800),
      this.curve,
      Key key})
      : assert(duration != null),
        assert(curve != null),
        assert(child != null),
        super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<_DisplayImage>
    with SingleTickerProviderStateMixin {
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
    controller = AnimationController(duration: widget.duration, vsync: this);
    final curved = CurvedAnimation(parent: controller, curve: widget.curve);
    opacity = Tween<double>(begin: .0, end: 1.0).animate(curved);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
