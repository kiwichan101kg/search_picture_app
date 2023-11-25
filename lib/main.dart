import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    Response response = await Dio().get(
        'https://pixabay.com/api/?key=29109013-1519767de58acc407c24af782&q=$text&image_type=photo');
    imageList = response.data['hits'];
    print(imageList);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchImage('ケーキ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            print(text);
            fetchImage(text);
          },
        ),
        foregroundColor: Colors.white,
        shadowColor: Colors.grey,
        backgroundColor: Colors.orange[300],
        elevation: 4, //appBar影
        leading: Icon(Icons.menu), // 左下アイコン
        actions: [Icon(Icons.add), Icon(Icons.clear)], //右下アイコン
        toolbarHeight: 100, //高さ調節
      ),
      body: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> image = imageList[index];
            return InkWell(
              onTap: () {
                print(image['likes']);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image['previewURL'],
                    fit: BoxFit.cover, // BoxFit.cover を与えると領域いっぱいに広がろうとします。
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
                            // 何の数字かわからないので 👍 アイコンを追加します。
                            const Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 14,
                            ),
                            Text(image['likes'].toString()),
                          ],
                        )),
                  ),
                ],
              ),
            );
            // return Image.asset('images/fox.png');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('追加ボタン'),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottonNav(),
    );
  }
}

class BottonNav extends StatelessWidget {
  const BottonNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Mail'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
      ],
    );
  }
}
