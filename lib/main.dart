import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectmas/login_page.dart';
import 'package:projectmas/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AuthExampleApp());
}

class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image App',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: AuthTypeSelector(),
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthTypeSelector extends StatelessWidget {
  const AuthTypeSelector({Key? key}) : super(key: key);

  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Example App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SignInButtonBuilder(
              icon: Icons.person_add,
              backgroundColor: Colors.indigo,
              text: 'Registration',
              onPressed: () => _pushPage(context, const RegisterPage()),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SignInButtonBuilder(
              icon: Icons.verified_user,
              backgroundColor: Colors.orange,
              text: 'Sign In',
              onPressed: () => _pushPage(context, const LoginPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image App!',
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
      home: FirstRoute(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.text})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String text;

  @override
  State<MyHomePage> createState() => _MyHomePageState(text);
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> catImages = [];

  String _text = "cats";

  final ScrollController _pagingController = ScrollController();

  _MyHomePageState(String text) {
    _text = text;
  }

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

    String _url =
        'https://meme-api.herokuapp.com/gimme/' + _text.split(" ")[0] + '/5';

    final response = await http.get(Uri.parse(_url), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          catImages.add(jsonDecode(response.body)['memes'][i]['url']);
        }
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  Widget postWidget() {
    // log("HELLO");
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        controller: _pagingController,
        itemCount: catImages.length,
        itemBuilder: (context, index) {
          return Image.network(catImages[index], fit: BoxFit.fitWidth);
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
  FirstRoute({Key? key}) : super(key: key);

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Look up images!'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          ElevatedButton(
              child: const Text('Look up images'),
              onPressed: () {
                _sendDataToSecondScreen(context, myController.text);
              })
        ],
      )),
    );
  }

  void _sendDataToSecondScreen(BuildContext context, String text) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: text,
            text: text,
          ),
        ));
  }
}
