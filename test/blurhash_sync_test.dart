import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_test/flutter_test.dart';

const _testHash = 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.';

void main() {
  test('blurHashDecodeImageSync returns an image or null if unsupported', () {
    final image = blurHashDecodeImageSync(
      blurHash: _testHash,
      width: 16,
      height: 8,
    );

    if (image != null) {
      expect(image.width, 16);
      expect(image.height, 8);
      image.dispose();
    }
  });

  test('blurHashDecodeImageSync throws on an invalid hash', () {
    expect(
      () => blurHashDecodeImageSync(blurHash: 'abc', width: 16, height: 16),
      throwsException,
    );
  });

  testWidgets('BlurHash shows an image in the first frame if sync decoding '
      'is supported', (tester) async {
    final syncSupported = blurHashDecodeImageSync(
          blurHash: _testHash,
          width: 1,
          height: 1,
        ) !=
        null;

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: BlurHash(hash: _testHash),
      ),
    );

    expect(find.byType(Image), syncSupported ? findsOneWidget : findsNothing);
  });

  testWidgets('BlurHashImage resolves', (tester) async {
    await tester.runAsync(() async {
      final stream =
          const BlurHashImage(_testHash).resolve(ImageConfiguration.empty);
      final info = await _firstImage(stream);
      expect(info.image.width, 32);
      expect(info.image.height, 32);
    });
  });
}

Future<ImageInfo> _firstImage(ImageStream stream) {
  final completer = Completer<ImageInfo>();
  late ImageStreamListener listener;
  listener = ImageStreamListener((info, _) {
    stream.removeListener(listener);
    completer.complete(info);
  }, onError: (error, stackTrace) {
    stream.removeListener(listener);
    completer.completeError(error, stackTrace);
  });
  stream.addListener(listener);
  return completer.future;
}
