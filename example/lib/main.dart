import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

const entries = [
  [
    r'f8C6M$9tcY,FKOR*00%2RPNaaKjZUawdv#K4$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
    'https://drivetribe.imgix.net/fvHsAWZPQVah0hivwdPPtw?w=1600&h=1067&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    ''
  ],
  [
    r'f86RZIxu4TITofx]jsaeayozofWB00RP?w%NayMxkDt8ofM_Rjt8_4tRD$IUWAxu',
    'https://drivetribe.imgix.net/G_Xtlr1RQXiEklCPX8auGw?w=2400&h=1350&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    ''
  ],
  [
    r'LZG6p1{I^6rX}G=0jGR$Z|t7NLW,',
    'https://drivetribe.imgix.net/C8AqQLEWTMShpDF2QcABNQ?w=1600&h=1067&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    ''
  ],
  [
    r'L371cr_3RKKFsqICIVNG00eR?d-r',
    'https://drivetribe.imgix.net/R7OHpnZoRvSvE5rB9ZaGrw?w=2400&h=1350&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    ''
  ],
];

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: const BlurHashApp()));
}

class BlurHashApp extends StatelessWidget {
  const BlurHashApp({Key key}) : super(key: key);

  void onDecoded() {
    print("Decoded");
  }

  @override
  Widget build(BuildContext context) => Center(
        child: buildInViewNotifierList(),
      );

  Widget buildList() => ListView.builder(
      itemCount: entries.length,
      itemBuilder: (ctx, idx) => buildEntry(true, idx));

  Widget buildInViewNotifierList() => InViewNotifierList(
      itemCount: entries.length + 2,
      builder: (ctx, idx) => InViewNotifierWidget(
          id: '$idx',
          builder: (BuildContext context, bool isInView, Widget child) {
            if (idx == 0) return SizedBox(height: 600);
            if (idx == entries.length + 1) return SizedBox(height: 800);

            return buildEntry(isInView, idx - 1);
          }),
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) =>
              deltaTop < (0.6 * viewPortDimension) &&
              deltaBottom > (0.3 * viewPortDimension));

  Container buildEntry(bool isInView, int idx) => Container(
        padding: EdgeInsets.symmetric(horizontal: 256),
        height: 290,
        margin: const EdgeInsets.only(bottom: 4),
        child: isInView
            ? BlurHash(
                fadeInDuration: const Duration(milliseconds: 1800),
                onDecoded: onDecoded,
                hash: entries[idx][0],
                image: entries[idx][1])
            : BlurHash(
                fadeInDuration: const Duration(milliseconds: 1800),
                onDecoded: onDecoded,
                hash: entries[idx][0]),
      );
}
