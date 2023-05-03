import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:numberpicker/numberpicker.dart';
import 'models/picture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Picture> _images = <Picture>[];
  int _picturesLimit = 1;
  String? _queryText;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getImages();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double height = MediaQuery.of(context).size.height;
    final double offset = _scrollController.position.pixels;
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (!_isLoading && maxScrollExtent - offset < 3 * height) {
      _page++;
      _getImages();
    }
  }

  Future<void> _getImages() async {
    setState(() {
      _isLoading = true;
    });
    await dotenv.load();
    if (_page == 1) {
      _images.clear();
    }
    final Map<String, String> queryParameters = <String, String>{
      'client_id': dotenv.env['UNSPLASH_API_KEY']!,
      'count': _picturesLimit.toString()
    };

    if (_queryText != null) {
      queryParameters['query'] = _queryText!;
    }

    final Uri uri = Uri(
      scheme: 'https',
      host: 'api.unsplash.com',
      path: '/photos/random',
      queryParameters: queryParameters,
    );

    final Response response = await get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> map = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        for (int i = 0; i < map.length; i++) {
          final Map<String, dynamic> element = map[i] as Map<String, dynamic>;
          _images.add(Picture.fromJson(element));
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const DrawerHeader(
                child: Align(
                  child: Text(
                    'Filter Pictures',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  const Text('Number of pictures per search: ',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  NumberPicker(
                      minValue: 1,
                      maxValue: 20,
                      value: _picturesLimit,
                      onChanged: (int value) {
                        setState(() {
                          _picturesLimit = value;
                        });
                      })
                ],
              ),
              const Text(
                'Filter pictures by text',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? value) {
                    _queryText = value;
                  }),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _getImages();
                          _page = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black12,
                      ),
                      child: const Text(
                        'Refresh pictures',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Random Image App'),
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          final Picture picture = _images[index];
          return GridTile(
            footer: ColoredBox(
              color: Colors.black54,
              child: ListTile(
                title: Text(
                  picture.altDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  picture.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: Image.network(picture.urls.small, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
