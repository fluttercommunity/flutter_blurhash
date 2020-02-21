import 'package:flutter/material.dart';
import 'package:flutter_blurhash/blurhash.dart';

const entries = [
  "qUOEC-oe?aNI^ht6E2xtxt%1NHxaoIjZofNH\$~RkjcocRja#WXWBaiNH%1RkIpbHWCoL~9xZoeRkE2oft7f6S1NHRkR+oeoeWCs.",
  "L5H2EC=PM+yV0g-mq.wG9c010J}I",
  "WGHU9B0IGM#3b^OZjP.6v2o;Ac-q00}~n6E8-nwiOiIEKQeb+]Om"
];

void main() {
  runApp(const BlurHashApp());
}

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
                  aspectRatio: 1.6, child: BlurHash(hash: entries[1])),
            )),
      );

  const BlurHashApp();
}
