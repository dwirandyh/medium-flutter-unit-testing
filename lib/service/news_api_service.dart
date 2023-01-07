import 'dart:convert';

import 'package:medium_flutter_unit_testing/constant.dart';
import 'package:medium_flutter_unit_testing/model/article.dart';
import 'package:http/http.dart' as http;
import 'package:medium_flutter_unit_testing/model/news_response.dart';

class NewsApiService {
  final http.Client client;

  NewsApiService(this.client);

  Future<List<Article>> fetchArticle() async {
    final uri = Uri.parse(
        '$baseUrl/everything?q=flutter&apiKey=788576fa85e0490eacac2d580771d924');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return NewsResponse.fromJson(json.decode(response.body)).articles;
    } else {
      throw Error();
    }
  }
}
