import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List imageList = [];
  Future<void> fetchImage(String text) async {
    final response =
        await Dio().get('https://pixabay.com/api', queryParameters: {
      'key': '29109013-1519767de58acc407c24af782',
      'q': text,
      'image_type': 'photo',
      'per_page': 100,
    });
    print(response.data);
    imageList = response.data['hits'];
    setState(() {});
  }

  Future<void> shareImage(String url) async {
    final dir = await getTemporaryDirectory();

    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));

    // フォルダの中に image.png という名前でファイルを作り、そこに画像データを書き込みます。
    final imageFile =
        await File('${dir.path}/image.png').writeAsBytes(response.data);

    // path を指定すると share できます。
    await Share.shareFiles([imageFile.path]);
  }

  @override
  void initState() {
    fetchImage('いちご');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: TextField(
            onSubmitted: (text) {
              fetchImage(text);
            },
          ),
        ),
        body: GridView.builder(
            itemCount: imageList.length,
            // GridViewを設定する引数を指定
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisSpacing: 10, //ボックス左右間のスペース
              // mainAxisSpacing: 10, //ボックス上下間のスペース
              crossAxisCount: 3, //ボックスを横に並べる数
            ),
            itemBuilder: (context, index) {
              Map<String, dynamic> image = imageList[index];
              return InkWell(
                onTap: () async {
                  shareImage(image['webformatURL']);
                },
                child: Stack(
                  // StackFit.expand を与えると領域いっぱいに広がろうとします。
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image['previewURL'],
                      // BoxFit.cover を与えると領域いっぱいに広がろうとします。
                      fit: BoxFit.cover,
                    ),
                    Align(
                      // 左上ではなく右下に表示するようにします。
                      alignment: Alignment.bottomRight,
                      child: Container(
                          color: Colors.white,
                          child: Row(
                            // MainAxisSize.min を与えると必要最小限のサイズに縮小します。
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(image['likes'].toString()),
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 14,
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              );
            }));
  }
}
