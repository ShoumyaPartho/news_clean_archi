import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:news/core/error/exceptions.dart';
import 'package:news/features/news_feature/data/datasources/news_remote_data_source.dart';
import 'package:news/features/news_feature/data/models/news_response_model.dart';
import 'news_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])

void main(){
  late NewsRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  final tNewsResponseJson = {
    "status": "ok",
    "totalResults": 2,
    "articles": [
      {
        "source": {"id": "bbc-news", "name": "BBC News"},
        "author": "BBC News",
        "title": "Test Article 1",
        "description": "Description for test article 1.",
        "url": "http://test.com/article1",
        "urlToImage": "http://test.com/image1.jpg",
        "publishedAt": "2024-07-08T10:00:00Z",
        "content": "Content of test article 1."
      },
      {
        "source": {"id": "cnn", "name": "CNN"},
        "author": "CNN",
        "title": "Test Article 2",
        "description": "Description for test article 2.",
        "url": "http://test.com/article2",
        "urlToImage": "http://test.com/image2.jpg",
        "publishedAt": "2024-07-08T11:00:00Z",
        "content": "Content of test article 2."
      }
    ]
  };

  final tNewsResponseModel = NewsResponseModel.fromJson(tNewsResponseJson);

  setUp((){
    mockClient = MockClient();
    dataSource = NewsRemoteDataSourceImpl(client: mockClient);
  });

  group('getTopHeadlines', () {
    const tChannelName = 'bbc-news';
    final String apiKey = 'fa4a7af6c9274db6adfcbba99e0db83a';

    test(
      'should return NewsResponseModel when the response code is 200 (success)',
          () async {
        // Arrange
        when(mockClient.get(
          Uri.parse('https://newsapi.org/v2/top-headlines?sources=$tChannelName&apiKey=$apiKey'),
          headers: anyNamed('headers'),
        ))
            .thenAnswer((_) async => http.Response(json.encode(tNewsResponseJson), 200),
        );

        // Act
        final result = await dataSource.getTopHeadlines(tChannelName);

        // Assert
        verify(mockClient.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=$tChannelName&apiKey=$apiKey'),
          headers: {'Content-Type': 'application/json'},
        ));

        expect(result, equals(tNewsResponseModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other error',
          () async {
        // Arrange
        when(mockClient.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=$tChannelName&apiKey=$apiKey'),
          headers: anyNamed('headers'),
        ))
            .thenAnswer((_) async => http.Response('Something went wrong', 404),
        );

        // Act
        final call = dataSource.getTopHeadlines;

        // Assert
        expect(() => call(tChannelName), throwsA(isA<ServerException>()));
        // Verify that the mock client's get method was called exactly once
        verify(mockClient.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=$tChannelName&apiKey=$apiKey'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
  });

  group('getCategoryNews', () {
    const tCategory = 'sports';
    final String apiKey = 'fa4a7af6c9274db6adfcbba99e0db83a';

    test(
      'should return NewsResponseModel when the response code is 200 (success)',
          () async {
        // Arrange
        when(mockClient.get(
          Uri.parse('https://newsapi.org/v2/everything?q=$tCategory&apiKey=$apiKey'),
          headers: anyNamed('headers'),
        ))
            .thenAnswer((_) async => http.Response(json.encode(tNewsResponseJson), 200),
        );

        // Act
        final result = await dataSource.getCategoryNews(tCategory);

        // Assert
        verify(mockClient.get(
          Uri.parse('https://newsapi.org/v2/everything?q=$tCategory&apiKey=$apiKey'),
          headers: {'Content-Type': 'application/json'},
        ));
        expect(result, equals(tNewsResponseModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other error',
          () async {
        // Arrange
        when(mockClient.get(
          Uri.parse('https://newsapi.org/v2/everything?q=$tCategory&apiKey=$apiKey'),
          headers: anyNamed('headers'),
        )).
        thenAnswer((_) async => http.Response('Something went wrong', 404),
        );

        // Act
        final call = dataSource.getCategoryNews;

        // Assert
        expect(() => call(tCategory), throwsA(isA<ServerException>()));
        // Verify that the mock client's get method was called exactly once
        verify(mockClient.get(Uri.parse('https://newsapi.org/v2/everything?q=$tCategory&apiKey=$apiKey'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
  });
}