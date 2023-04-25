import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
// ignore_for_file: avoid_dynamic_calls

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _images = <String>[];
  final int picturesLimit = 20;

  Future<void> _getImages() async {
    await dotenv.load();
    final Uri uri = Uri(
        scheme: 'https',
        host: 'api.unsplash.com',
        path: '/photos/random',
        queryParameters: <String, String>{
          'client_id': dotenv.env['UNSPLASH_API_KEY']!,
          'count': picturesLimit.toString()
        });
    final Request request = Request('GET', uri);
    final Map<String, String> headers = <String, String>{'Accept-Version': 'v1'};
    request.headers.addAll(headers);
    final Response response = await get(uri);

    final List<dynamic> map = jsonDecode(response.body) as List<dynamic>;

    setState(() {
      for (int i = 0; i < map.length; i++) {
        final Map<String, dynamic> image = map[i] as Map<String, dynamic>;
        _images.add(image['urls']['raw'] as String);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Image App'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == _images.length - 1 ? 0 : 16),
            child: Image.network(
              _images[index],
              height: 0.4 * MediaQuery.of(context).size.height,
              width: 0.2 * MediaQuery.of(context).size.width,
              fit: BoxFit.fitHeight,
            ),
          );
        },
      ),
    );
  }
}