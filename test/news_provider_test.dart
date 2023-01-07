import 'package:flutter_test/flutter_test.dart';
import 'package:medium_flutter_unit_testing/model/article.dart';
import 'package:medium_flutter_unit_testing/model/source.dart';
import 'package:medium_flutter_unit_testing/provider/news_provider.dart';
import 'package:medium_flutter_unit_testing/service/news_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_provider_test.mocks.dart';

@GenerateMocks([NewsApiService])
void main() {
  late MockNewsApiService mockNewsApiService;
  late NewsProvider newsProvider;
  int listenCount = 0;

  setUp(() {
    listenCount = 0;
    mockNewsApiService = MockNewsApiService();
    newsProvider = NewsProvider(mockNewsApiService)
      ..addListener(() {
        listenCount++;
      });
  });

  final articles = [
    Article(
      source: Source(id: null, name: "ReadWrite"),
      author: "Chris Gale",
      title: "What Drives Choosing Flutter Over React Native?",
      description: "For those looking at open-source options",
      url:
          "https://readwrite.com/what-drives-choosing-flutter-over-react-native/",
      urlToImage:
          "https://images.readwrite.com/wp-content/uploads/2022/11/Super-hero-3497522.jpg",
      publishedAt: DateTime.parse("2022-12-09T16:00:37Z"),
      content: "For those looking at open-source options for applications",
    )
  ];

  test(
      'should change state into success, and articles variable should be filled',
      () async {
    // arrange
    when(mockNewsApiService.fetchArticle()).thenAnswer((_) async => articles);
    // act
    await newsProvider.loadNews();
    // assert
    expect(newsProvider.state, equals(ResultState.success));
    expect(newsProvider.articles, equals(articles));
    expect(listenCount, equals(2));
    verify(mockNewsApiService.fetchArticle());
  });

  test('should change state into error', () async {
    // arrange
    when(mockNewsApiService.fetchArticle()).thenThrow(Error());
    // act
    await newsProvider.loadNews();
    // assert
    expect(newsProvider.state, equals(ResultState.failed));
    expect(listenCount, equals(2));
    verify(mockNewsApiService.fetchArticle());
  });
}
