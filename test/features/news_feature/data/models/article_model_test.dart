import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/news_feature/data/models/article_model.dart';
import 'package:news/features/news_feature/data/models/source_model.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';

void main() {
  const tSourceModel = SourceModel(id: 'bbc-news', name: 'BBC News');

  const tArticleModel = ArticleModel(
    source: tSourceModel,
    author: 'Test Author',
    title: 'Test Title',
    description: 'Test Description',
    url: 'http://test.com/article',
    urlToImage: 'http://test.com/image.jpg',
    publishedAt: '2024-07-08T12:00:00Z',
    content: 'Test Content',
  );

  final Map<String, dynamic> tArticleJson = {
    "source": {"id": "bbc-news", "name": "BBC News"},
    "author": "Test Author",
    "title": "Test Title",
    "description": "Test Description",
    "url": "http://test.com/article",
    "urlToImage": "http://test.com/image.jpg",
    "publishedAt": "2024-07-08T12:00:00Z",
    "content": "Test Content",
  };


  group('ArticleModel', () {
    test(
      'should be a subclass of ArticleEntity',
          () async {
        // Arrange

            // Act

        // Assert
        expect(tArticleModel, isA<ArticleEntity>());
      },
    );

    group('fromJson', () {
      test(
        'should return a valid ArticleModel when the JSON is valid',
            () async {
          // Arrange
          final Map<String, dynamic> jsonMap = tArticleJson;

          // Act
          final result = ArticleModel.fromJson(jsonMap);

          // Assert
          expect(result, equals(tArticleModel));
        },
      );

      test(
        'should return a valid ArticleModel with null values when JSON fields are null or missing',
            () async {
          // Arrange
          final Map<String, dynamic> jsonMap = {
            "source": null,
            "author": null,
            "title": null,
            "description": null,
            "url": null,
            "urlToImage": null,
            "publishedAt": null,
            "content": null,
          };

          // Act
          final result = ArticleModel.fromJson(jsonMap);

          // Assert
          const expectedArticleModel = ArticleModel(
            source: null,
            author: null,
            title: null,
            description: null,
            url: null,
            urlToImage: null,
            publishedAt: null,
            content: null,
          );
          expect(result, equals(expectedArticleModel));
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
            () async {
          // Arrange

          // Act
          final result = tArticleModel.toJson();

          // Assert
          expect(result, equals(tArticleJson));
        },
      );

    });
  });
}
