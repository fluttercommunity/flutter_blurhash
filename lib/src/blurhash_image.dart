import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;
import 'dart:ui' show hashValues;
import 'package:image/image.dart' as graphics;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

const _DEFAULT_SIZE = 32;

class BlurHashImage extends ImageProvider<BlurHashImage> {
  /// Creates an object that decodes a [blurHash] as an image.
  ///
  /// The arguments must not be null.
  const BlurHashImage(this.blurHash,
      {this.decodingWidth = _DEFAULT_SIZE,
      this.decodingHeight = _DEFAULT_SIZE,
      this.scale = 1.0})
      : assert(blurHash != null),
        assert(scale != null);

  /// The bytes to decode into an image.
  final String blurHash;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// Decoding definition
  final int decodingWidth;

  /// Decoding definition
  final int decodingHeight;

  @override
  Future<BlurHashImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<BlurHashImage>(this);
  }

  @override
  ImageStreamCompleter load(BlurHashImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(BlurHashImage key, DecoderCallback decode) async {
    assert(key == this);

    var bytes = await blurHashDecode(
      blurHash: blurHash,
      width: decodingWidth,
      height: decodingHeight,
    ).then((rs) {
      final img = graphics.Image.fromBytes(decodingWidth, decodingHeight, rs);
      return Uint8List.fromList(graphics.encodePng(img));
    });
    return decode(bytes);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is BlurHashImage &&
        other.blurHash == blurHash &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(blurHash.hashCode, scale);

  @override
  String toString() => '$runtimeType($blurHash, scale: $scale)';
}
