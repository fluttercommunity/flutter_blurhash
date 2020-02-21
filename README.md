# flutter_blurhash

Compact representation of a placeholder for an image.

See https://blurha.sh/ for a detailed explanation.

## Example

```dart
class BlurHashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("BlurHash"),
            ),
            body: Container(
              width: 800,
              child: AspectRatio(
                  aspectRatio: 1.6, child: BlurHash(hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I")),
            )),
      );

  const BlurHashApp();
}
```


