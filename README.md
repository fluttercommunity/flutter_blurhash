# Flutter BlurHash
A Flutter plugin for Compact representation of a placeholder for an image.

## Usage
To use this plugin, add `flutter_blurhash` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).


## Generation

<img width="1211" alt="Capture d’écran 2020-02-21 à 19 11 56" src="https://user-images.githubusercontent.com/1295961/75059847-129d6800-54de-11ea-8832-d19ea58eb7eb.png">

You can use https://blurha.sh/ for testing or use any official api on your server side.


## Flutter Code Example

Constrain your widget render area and let BlurHash fill the pixels

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


