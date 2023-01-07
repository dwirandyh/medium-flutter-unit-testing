import 'package:flutter_test/flutter_test.dart';
import 'package:medium_flutter_unit_testing/constant.dart';
import 'package:medium_flutter_unit_testing/model/article.dart';
import 'package:medium_flutter_unit_testing/model/source.dart';
import 'package:medium_flutter_unit_testing/service/news_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'news_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NewsApiService newsApiService;

  setUp(() {
    mockClient = MockClient();
    newsApiService = NewsApiService(mockClient);
  });

  final uri = Uri.parse(
      '$baseUrl/everything?q=flutter&apiKey=788576fa85e0490eacac2d580771d924');
  const jsonString = """
  {
	"status": "ok",
	"totalResults": 484,
	"articles": [{
		"source": {
			"id": null,
			"name": "ReadWrite"
		},
		"author": "Chris Gale",
		"title": "What Drives Choosing Flutter Over React Native?",
		"description": "For those looking at open-source options",
		"url": "https://readwrite.com/what-drives-choosing-flutter-over-react-native/",
		"urlToImage": "https://images.readwrite.com/wp-content/uploads/2022/11/Super-hero-3497522.jpg",
		"publishedAt": "2022-12-09T16:00:37Z",
		"content": "For those looking at open-source options for applications"
	}]
}
  """;
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

  test('should return a list of articles with success when status code is 200',
      () async {
    // arrange
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    // act
    final result = await newsApiService.fetchArticle();
    // assert
    expect(result, equals(articles));
    verify(mockClient.get(uri));
  });

  test('should throw an error when status code is not 200', () async {
    // arrange
    when(mockClient.get(uri)).thenAnswer((_) async => http.Response('', 404));
    // act
    final call = newsApiService.fetchArticle();
    // assert
    expect(() => call, throwsA(isA<Error>()));
    verify(mockClient.get(uri));
  });
}
