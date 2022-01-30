import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Kitty App!';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitty App!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
        backgroundColor: const Color(0xFFD7CCC8),
        canvasColor: const Color(0xFFD7CCC8),
        cardColor: const Color(0xFFD7CCC8),
        shadowColor: const Color(0xFFD7CCC8),

      ),
      home: const FirstRoute(),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> catImages = [];

  final ScrollController _pagingController =
      ScrollController();

  @override
  void initState() {
    super.initState();
    fetchImages();
    _pagingController.addListener(() {
      fetchImages();
    });
  }

  fetchImages() async {
    Map<String, String>? requestHeaders = {
      "Access-Control-Allow-Origin": "*",
    };

    final response = await http.get(
      Uri.parse('https://meme-api.herokuapp.com/gimme/cats/5'),
      headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          catImages.add(jsonDecode(response.body)['memes'][i]['url']);
        }
      }
      );
    } else {
      throw Exception('Failed to load image');
    }
  }

  Widget postWidget() {
    // log("HELLO");
    final PageController controller = PageController();
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        controller: _pagingController,
        itemCount: catImages.length,
        itemBuilder: (context, index) {
          return Container(
            child: Image.network(catImages[index], fit: BoxFit.fitWidth),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: postWidget(),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Look up images'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Kitties!!!',)),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstRoute()),
            );
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}