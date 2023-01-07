import 'package:flutter/material.dart';
import 'package:medium_flutter_unit_testing/provider/news_provider.dart';
import 'package:medium_flutter_unit_testing/service/news_api_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider(NewsApiService(http.Client())),
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewsProvider>(context, listen: false).loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App Flutter Demo"),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.state == ResultState.success) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final article = provider.articles[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(article.description),
                      ],
                    ),
                  ),
                );
              },
              itemCount: provider.articles.length,
            );
          } else {
            return const Center(
              child: Text("Failed to fetch data"),
            );
          }
        },
      ),
    );
  }
}
