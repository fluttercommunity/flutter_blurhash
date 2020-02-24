import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

class BlurHashDecoder {
  Future<ui.Image> decode(
      {String blurhash, int width, int height, double punch = 1.0}) {
    _validateBlurhash(blurhash);

    final sizeFlag = _decode83(blurhash[0]);
    final numY = (sizeFlag / 9).floor() + 1;
    final numX = (sizeFlag % 9) + 1;

    final quantisedMaximumValue = _decode83(blurhash[1]);
    final maximumValue = (quantisedMaximumValue + 1) / 166;

    final colors = List(numX * numY);

    for (var i = 0; i < colors.length; i++) {
      if (i == 0) {
        final value = _decode83(blurhash.substring(2, 6));
        colors[i] = _decodeDC(value);
      } else {
        final value = _decode83(blurhash.substring(4 + i * 2, 6 + i * 2));
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
            final basis =
                cos((pi * x * i) / width) * cos((pi * y * j) / height);
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
    ui.decodeImageFromPixels(
        Uint8List.view(pixels.buffer), width, height, ui.PixelFormat.rgba8888,
        (img) {
      completer.complete(img);
    });

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

  _validateBlurhash(String blurhash) {
    if (blurhash == null || blurhash.length < 6) {
      throw Exception("The blurhash string must be at least 6 characters");
    }

    final sizeFlag = _decode83(blurhash[0]);
    final numY = (sizeFlag / 9).floor() + 1;
    final numX = (sizeFlag % 9) + 1;

    if (blurhash.length != 4 + 2 * numX * numY) {
      throw Exception(
          "blurhash length mismatch: length is ${blurhash.length} but it should be ${4 + 2 * numX * numY}");
    }
  }

  int _sign(double n) => (n < 0 ? -1 : 1);

  double _signPow(double val, double exp) => _sign(val) * pow(val.abs(), exp);

  int _decode83(String str) {
    var value = 0;
    final runes = str.runes;
    for (var i = 0; i < runes.length; i++) {
      int code = runes.elementAt(i);
      final c = String.fromCharCode(code);
      final digit = _digitCharacters.indexOf(c);
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

  static const _digitCharacters = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "#",
    "\$",
    "%",
    "*",
    "+",
    ",",
    "-",
    ".",
    ":",
    ";",
    "=",
    "?",
    "@",
    "[",
    "]",
    "^",
    "_",
    "{",
    "|",
    "}",
    "~"
  ];
}
