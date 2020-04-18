import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

const entries = [
  [
    r'f8C6M$9tcY,FKOR*00%2RPNaaKjZUawdv#K4$Ps:HXELTJ,@XmS2=yxuNGn%IoR*',
    'https://drivetribe.imgix.net/fvHsAWZPQVah0hivwdPPtw?w=1600&h=1067&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    'Red'
  ],
  [
    r'f86RZIxu4TITofx]jsaeayozofWB00RP?w%NayMxkDt8ofM_Rjt8_4tRD$IUWAxu',
    'https://drivetribe.imgix.net/G_Xtlr1RQXiEklCPX8auGw?w=2400&h=1350&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    'White'
  ],
  [
    r'LZG6p1{I^6rX}G=0jGR$Z|t7NLW,',
    'https://drivetribe.imgix.net/C8AqQLEWTMShpDF2QcABNQ?w=1600&h=1067&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    'Rainbow'
  ],
  [
    r'L371cr_3RKKFsqICIVNG00eR?d-r',
    'https://drivetribe.imgix.net/R7OHpnZoRvSvE5rB9ZaGrw?w=2400&h=1350&fm=webp&auto=compress&lossless=true&fit=crop&crop=faces',
    'Dark'
  ],
];

const duration = Duration(milliseconds: 800);

const radius = Radius.circular(12);

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: const BlurHashApp()));
}

class BlurHashApp extends StatelessWidget {
  const BlurHashApp({Key key}) : super(key: key);

  void onStarted() {
    print("Ready");
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
              deltaTop < (0.4 * viewPortDimension)
      //&& deltaBottom > (0.3 * viewPortDimension)
      );

  Container buildEntry(bool isInView, int idx) => Container(
      padding: EdgeInsets.only(left: 32, right: 500),
      height: 290,
      margin: const EdgeInsets.only(bottom: 4),
      child: isInView
          ? SynchronizedDisplay(hash: entries[idx][0], uri: entries[idx][1])
          : BlurHash(hash: entries[idx][0]));
}

class SynchronizedDisplay extends StatefulWidget {
  const SynchronizedDisplay({Key key, this.hash, this.uri}) : super(key: key);
  final String hash;
  final String uri;

  @override
  _SynchronizedDisplayState createState() => _SynchronizedDisplayState();
}

class _SynchronizedDisplayState extends State<SynchronizedDisplay>
    with SingleTickerProviderStateMixin {
  Animation<double> animatedWidth;
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final w = animatedWidth.value;

    return Stack(
      alignment: Alignment(1.225, 0.0),
      children: [
        Transform.translate(
          offset: Offset(w, 0),
          child: Container(
            width: 50,
            decoration: const BoxDecoration(
                color: Color(0xEEFFFFFF),
                borderRadius:
                    BorderRadius.only(topRight: radius, bottomRight: radius)),
          ),
        ),
        BlurHash(
          onStarted: onStarted,
          hash: widget.hash,
          image: widget.uri,
          duration: duration,
        ),
      ],
    );
  }

  void onStarted() {
    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: duration, vsync: this);
    final curved = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animatedWidth = Tween<double>(begin: -50, end: 0).animate(curved);
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
