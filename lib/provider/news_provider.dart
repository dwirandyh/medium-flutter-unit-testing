import 'package:flutter/cupertino.dart';
import 'package:medium_flutter_unit_testing/model/article.dart';
import 'package:medium_flutter_unit_testing/service/news_api_service.dart';

enum ResultState { success, failed, loading }

class NewsProvider extends ChangeNotifier {
  final NewsApiService apiService;

  List<Article> articles = [];
  ResultState state = ResultState.loading;

  NewsProvider(this.apiService);

  Future<void> loadNews() async {
    state = ResultState.loading;
    notifyListeners();

    try {
      articles = await apiService.fetchArticle();
      state = ResultState.success;
    } catch (error) {
      state = ResultState.failed;
    }

    notifyListeners();
  }
}
