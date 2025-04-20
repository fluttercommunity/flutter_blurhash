import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

void main() => runApp(const BlurHashDemoApp());

class BlurHashDemoApp extends StatelessWidget {
  const BlurHashDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlurHash Variations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const BlurHashGridScreen(),
    );
  }
}

class BlurHashGridScreen extends StatelessWidget {
  const BlurHashGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BlurHashGrid(),
    );
  }
}

class BlurHashGrid extends StatelessWidget {
  const BlurHashGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Create list of all combinations from 1x1 to 10x10
    final List<Map<String, dynamic>> hashCombinations = [];

    for (int x = 1; x <= 9; x++) {
      for (int y = 1; y <= 9; y++) {
        hashCombinations.add({
          'x': x,
          'y': y,
          'hash': generateSampleHash(x, y),
          'label': '$x×$y',
        });
      }
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9, // 3 items per row
        childAspectRatio: 1.9, // Square items
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: hashCombinations.length,
      itemBuilder: (context, index) {
        final item = hashCombinations[index];

        return BlurHashGridItem(
          hash: item['hash'],
          label: item['label'],
        );
      },
    );
  }
}

class BlurHashGridItem extends StatelessWidget {
  final String hash;
  final String label;

  const BlurHashGridItem({
    required this.hash,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlurHash(
            hash: hash,
            duration: const Duration(milliseconds: 500),
            optimizationMode: BlurHashOptimizationMode.approximation,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// Generates a sample BlurHash for a specific combination of x and y components.
///
/// This function creates predictable but visually distinct hashes for each
/// combination of x and y components.
///
/// The function uses predefined sample hashes for varying component counts.
///
/// Parameters:
/// - `xComponents`: The number of horizontal components in the BlurHash.
/// - `yComponents`: The number of vertical components in the BlurHash.
///
/// Returns:
/// A string representing the generated BlurHash for the given component counts.
String generateSampleHash(int xComponents, int yComponents) {
  switch ('$xComponents,$yComponents') {
    case '1,1':
      return r'00C=c8';
    case '1,2':
      return r'9UC=c8^-';
    case '1,3':
      return r'IUC=c8^-%g';
    case '1,4':
      return r'RUC=c8^-%gx[';
    case '1,5':
      return r'aUC=c8^-%gx[o{';
    case '1,6':
      return r'jUC=c8^-%gx[o{bW';
    case '1,7':
      return r'sUC=c8^-%gx[o{bWNY';
    case '1,8':
      return r'$UC=c8^-%gx[o{bWNYR%';
    case '1,9':
      return r'=UC=c8^-%gx[o{bWNYR%fi';
    case '2,1':
      return r'10C=c800';
    case '2,2':
      return r'AUC=c89Y^-D$';
    case '2,3':
      return r'JUC=c89Y^-D$%gIT';
    case '2,4':
      return r'SUC=c89Y^-D$%gITx[Io';
    case '2,5':
      return r'bUC=c89Y^-D$%gITx[Ioo{Rj';
    case '2,6':
      return r'kUC=c89Y^-D$%gITx[Ioo{RjbWWC';
    case '2,7':
      return r'tUC=c89Y^-D$%gITx[Ioo{RjbWWCNYWV';
    case '2,8':
      return r'%UC=c89Y^-D$%gITx[Ioo{RjbWWCNYWVR%ay';
    case '2,9':
      return r'?UC=c89Y^-D$%gITx[Ioo{RjbWWCNYWVR%ayfiWV';
    case '3,1':
      return r'26C=c800_M';
    case '3,2':
      return r'BUC=c89Yxu^-D$xu';
    case '3,3':
      return r'KUC=c89Yxu^-D$xu%gITxa';
    case '3,4':
      return r'TUC=c89Yxu^-D$xu%gITxax[Ioof';
    case '3,5':
      return r'cUC=c89Yxu^-D$xu%gITxax[Ioofo{Rjj[';
    case '3,6':
      return r'lUC=c89Yxu^-D$xu%gITxax[Ioofo{Rjj[bWWCay';
    case '3,7':
      return r'uUC=c89Yxu^-D$xu%gITxax[Ioofo{Rjj[bWWCayNYWVjb';
    case '3,8':
      return r'*UC=c89Yxu^-D$xu%gITxax[Ioofo{Rjj[bWWCayNYWVjbR%ayoM';
    case '3,9':
      return r'@UC=c89Yxu^-D$xu%gITxax[Ioofo{Rjj[bWWCayNYWVjbR%ayoMfiWVoM';
    case '4,1':
      return r'36C=c800_Mra';
    case '4,2':
      return r'CUC=c89YxujG^-D$xua#';
    case '4,3':
      return r'LUC=c89YxujG^-D$xua#%gITxaj]';
    case '4,4':
      return r'UUC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;';
    case '4,5':
      return r'dUC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;o{Rjj[t7';
    case '4,6':
      return r'mUC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;o{Rjj[t7bWWCayof';
    case '4,7':
      return r'vUC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;o{Rjj[t7bWWCayofNYWVjbkB';
    case '4,8':
      return r'+UC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;o{Rjj[t7bWWCayofNYWVjbkBR%ayoMbF';
    case '4,9':
      return r'[UC=c89YxujG^-D$xua#%gITxaj]x[Ioofs;o{Rjj[t7bWWCayofNYWVjbkBR%ayoMbFfiWVoMa{';
    case '5,1':
      return r'46C=c800_MraMw';
    case '5,2':
      return r'DUC=c89YxujGWA^-D$xua#R%';
    case '5,3':
      return r'MUC=c89YxujGWA^-D$xua#R%%gITxaj]WB';
    case '5,4':
      return r'VUC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rj';
    case '5,5':
      return r'eUC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rjo{Rjj[t7R%';
    case '5,6':
      return r'nUC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rjo{Rjj[t7R%bWWCayofWB';
    case '5,7':
      return r'wUC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rjo{Rjj[t7R%bWWCayofWBNYWVjbkBWB';
    case '5,8':
      return r',UC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rjo{Rjj[t7R%bWWCayofWBNYWVjbkBWBR%ayoMbFay';
    case '5,9':
      return r']UC=c89YxujGWA^-D$xua#R%%gITxaj]WBx[Ioofs;Rjo{Rjj[t7R%bWWCayofWBNYWVjbkBWBR%ayoMbFayfiWVoMa{oL';
    case '6,1':
      return r'56C=c800_MraMw=y';
    case '6,2':
      return r'EUC=c89YxujGWAs:^-D$xua#R%W:';
    case '6,3':
      return r'NUC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-';
    case '6,4':
      return r'WUC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9';
    case '6,5':
      return r'fUC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9o{Rjj[t7R%oe';
    case '6,6':
      return r'oUC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9o{Rjj[t7R%oebWWCayofWBj[';
    case '6,7':
      return r'xUC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9o{Rjj[t7R%oebWWCayofWBj[NYWVjbkBWBj@';
    case '6,8':
      return r'-UC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9o{Rjj[t7R%oebWWCayofWBj[NYWVjbkBWBj@R%ayoMbFayf7';
    case '6,9':
      return r'^UC=c89YxujGWAs:^-D$xua#R%W:%gITxaj]WBW-x[Ioofs;Rjk9o{Rjj[t7R%oebWWCayofWBj[NYWVjbkBWBj@R%ayoMbFayf7fiWVoMa{oLWW';
    case '7,1':
      return r'66C=c800_MraMw=y=g';
    case '7,2':
      return r'FUC=c89YxujGWAs:sp^-D$xua#R%W:a~';
    case '7,3':
      return r'OUC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]';
    case '7,4':
      return r'XUC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oM';
    case '7,5':
      return r'gUC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oMo{Rjj[t7R%oeoM';
    case '7,6':
      return r'pUC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oMo{Rjj[t7R%oeoMbWWCayofWBj[j]';
    case '7,7':
      return r'yUC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oMo{Rjj[t7R%oeoMbWWCayofWBj[j]NYWVjbkBWBj@bH';
    case '7,8':
      return r'.UC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oMo{Rjj[t7R%oeoMbWWCayofWBj[j]NYWVjbkBWBj@bHR%ayoMbFayf7j[';
    case '7,9':
      return r'_UC=c89YxujGWAs:sp^-D$xua#R%W:a~%gITxaj]WBW-j]x[Ioofs;Rjk9oMo{Rjj[t7R%oeoMbWWCayofWBj[j]NYWVjbkBWBj@bHR%ayoMbFayf7j[fiWVoMa{oLWWoL';
    case '8,1':
      return r'76C=c800_MraMw=y=gTH';
    case '8,2':
      return r'GUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe';
    case '8,3':
      return r'PUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?';
    case '8,4':
      return r'YUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWV';
    case '8,5':
      return r'hUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWVo{Rjj[t7R%oeoMe:';
    case '8,6':
      return r'qUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWVo{Rjj[t7R%oeoMe:bWWCayofWBj[j]WC';
    case '8,7':
      return r'zUC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWVo{Rjj[t7R%oeoMe:bWWCayofWBj[j]WCNYWVjbkBWBj@bHWC';
    case '8,8':
      return r':UC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWVo{Rjj[t7R%oeoMe:bWWCayofWBj[j]WCNYWVjbkBWBj@bHWCR%ayoMbFayf7j[WU';
    case '8,9':
      return r'{UC=c89YxujGWAs:spba^-D$xua#R%W:a~oe%gITxaj]WBW-j]j?x[Ioofs;Rjk9oMWVo{Rjj[t7R%oeoMe:bWWCayofWBj[j]WCNYWVjbkBWBj@bHWCR%ayoMbFayf7j[WUfiWVoMa{oLWWoLjZ';
    case '9,1':
      return r'86C=c800_MraMw=y=gTHDj';
    case '9,2':
      return r'HUC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[';
    case '9,3':
      return r'QUC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jb';
    case '9,4':
      return r'ZUC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWV';
    case '9,5':
      return r'iUC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWVo{Rjj[t7R%oeoMe:ax';
    case '9,6':
      return r'rUC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWVo{Rjj[t7R%oeoMe:axbWWCayofWBj[j]WCk8';
    case '9,7':
      return r'#UC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWVo{Rjj[t7R%oeoMe:axbWWCayofWBj[j]WCk8NYWVjbkBWBj@bHWCoe';
    case '9,8':
      return r';UC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWVo{Rjj[t7R%oeoMe:axbWWCayofWBj[j]WCk8NYWVjbkBWBj@bHWCoeR%ayoMbFayf7j[WUf*';
    case '9,9':
      return r'|UC=c89YxujGWAs:spbaRj^-D$xua#R%W:a~oeV[%gITxaj]WBW-j]j?jbx[Ioofs;Rjk9oMWVWVo{Rjj[t7R%oeoMe:axbWWCayofWBj[j]WCk8NYWVjbkBWBj@bHWCoeR%ayoMbFayf7j[WUf*fiWVoMa{oLWWoLjZWp';
    default:
      return r'L6PZfSi8^6#M@-5c,1J5@[or[Q6.'; // Default fallback hash
  }
}
