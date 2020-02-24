import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

const entries = [
  // see how $ should be escaped
  "qUOEC-oe?aNI^ht6E2xtxt%1NHxaoIjZofNH\$~RkjcocRja#WXWBaiNH%1RkIpbHWCoL~9xZoeRkE2oft7f6S1NHRkR+oeoeWCs.",
  "L5H2EC=PM+yV0g-mq.wG9c010J}I",
  "WGHU9B0IGM#3b^OZjP.6v2o;Ac-q00}~n6E8-nwiOiIEKQeb+]Om",
  "LEHV6nWB2yk8pyo0adR*.7kCMdnj",
  "LGF5]+Yk^6#M@-5c,1J5@[or[Q6.",
  "L6Pj0^i_.AyE_3t7t7R**0o#DgR4",
  "LKO2?U%2Tw=w]~RBVZRi};RPxuwH",
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
              constraints: BoxConstraints.tight(Size(300, 650)),
              child: ListView.builder(
                  itemCount: entries.length,
                  itemExtent: 200,
                  itemBuilder: (ctx, idx) => Container(
                      constraints: BoxConstraints.tight(Size(180, 150)),
                      child: BlurHash(hash: entries[idx]))),
            )),
      );

  const BlurHashApp();
}
