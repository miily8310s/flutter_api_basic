import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_basic/model/post.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPosts() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  final List<dynamic> jsonData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonData.map((dynamic item) => Post.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load Posts');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    // アプリ起動した一回のみしか発火しない
    super.initState();
    futurePosts = fetchPosts();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('API Basic'),
            ),
            body: Center(
              child: FutureBuilder(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: ListTile(
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(snapshot.data![index].body),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )));
  }
}
