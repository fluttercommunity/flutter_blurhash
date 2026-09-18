import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_test/flutter_test.dart';

const _hash = 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.';

Widget _host(Widget child, {required double devicePixelRatio}) => MediaQuery(
      data: MediaQueryData(
        devicePixelRatio: devicePixelRatio,
        size: const Size(400, 800),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(width: 200, height: 200, child: child),
        ),
      ),
    );

/// What PaintingBinding.handleMemoryPressure does when the platform reports
/// memory pressure.
Future<void> _dropImageCache(WidgetTester tester) async {
  PaintingBinding.instance.imageCache.clear();
  PaintingBinding.instance.imageCache.clearLiveImages();
  await tester.pump();
  await tester.idle();
  await tester.pump();
}

Future<void> _settleDecode(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pump();
}

void main() {
  testWidgets('survives the image cache being dropped while mounted',
      (WidgetTester tester) async {
    final errors = <Object>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details.exception);

    await tester.pumpWidget(
      _host(const BlurHash(hash: _hash), devicePixelRatio: 2),
    );
    await _settleDecode(tester);

    // Changing a dependency re-resolves the provider, which is what a rotation,
    // a keyboard, a brightness change or a safe area inset does.
    for (final devicePixelRatio in <double>[3, 2, 3]) {
      await _dropImageCache(tester);
      await tester.pumpWidget(
        _host(const BlurHash(hash: _hash), devicePixelRatio: devicePixelRatio),
      );
      await _settleDecode(tester);
    }

    FlutterError.onError = previousOnError;
    expect(errors, isEmpty);
  });

  testWidgets('disposes the decoded image when it is unmounted',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(const BlurHash(hash: _hash), devicePixelRatio: 2),
    );
    await _settleDecode(tester);

    final state = tester.state<BlurHashState>(find.byType(BlurHash));
    final decoded = state.debugDecodedImage;
    expect(decoded, isNotNull);
    expect(decoded!.debugDisposed, isFalse);

    await tester.pumpWidget(_host(const SizedBox.shrink(), devicePixelRatio: 2));
    await tester.pump();

    expect(decoded.debugDisposed, isTrue);
  });
}
