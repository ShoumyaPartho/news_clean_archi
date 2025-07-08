import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:news/core/error/exceptions.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/core/network/network_info.dart';
import 'package:news/features/news_feature/data/datasources/news_remote_data_source.dart';
import 'package:news/features/news_feature/data/models/article_model.dart';
import 'package:news/features/news_feature/data/models/news_response_model.dart';
import 'package:news/features/news_feature/data/models/source_model.dart';
import 'package:news/features/news_feature/data/repositories/article_repository_impl.dart';

import 'article_repository_impl_test.mocks.dart';

@GenerateMocks([NewsRemoteDataSource, NetworkInfo])

void main(){
  late ArticleRepositoryImpl repository;
  late MockNewsRemoteDataSource mockNewsRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final tSourceModel = SourceModel(id: 'test-source', name: 'Test Source');
  final tArticleModel = ArticleModel(
    source: tSourceModel,
    author: 'Test Author',
    title: 'Test Title',
    description: 'Test Description',
    url: 'http://test.com',
    urlToImage: 'http://test.com/image.jpg',
    publishedAt: '2023-01-01T00:00:00Z',
    content: 'Test Content',
  );
  final List<ArticleModel> tArticleModelList = [tArticleModel];

  final tNewsResponseModel = NewsResponseModel(
    status: 'ok',
    totalResults: 1,
    articles: tArticleModelList,
  );

  const tChannelName = 'bbc-news';
  const tCategoryName = 'general';

  setUp((){
    mockNewsRemoteDataSource = MockNewsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticleRepositoryImpl(remoteDataSource: mockNewsRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  group('ArticleRepositoryImpl - Device is online', (){
    setUp((){
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
    });

    group('getTopHeadlines', (){
      test('should return remote data from remote repository when call to remote repository is successful',
            () async {
          // arrange
          when(mockNewsRemoteDataSource.getTopHeadlines(any))
              .thenAnswer((_) async => tNewsResponseModel);

          // act
          final result = await repository.getTopHeadlines(tChannelName);

          // assert
          verify(mockNewsRemoteDataSource.getTopHeadlines(tChannelName));
          expect(result, equals(Right(tArticleModelList)));
        },
      );

      test('should return ServerException from remote repository when call to remote repository is unsuccessful',
            () async {
          // arrange
          when(mockNewsRemoteDataSource.getTopHeadlines(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getTopHeadlines(tChannelName);

          // assert
          verify(mockNewsRemoteDataSource.getTopHeadlines(tChannelName));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('getCategoryNews', (){
      test('should return remote data from remote repository when call to remote repository is successful',
            () async {
          // arrange
          when(mockNewsRemoteDataSource.getCategoryNews(any))
              .thenAnswer((_) async => tNewsResponseModel);

          // act
          final result = await repository.getCategoryNews(tCategoryName);

          // assert
          verify(mockNewsRemoteDataSource.getCategoryNews(tCategoryName));
          expect(result, equals(Right(tArticleModelList)));
        },
      );

      test('should return ServerException from remote repository when call to remote repository is unsuccessful',
            () async {
          // arrange
          when(mockNewsRemoteDataSource.getCategoryNews(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getCategoryNews(tChannelName);

          // assert
          verify(mockNewsRemoteDataSource.getCategoryNews(tChannelName));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });

  group('ArticleRepositoryImpl - Device is offline', (){
    setUp((){
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
    });

    group('getTopHeadlines', (){
      test('should return NetworkFailure when the device is offline',
            () async {
          // arrange

          // act
          final result = await repository.getTopHeadlines(tChannelName);

          // assert
          verifyZeroInteractions(mockNewsRemoteDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

    });

    group('getCategoryNews', (){
      test('should return NetworkFailure when device is offline',
            () async {
          // arrange

          // act
          final result = await repository.getCategoryNews(tCategoryName);

          // assert
          verifyZeroInteractions(mockNewsRemoteDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}