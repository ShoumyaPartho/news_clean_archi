import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/news_feature/data/models/article_model.dart';
import 'package:news/features/news_feature/data/models/news_response_model.dart';
import 'package:news/features/news_feature/data/models/source_model.dart';

void main() {
  const tSourceModel = SourceModel(id: 'bbc-news', name: 'BBC News');

  const tArticleModel1 = ArticleModel(
    source: tSourceModel,
    author: 'Author 1',
    title: 'Title 1',
    description: 'Description 1',
    url: 'http://test.com/article1',
    urlToImage: 'http://test.com/image1.jpg',
    publishedAt: '2024-07-08T10:00:00Z',
    content: 'Content 1',
  );

  const tArticleModel2 = ArticleModel(
    source: tSourceModel,
    author: 'Author 2',
    title: 'Title 2',
    description: 'Description 2',
    url: 'http://test.com/article2',
    urlToImage: 'http://test.com/image2.jpg',
    publishedAt: '2024-07-08T11:00:00Z',
    content: 'Content 2',
  );

  final tNewsResponseModel = NewsResponseModel(
    status: 'ok',
    totalResults: 2,
    articles: [tArticleModel1, tArticleModel2],
  );

  final Map<String, dynamic> tNewsResponseJson = {
    "status": "ok",
    "totalResults": 2,
    "articles": [
      {
        "source": {"id": "bbc-news", "name": "BBC News"},
        "author": "Author 1",
        "title": "Title 1",
        "description": "Description 1",
        "url": "http://test.com/article1",
        "urlToImage": "http://test.com/image1.jpg",
        "publishedAt": "2024-07-08T10:00:00Z",
        "content": "Content 1"
      },
      {
        "source": {"id": "bbc-news", "name": "BBC News"},
        "author": "Author 2",
        "title": "Title 2",
        "description": "Description 2",
        "url": "http://test.com/article2",
        "urlToImage": "http://test.com/image2.jpg",
        "publishedAt": "2024-07-08T11:00:00Z",
        "content": "Content 2"
      }
    ]
  };

  group('NewsResponseModel', () {
    group('fromJson', () {
      test(
        'should return a valid NewsResponseModel when the JSON is valid',
            () async {
          // Arrange
          final Map<String, dynamic> jsonMap = tNewsResponseJson;

          // Act
          final result = NewsResponseModel.fromJson(jsonMap);

          // Assert
          expect(result, equals(tNewsResponseModel));
        },
      );

      test(
        'should return a valid NewsResponseModel with an empty articles list if articles JSON is empty',
            () async {
          // Arrange
          final Map<String, dynamic> jsonMap = {
            "status": "ok",
            "totalResults": 0,
            "articles": [],
          };

          // Act
          final result = NewsResponseModel.fromJson(jsonMap);

          // Assert
          const expectedNewsResponseModel = NewsResponseModel(
            status: 'ok',
            totalResults: 0,
            articles: [],
          );
          expect(result, equals(expectedNewsResponseModel));
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
            () async {
          // Act
          final result = tNewsResponseModel.toJson();

          // Assert
          expect(result, equals(tNewsResponseJson));
        },
      );
    });
  });
}
