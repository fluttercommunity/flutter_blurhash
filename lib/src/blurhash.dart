import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:meta/meta.dart';

Future<ui.Image> blurHashDecode({
  @required String blurHash,
  @required int width,
  @required int height,
  double punch = 1.0,
}) {
  assert(blurHash != null && width != null && height != null && punch != null);
  _validateBlurHash(blurHash);

  final sizeFlag = _decode83(blurHash[0]);
  final numY = (sizeFlag / 9).floor() + 1;
  final numX = (sizeFlag % 9) + 1;

  final quantisedMaximumValue = _decode83(blurHash[1]);
  final maximumValue = (quantisedMaximumValue + 1) / 166;

  final colors = List(numX * numY);

  for (var i = 0; i < colors.length; i++) {
    if (i == 0) {
      final value = _decode83(blurHash.substring(2, 6));
      colors[i] = _decodeDC(value);
    } else {
      final value = _decode83(blurHash.substring(4 + i * 2, 6 + i * 2));
      colors[i] = _decodeAC(value, maximumValue * punch);
    }
  }

  final bytesPerRow = width * 4;
  final pixels = Uint8ClampedList(bytesPerRow * height);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      var r = .0;
      var g = .0;
      var b = .0;

      for (int j = 0; j < numY; j++) {
        for (int i = 0; i < numX; i++) {
          final basis = cos((pi * x * i) / width) * cos((pi * y * j) / height);
          var color = colors[i + j * numX];
          r += color[0] * basis;
          g += color[1] * basis;
          b += color[2] * basis;
        }
      }

      final intR = _linearTosRGB(r);
      final intG = _linearTosRGB(g);
      final intB = _linearTosRGB(b);

      pixels[4 * x + 0 + y * bytesPerRow] = intR;
      pixels[4 * x + 1 + y * bytesPerRow] = intG;
      pixels[4 * x + 2 + y * bytesPerRow] = intB;
      pixels[4 * x + 3 + y * bytesPerRow] = 255;
    }
  }

  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(Uint8List.view(pixels.buffer), width, height, ui.PixelFormat.rgba8888, completer.complete);

  return completer.future;
}

double _sRGBToLinear(int value) {
  final v = value / 255;
  if (v <= 0.04045) {
    return v / 12.92;
  } else {
    return pow((v + 0.055) / 1.055, 2.4);
  }
}

int _linearTosRGB(double value) {
  final v = max(0, min(1, value));
  if (v <= 0.0031308) {
    return (v * 12.92 * 255 + 0.5).round();
  } else {
    return ((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5).round();
  }
}

void _validateBlurHash(String blurHash) {
  if (blurHash == null || blurHash.length < 6) {
    throw Exception('The blurhash string must be at least 6 characters');
  }

  final sizeFlag = _decode83(blurHash[0]);
  final numY = (sizeFlag / 9).floor() + 1;
  final numX = (sizeFlag % 9) + 1;

  if (blurHash.length != 4 + 2 * numX * numY) {
    throw Exception('blurhash length mismatch: length is ${blurHash.length} but '
        'it should be ${4 + 2 * numX * numY}');
  }
}

int _sign(double n) => (n < 0 ? -1 : 1);

double _signPow(double val, double exp) => _sign(val) * pow(val.abs(), exp);

int _decode83(String str) {
  var value = 0;
  final units = str.codeUnits;
  final digits = _digitCharacters.codeUnits;
  for (var i = 0; i < units.length; i++) {
    final code = units.elementAt(i);
    final digit = digits.indexOf(code);
    if (digit == -1) {
      throw ArgumentError.value(str, 'str');
    }
    value = value * 83 + digit;
  }
  return value;
}

List _decodeDC(int value) {
  final intR = value >> 16;
  final intG = (value >> 8) & 255;
  final intB = value & 255;
  return [_sRGBToLinear(intR), _sRGBToLinear(intG), _sRGBToLinear(intB)];
}

List _decodeAC(int value, double maximumValue) {
  final quantR = (value / (19 * 19)).floor();
  final quantG = (value / 19).floor() % 19;
  final quantB = value % 19;

  final List rgb = [
    _signPow((quantR - 9) / 9, 2.0) * maximumValue,
    _signPow((quantG - 9) / 9, 2.0) * maximumValue,
    _signPow((quantB - 9) / 9, 2.0) * maximumValue
  ];

  return rgb;
}

const _digitCharacters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#\$%*+,-.:;=?@[]^_{|}~";
