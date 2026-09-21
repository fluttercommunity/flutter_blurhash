import 'dart:async';
import 'dart:ui' as ui;

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
      this.scale = 1.0});

  /// The bytes to decode into an image.
  final String blurHash;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// Decoding definition
  final int decodingWidth;

  /// Decoding definition
  final int decodingHeight;

  @override
  Future<BlurHashImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<BlurHashImage>(this);

  @override
  ImageStreamCompleter loadImage(
      BlurHashImage key, ImageDecoderCallback decode) {
    final image = _loadSync(key);
    if (image != null) {
      return OneFrameImageStreamCompleter(
          SynchronousFuture(ImageInfo(image: image, scale: key.scale)));
    }
    return OneFrameImageStreamCompleter(_loadAsync(key));
  }

  ui.Image? _loadSync(BlurHashImage key) {
    assert(key == this);

    try {
      return blurHashDecodeImageSync(
        blurHash: blurHash,
        width: decodingWidth,
        height: decodingHeight,
      );
    } catch (_) {
      // Let _loadAsync report the error through the image stream.
      return null;
    }
  }

  Future<ImageInfo> _loadAsync(BlurHashImage key) async {
    assert(key == this);

    final image = await blurHashDecodeImage(
      blurHash: blurHash,
      width: decodingWidth,
      height: decodingHeight,
    );
    return ImageInfo(image: image, scale: key.scale);
  }

  @override
  bool operator ==(Object other) => other.runtimeType != runtimeType
      ? false
      : other is BlurHashImage &&
          other.blurHash == blurHash &&
          other.scale == scale;

  @override
  int get hashCode => Object.hash(blurHash.hashCode, scale);

  @override
  String toString() => '$runtimeType($blurHash, scale: $scale)';
}
