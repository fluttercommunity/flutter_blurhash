import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

const entries = [
  [
    'f8C6M\$9tcY,FKOR*00%2RPNaaKjZUawdv#K4\$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
    'https://drivetribe.imgix.net/fvHsAWZPQVah0hivwdPPtw?w=1600&h=1067&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    ''
  ],
  [
    'f86RZIxu4TITofx]jsaeayozofWB00RP?w%NayMxkDt8ofM_Rjt8_4tRD\$IUWAxu',
    'https://drivetribe.imgix.net/G_Xtlr1RQXiEklCPX8auGw?w=2400&h=1350&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
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
        child: InViewNotifierList(
            itemCount: entries.length,
            builder: (ctx, idx) => InViewNotifierWidget(
                id: '$idx',
                builder: (BuildContext context, bool isInView, Widget child) =>
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 256),
                      height: 290,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: isInView
                          ? BlurHash(
                              fadeInDuration:
                                  const Duration(milliseconds: 1800),
                              onDecoded: onDecoded,
                              hash: entries[idx][0],
                              image: entries[idx][1])
                          : BlurHash(
                              fadeInDuration:
                                  const Duration(milliseconds: 1800),
                              onDecoded: onDecoded,
                              hash: entries[idx][0]),
                    )),
            isInViewPortCondition: (double deltaTop, double deltaBottom,
                    double viewPortDimension) =>
                true
            //deltaTop < (0.5 * viewPortDimension)
            ),
      );
}
